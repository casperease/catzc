# The name rule of a contract asset's kind
# ([ADR-REPO-CONTRACT#6](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract6)): the suffix picks schema or sample,
# and any other name is a fragment, or a presence when empty.
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
