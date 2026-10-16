<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.Contracts/tests/Get-ContractAssetKind.Tests.ps1
    folder: tests
    name: get-contract-asset-kind-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.Contracts
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    page: docs/references/automation/catzc-base-contracts/tests/Get-ContractAssetKind.Tests.ps1.md
    cites:
      - ADR-REPO-CONTRACT#6
---
#>

Describe 'Get-ContractAssetKind' -Tag 'L0', 'logic', 'ADR-REPO-CONTRACT#6' {
    It 'reads <Name> (empty: <IsEmpty>) as <Kind>' -ForEach @(
        @{ Name = 'widget.yml'; IsEmpty = $false; Kind = 'Fragment' }
        @{ Name = 'widget.yml'; IsEmpty = $true; Kind = 'Presence' }
        @{ Name = '.gadget'; IsEmpty = $false; Kind = 'Fragment' }
        @{ Name = 'widget.yml.schema.json'; IsEmpty = $false; Kind = 'Schema' }
        @{ Name = 'widget.schema.json'; IsEmpty = $true; Kind = 'Schema' }
        @{ Name = 'gadget.sample.json'; IsEmpty = $false; Kind = 'Sample' }
        @{ Name = 'gadget.sample.yml'; IsEmpty = $true; Kind = 'Sample' }
        @{ Name = 'gadget.sample'; IsEmpty = $false; Kind = 'Fragment' }
        @{ Name = 'gadget.schema.yml'; IsEmpty = $false; Kind = 'Fragment' }
        @{ Name = 'gadget.SCHEMA.JSON'; IsEmpty = $false; Kind = 'Fragment' }
    ) {
        $kind = InModuleScope Catzc.Base.Contracts -Parameters @{ Name = $Name; IsEmpty = $IsEmpty } {
            param($Name, $IsEmpty)
            Get-ContractAssetKind -Name $Name -IsEmpty:$IsEmpty
        }
        $kind | Should -Be ([Catzc.Base.Contracts.ContractAssetKind] $Kind)
    }
}
