<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.VSCode/New-VSCodeExtensions.ps1
    name: new-vs-code-extensions
    filetype: ps1
    role: function
    subkind: writer
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.VSCode
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: pwsh/Catzc.Base.VSCode/tests/New-VSCodeExtensions.Tests.ps1
    docs: "[New-VSCodeExtensions.ps1.md](docs/references/pwsh/catzc-base-vscode/New-VSCodeExtensions.ps1.md)"
    cites:
      - ADR-REPO-FORMAT-CONFIGUREDFORMATTERS
      - ADR-REPO-ROOTCFG
---
#>

function New-VSCodeExtensions {
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
