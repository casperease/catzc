<#
---
catzc:
  immutable:
    with_body_sha: "19beacbe3ab1"
  edges:
    test: pwsh/Catzc.Base.VSCode/tests/New-VSCodeExtensions.Tests.ps1
    docs: "[New-VSCodeExtensions.ps1.md](docs/references/pwsh/catzc-base-vs-code/New-VSCodeExtensions.ps1.md)"
    cites:
      - ADR-REPO-FORMAT-CONFIGUREDFORMATTERS
      - ADR-REPO-ROOTCFG
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
