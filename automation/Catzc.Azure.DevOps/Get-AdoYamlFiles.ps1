<#
.SYNOPSIS
    Scans a directory recursively for YAML files and classifies each as Pipeline, Template, or Unknown.
.DESCRIPTION
    Finds all .yml and .yaml files under the specified path, parses each with
    ConvertFrom-Yaml, and uses top-level key heuristics to classify the file
    as an Azure DevOps pipeline, a template (with subtype), or unknown.

    Files that fail YAML parsing are included in the output with ParseError set
    and Classification set to Unknown.
.PARAMETER Path
    Root directory to scan. Defaults to the repository root via Get-RepositoryRoot.
.PARAMETER Exclude
    Directory names to skip during scanning. Matched as exact names anywhere in the path.
    Defaults to @('.git', 'node_modules', '.terraform').
.EXAMPLE
    Get-AdoYamlFiles -Path 'C:\repos\big-mono'
.EXAMPLE
    Get-AdoYamlFiles -Path 'C:\repos\big-mono' -Exclude @('.git', 'node_modules', 'vendor')
#>
function Get-AdoYamlFiles {
    [CmdletBinding()]
    [OutputType([PSCustomObject[]])]
    param(
        [string] $Path,

        [string[]] $Exclude = @('.git', 'node_modules', '.terraform')
    )

    $scanRoot = if ($Path) {
        $Path
    }
    else {
        Get-RepositoryRoot
    }
    Assert-NotNullOrWhitespace $scanRoot -ErrorText 'Path is required. Set -Path or ensure $env:RepositoryRoot is set.'
    Assert-PathExist $scanRoot

    $scanRoot = (Resolve-Path $scanRoot).Path

    Write-Message "Scanning for YAML files in: $scanRoot"

    # Recurse with [System.IO], PRUNING excluded directories during the walk rather than enumerating the whole
    # tree (including .git / node_modules / .terraform) and filtering after — Get-ChildItem -Recurse walks every
    # directory before the -Exclude post-filter ran, which dominated the scan. Raw .NET enumeration also avoids
    # ~20ms/call cmdlet overhead (ADR-TEST:18).
    $excludeSet = [System.Collections.Generic.HashSet[string]]::new(
        [string[]]$Exclude, [System.StringComparer]::OrdinalIgnoreCase)
    $ret = [System.Collections.Generic.List[string]]::new()
    $pending = [System.Collections.Generic.Stack[string]]::new()
    $pending.Push($scanRoot)
    while ($pending.Count -gt 0) {
        $directory = $pending.Pop()
        foreach ($subdirectory in [System.IO.Directory]::EnumerateDirectories($directory)) {
            if (-not $excludeSet.Contains([System.IO.Path]::GetFileName($subdirectory))) {
                $pending.Push($subdirectory)
            }
        }
        foreach ($filePath in [System.IO.Directory]::EnumerateFiles($directory)) {
            $extension = [System.IO.Path]::GetExtension($filePath)
            if ($extension -ieq '.yml' -or $extension -ieq '.yaml') {
                $ret.Add($filePath)
            }
        }
    }

    Write-Message "Found $($ret.Count) YAML files"

    foreach ($file in $ret) {
        $relativePath = $file.Substring($scanRoot.Length).TrimStart([IO.Path]::DirectorySeparatorChar, '/') -replace '\\', '/'
        $relativeDirectory = Split-Path $relativePath -Parent
        if ($relativeDirectory) {
            $relativeDirectory = $relativeDirectory -replace '\\', '/'
        }

        $yaml = $null
        $parseError = $null
        $topLevelKeys = @()

        try {
            $content = [System.IO.File]::ReadAllText($file)

            if ([string]::IsNullOrWhiteSpace($content)) {
                $parseError = 'File is empty'
            }
            else {
                # ADO template expressions (${{ if }}, ${{ each }}, ${{ parameters.x }})
                # are not valid YAML. Neutralize them so the parser can extract top-level keys.
                # Each replacement must be unique to avoid duplicate-key errors.
                $counter = @{ i = 0 }
                $sanitized = [regex]::Replace($content, '\$\{\{.+?\}\}', { $counter.i++; "__ado_expr_$($counter.i)__" })
                $yaml = $sanitized | ConvertFrom-Yaml -Ordered
            }
        }
        catch {
            $parseError = $_.Exception.Message
        }

        if ($yaml -is [System.Collections.IDictionary]) {
            $topLevelKeys = @($yaml.Keys)
        }

        $result = Resolve-AdoYamlClassification -Yaml $yaml

        [Catzc.Azure.DevOps.YamlFileRecord]::new(
            $scanRoot, $file, $relativePath, $relativeDirectory,
            $result.Classification, $result.TemplateType, $topLevelKeys, $parseError)
    }
}
