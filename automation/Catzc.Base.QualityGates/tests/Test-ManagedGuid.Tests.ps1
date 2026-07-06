Describe 'Test-ManagedGuid' -Tag 'L0', 'logic' {
    BeforeEach {
        Mock Get-Config {
            [ordered]@{ guids = [ordered]@{
                    fixture_alpha = [ordered]@{ guid = 'a1a7e577-ea70-0000-0000-000000000000'; description = 'alpha fixture tenant' }
                }
            }
        } -ParameterFilter { $Config -eq 'guids' } -ModuleName Catzc.Base.QualityGates
    }

    It 'returns $true for a registered guid' {
        Test-ManagedGuid 'a1a7e577-ea70-0000-0000-000000000000' | Should -BeTrue
    }

    It 'matches case-insensitively' {
        Test-ManagedGuid 'A1A7E577-EA70-0000-0000-000000000000' | Should -BeTrue
    }

    It 'returns $false for an unregistered guid' {
        # A random guid is definitionally unregistered — and leaves no tracked literal for the guid gate.
        Test-ManagedGuid ([guid]::NewGuid()) | Should -BeFalse
    }

    It 'agrees with Assert-ManagedGuid — one shared lookup' {
        $unregistered = [guid]::NewGuid()
        Test-ManagedGuid 'a1a7e577-ea70-0000-0000-000000000000' | Should -BeTrue
        { Assert-ManagedGuid 'a1a7e577-ea70-0000-0000-000000000000' } | Should -Not -Throw
        Test-ManagedGuid $unregistered | Should -BeFalse
        { Assert-ManagedGuid $unregistered } | Should -Throw
    }
}
