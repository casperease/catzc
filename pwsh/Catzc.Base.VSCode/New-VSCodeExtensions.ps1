<#
---
catzc:
  docs: "../../docs/references/pwsh/catzc-base-vs-code/New-VSCodeExtensions.ps1.md"
  warning: "Generated Header"
---
#>

function New-VsCodeExtensions {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [AllowEmptyCollection()]
        [string[]] $EngineExtension = @()
    )

    $config = Get-Config -Config vscode-extensions

    $recommendations = [System.Collections.Generic.List[string]]::new()
    foreach ($id in @($config.recommendations) + @($EngineExtension | Sort-Object)) {
        if (-not $recommendations.Contains($id)) {
            $recommendations.Add($id)
        }
    }
    $rendered = [ordered]@{
        recommendations = $recommendations.ToArray()
    }

    (ConvertTo-Json -InputObject $rendered -Depth 4) + "`n"
}
