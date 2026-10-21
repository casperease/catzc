<#
---
catzc:
  immutable:
    with_body_sha: "6324cee7f3e5"
  edges:
    docs: "[Get-ContractAssetKind.Tests.ps1.md](../../../docs/references/pwsh/catzc-base-contracts/tests/Get-ContractAssetKind.Tests.ps1.md)"
    code: pwsh/Catzc.Base.Contracts/private/Get-ContractAssetKind.ps1
    cites:
      - ADR-REPO-CONTRACT-CONTRACTASSET
---
#>

Describe 'Get-ContractAssetKind' -Tag 'L0', 'logic', 'ADR-REPO-CONTRACT-CONTRACTASSET' {
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
        @{ Name = 'Get-Widget.command.yml'; IsEmpty = $false; Kind = 'Command' }
        @{ Name = 'Get-Widget.command.yml'; IsEmpty = $true; Kind = 'Command' }
        @{ Name = 'Get-Widget2.command.yml'; IsEmpty = $false; Kind = 'Command' }
        @{ Name = 'widget.command.yml'; IsEmpty = $false; Kind = 'Fragment' }
        @{ Name = 'Get-Widget.command.yaml'; IsEmpty = $false; Kind = 'Fragment' }
        @{ Name = 'Get-Widget.Command.yml'; IsEmpty = $false; Kind = 'Fragment' }
    ) {
        $kind = InModuleScope Catzc.Base.Contracts -Parameters @{ Name = $Name; IsEmpty = $IsEmpty } {
            param($Name, $IsEmpty)
            Get-ContractAssetKind -Name $Name -IsEmpty:$IsEmpty
        }
        $kind | Should -Be ([Catzc.Base.Contracts.ContractAssetKind] $Kind)
    }
}
