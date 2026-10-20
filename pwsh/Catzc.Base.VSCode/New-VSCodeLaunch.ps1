<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.VSCode/New-VSCodeLaunch.ps1
    name: new-vs-code-launch
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
    test: pwsh/Catzc.Base.VSCode/tests/New-VSCodeLaunch.Tests.ps1
    docs: "[New-VSCodeLaunch.ps1.md](docs/references/pwsh/catzc-base-vscode/New-VSCodeLaunch.ps1.md)"
    cites:
      - ADR-REPO-ROOTCFG
---
#>

function New-VSCodeLaunch {
    [CmdletBinding()]
    [OutputType([string])]
    param()

    $config = Get-Config -Config vscode-launch

    $rendered = [ordered]@{
        version        = $config.version
        configurations = @($config.configurations | ForEach-Object { $_.fields })
    }

    (ConvertTo-Json -InputObject $rendered -Depth 8) + "`n"
}
