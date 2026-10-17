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
  config:
    synopsis: Returns the root folder of the module whose command contracts are being resolved, where its command files sit.
    description: |-
      A command contract names its command by placement
      ([ADR-REPO-CMDCONTRACT#3](/docs/adr/repository/command-contracts.md#rule-adr-repo-cmdcontract3)): the module folder
      is the owner, and the command's file is at the module's public slot under the module's root. The root comes from the
      one resolver of a module, Get-CatzcModule
      ([ADR-AUTO-MODULE#1](/docs/adr/automation/module-model.md#rule-adr-auto-module1)), looked up by name in the code
      track; no module of that name throws, naming the module. A module whose languages do not include PowerShell throws
      NotImplemented: only the PowerShell checker exists
      ([ADR-REPO-CMDCONTRACT#4](/docs/adr/repository/command-contracts.md#rule-adr-repo-cmdcontract4)).
    parameters:
      Module: The owning module's name, the asset's module folder.
      RepositoryRoot: The tree the module is resolved in.
    outputs: '[string] The module''s root, repository-relative and ''/''-separated.'
    examples:
      - Get-ContractCommandRoot -Module Catzc.Base.Languages -RepositoryRoot $root
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
