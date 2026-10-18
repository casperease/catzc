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
