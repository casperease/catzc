<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.Contracts/private/Get-ContractCommandRoot.ps1
    folder: private
    name: get-contract-command-root
    filetype: ps1
    role: function
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.Contracts
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    test: pwsh/Catzc.Base.Contracts/tests/Get-ContractCommandRoot.Tests.ps1
    docs: "[Get-ContractCommandRoot.ps1.md](docs/references/pwsh/catzc-base-contracts/private/Get-ContractCommandRoot.ps1.md)"
    cites:
      - ADR-AUTO-MODULE-DEPLOYABLETRACKMODULE
      - ADR-REPO-CMDCONTRACT-NOPLACEMENTFACTS
      - ADR-REPO-CMDCONTRACT-CHECKERPERLANGUAGE
---
#>

function Get-ContractCommandRoot {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [Parameter(Mandatory)]
        [string] $Module,

        [Parameter(Mandatory)]
        [string] $RepositoryRoot
    )

    $found = @(Get-CatzcModule -Name $Module -EngineTrack -RepositoryRoot $RepositoryRoot)
    if ($found.Count -ne 1) {
        throw "contract asset: no module named '$Module' in the code track, so its command contracts name no command file (ADR-REPO-CMDCONTRACT-NOPLACEMENTFACTS)."
    }
    if (@($found[0].languages) -cnotcontains 'powershell') {
        throw [System.NotImplementedException]::new("contract asset: the command contracts of '$Module' need a checker for its implementation language ($(@($found[0].languages) -join ', ')); only PowerShell commands are checked (ADR-REPO-CMDCONTRACT-CHECKERPERLANGUAGE).")
    }
    $found[0].root
}
