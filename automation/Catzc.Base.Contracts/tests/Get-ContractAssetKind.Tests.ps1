<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Contracts/tests/Get-ContractAssetKind.Tests.ps1
    kind: pester-test
    relatives:
      page: docs/references/automation/catzc-base-contracts/tests/Get-ContractAssetKind.Tests.ps1.md
      source: automation/Catzc.Base.Contracts/private/Get-ContractAssetKind.ps1
    adrs:
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
