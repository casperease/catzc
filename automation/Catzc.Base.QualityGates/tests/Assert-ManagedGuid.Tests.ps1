Describe 'Assert-ManagedGuid' -Tag 'L0', 'logic' {
    BeforeEach {
        Mock Get-Config {
            [ordered]@{ guids = [ordered]@{
                    fixture_alpha = [ordered]@{ guid = 'a100a000-7e57-7e0a-0700-000000000000'; description = 'alpha fixture tenant' }
                }
            }
        } -ParameterFilter { $Config -eq 'guids' } -ModuleName Catzc.Base.QualityGates
    }

    It 'passes silently for a registered guid' {
        { Assert-ManagedGuid 'a100a000-7e57-7e0a-0700-000000000000' } | Should -Not -Throw
    }

    It 'matches case-insensitively' {
        { Assert-ManagedGuid 'A100A000-7E57-7E0A-0700-000000000000' } | Should -Not -Throw
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
