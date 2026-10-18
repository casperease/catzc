<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.Contracts/private/Get-ContractCommandRoot.ps1
    folder: private
    name: get-contract-command-root
    filetype: ps1
    kind: function
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.Contracts
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: private
  edges:
    test: automation/Catzc.Base.Contracts/tests/Get-ContractCommandRoot.Tests.ps1
    cites:
      - ADR-AUTO-MODULE#1
      - ADR-REPO-CMDCONTRACT#{3,4}
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

    $found = @(Get-CatzcModule -Name $Module -TrackType modules -RepositoryRoot $RepositoryRoot)
    if ($found.Count -ne 1) {
        throw "contract asset: no module named '$Module' in the code track, so its command contracts name no command file (ADR-REPO-CMDCONTRACT#3)."
    }
    if (@($found[0].languages) -cnotcontains 'powershell') {
        throw [System.NotImplementedException]::new("contract asset: the command contracts of '$Module' need a checker for its implementation language ($(@($found[0].languages) -join ', ')); only PowerShell commands are checked (ADR-REPO-CMDCONTRACT#4).")
    }
    $found[0].root
}
