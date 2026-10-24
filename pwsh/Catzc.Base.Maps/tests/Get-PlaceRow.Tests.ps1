Describe 'Get-PlaceRow' -Tag 'L0', 'logic' {
    BeforeAll {
        Mock Get-MinimapFact -ModuleName Catzc.Base.Maps {
            $facts = @{}
            foreach ($file in $Path) {
                $facts[$file] = if ($file -like 'widgets/*') {
                    @{ track = 'widgets'; module = 'Catzc.Widget.Cog' }
                }
                elseif ($file -like 'docs/*') {
                    @{ track = 'docs'; module = '' }
                }
                else {
                    @{ track = ''; module = '' }
                }
            }
            $facts
        }
    }

    It 'prints the place normal form of a path: the prefix dropped whole, the folder kept' {
        Get-PlaceRow 'widgets/Catzc.Widget.Cog/types/Get-Cog.cs' | Should -BeExactly 'widgets.widget_cog.types'
        Get-PlaceRow 'widgets/Catzc.Widget.Cog/Get-Cog.ps1' | Should -BeExactly 'widgets.widget_cog'
        Get-PlaceRow 'docs/explanation/ado/guide.md' | Should -BeExactly 'docs.explanation.ado'
    }

    It 'normalises the path first, so the same place reads the same however it is written' {
        Get-PlaceRow 'widgets\Catzc.Widget.Cog\.\types\Get-Cog.cs' | Should -BeExactly 'widgets.widget_cog.types'
    }

    It 'says nothing for a path outside every track' {
        Get-PlaceRow 'loose.txt' | Should -BeNullOrEmpty
    }

    It 'takes several paths, one row each' {
        @(Get-PlaceRow 'docs/explanation/guide.md', 'widgets/Catzc.Widget.Cog/Get-Cog.ps1').Count | Should -Be 2
    }
}
