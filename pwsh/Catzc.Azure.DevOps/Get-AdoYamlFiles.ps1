<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-azure-dev-ops/Get-AdoYamlFiles.ps1.md"
  warning: "Generated Header"
---
#>

function Get-AdoYamlFiles {
    [CmdletBinding()]
    [OutputType([PSCustomObject[]])]
    param(
        [string] $Path,

        [int] $Depth = (Get-Config -Config ado).yaml_inventory_depth
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

    # The bounded walker prunes the folder-walk config's folders (.git, node_modules, .terraform, …); the depth is the inventory's.
    $ret = @(Get-ChildPath $scanRoot -File -Filter '*.yml', '*.yaml' -Depth $Depth)

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
