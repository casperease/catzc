Describe 'Get-GeneratedWriterRow' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:row = {
            param([string] $Name)
            [Catzc.Base.Variants.GeneratedWriterRow]::new($Name, [ordered]@{ class = 'rollable'; outputs = @("docs/$Name.md") })
        }
    }

    BeforeEach {
        Mock Get-Config -ModuleName Catzc.Base.Languages -ParameterFilter { $ListOwners } {
            [pscustomobject]@{ Module = 'Catzc.Widget' }
            [pscustomobject]@{ Module = 'Catzc.Gadget' }
        }
        Mock Get-Config -ModuleName Catzc.Base.Languages -ParameterFilter { -not $ListOwners } {
            if ($Module -eq 'Catzc.Widget') {
                [pscustomobject]@{ writers = @((& $script:row 'Build-Widget'), (& $script:row 'Build-Twin')) }
            }
            else {
                [pscustomobject]@{ writers = @((& $script:row 'Build-Gadget'), (& $script:row 'Build-Twin')) }
            }
        }
    }

    It 'returns the one row of the named writer, from any module''s registry' {
        (& (Get-Module Catzc.Base.Languages) { Get-GeneratedWriterRow -Name Build-Gadget }).name | Should -BeExactly 'Build-Gadget'
    }

    It 'refuses a writer no row declares, and one two rows declare' {
        { & (Get-Module Catzc.Base.Languages) { Get-GeneratedWriterRow -Name Build-Gizmo } } | Should -Throw "*'Build-Gizmo' 0 times*"
        { & (Get-Module Catzc.Base.Languages) { Get-GeneratedWriterRow -Name Build-Twin } } | Should -Throw "*'Build-Twin' 2 times*"
    }
}
