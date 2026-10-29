# cspell:ignore gadg widg wdg nrt ganrtwdgwidgwidgear envfirst typefirst gearwdggadgwinrt
Describe 'ConvertFrom-AzureResourceName' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:sets = @{
            env        = @{ widget = 'wi'; gadget = 'ga' }
            region     = @('nrt')
            org        = @('wdg')
            short_name = @('gadg', 'widg')
        }
    }

    BeforeEach {
        Mock Get-Naming -ModuleName Catzc.Azure.Templates { 'envfirst' }
        Mock Get-AzureNameOrderSet -ModuleName Catzc.Azure.Templates {
            [ordered]@{
                envfirst  = @(@('env'), @('slot'), @('region'), @('org'), @('short_name'), @('customer'), @('role'), @('type'))
                typefirst = @(@('type'), @('org'), @('short_name'), @('customer'), @('env'), @('region'), @('slot'), @('role'))
            }
        }
        Mock Get-AzureResourceTypeSet -ModuleName Catzc.Azure.Templates { [ordered]@{ cog = @{ pattern = 'long' }; gear = @{ pattern = 'tight' } } }
        Mock Get-AzureNamePatternSet -ModuleName Catzc.Azure.Templates { [ordered]@{ long = @{ separator = '-' }; tight = @{ separator = '' } } }
    }

    It 'returns the components of a declared name under the naming variant' -Tag 'ADR-AZ-NAMING-ORDERISVARIANT' {
        $match = ConvertFrom-AzureResourceName -Name 'gadget-nrt-wdg-widg-wid-cog' -Type cog -CandidateSet $script:sets
        $match.env | Should -Be 'gadget'
        $match.short_name | Should -Be 'widg'
        $match.role | Should -Be 'wid'
        $match.type | Should -Be 'cog'
    }

    It 'matches under the -Order it is given' {
        $match = ConvertFrom-AzureResourceName -Name 'gearwdggadgwinrt' -Type gear -CandidateSet $script:sets -Order typefirst
        $match.env | Should -Be 'widget'
        $match.short_name | Should -Be 'gadg'
    }

    It 'tries every type when -Type is omitted' {
        (ConvertFrom-AzureResourceName -Name 'ganrtwdgwidgwidgear' -CandidateSet $script:sets).type | Should -Be 'gear'
    }

    It 'matches each name from the pipeline' {
        $results = @('gadget-nrt-wdg-widg-cog', 'widget-nrt-wdg-gadg-cog' | ConvertFrom-AzureResourceName -Type cog -CandidateSet $script:sets)
        $results.Count | Should -Be 2
        $results[1].env | Should -Be 'widget'
    }

    It 'throws the per-part diagnosis for a name that matches nothing' {
        { ConvertFrom-AzureResourceName -Name 'gadget-nrt-xyz-widg-cog' -Type cog -CandidateSet $script:sets } |
            Should -Throw '*matches no canonical form*org: none of (wdg) in the name*'
    }

    It 'refuses an unknown order' {
        { ConvertFrom-AzureResourceName -Name 'gadget-nrt-wdg-widg-cog' -CandidateSet $script:sets -Order sideways } |
            Should -Throw "*Unknown name order 'sideways' (known: envfirst, typefirst)*"
    }
}
