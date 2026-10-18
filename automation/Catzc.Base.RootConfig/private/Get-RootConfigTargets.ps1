<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.RootConfig/private/Get-RootConfigTargets.ps1
    folder: private
    name: get-root-config-targets
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.RootConfig
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    test: automation/Catzc.Base.RootConfig/tests/Get-RootConfigTargets.Tests.ps1
    cites:
      - ADR-REPO-ROOTCFG
---
#>

function Get-RootConfigTargets {
    [OutputType([object[]])]
    param(
        [Parameter(Mandatory)]
        $Config
    )

    @($Config.files | Where-Object { $_.optIn })
}
