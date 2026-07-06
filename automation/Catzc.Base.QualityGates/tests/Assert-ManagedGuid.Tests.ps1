Describe 'Assert-ManagedGuid' -Tag 'L0', 'logic' {
    BeforeEach {
        Mock Get-Config {
            [ordered]@{ guids = [ordered]@{
                    fixture_alpha = [ordered]@{ guid = 'a1a7e577-ea70-0000-0000-000000000000'; description = 'alpha fixture tenant' }
                }
            }
        } -ParameterFilter { $Config -eq 'guids' } -ModuleName Catzc.Base.QualityGates
    }

    It 'passes silently for a registered guid' {
        { Assert-ManagedGuid 'a1a7e577-ea70-0000-0000-000000000000' } | Should -Not -Throw
    }

    It 'matches case-insensitively' {
        { Assert-ManagedGuid 'A1A7E577-EA70-0000-0000-000000000000' } | Should -Not -Throw
    }

    It 'throws for an unregistered guid, naming it and the remediation' {
        # A random guid is definitionally unregistered — and leaves no tracked literal for the guid gate.
        $unregistered = [guid]::NewGuid()
        { Assert-ManagedGuid $unregistered } |
            Should -Throw "*$unregistered*not registered*guids.yml*"
    }

    It 'rejects a value that is not a guid at parameter binding' {
        { Assert-ManagedGuid -Guid 'not-a-guid' } | Should -Throw
    }
}
