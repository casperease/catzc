# The protected-glob gate (ADR-PROTGLOB): session-memory skip of a repeated green scan over an unchanged
# globset; hash-before-scan via the pending-promote handshake; completely ignored in pipelines.
Describe 'Test-GlobSetProtection / Protect-GlobSet' -Tag 'L0', 'logic' {
    BeforeEach {
        Clear-GlobSetProtection
        $script:currentHash = 'a' * 64
        Mock Test-IsRunningInPipeline { $false } -ModuleName Catzc.Base.Globs
        Mock Get-GlobSetHash { $script:currentHash } -ModuleName Catzc.Base.Globs
        Mock Write-Message { } -ModuleName Catzc.Base.Globs
    }

    AfterAll {
        Clear-GlobSetProtection
    }

    It 'is unprotected before any green run' {
        Test-GlobSetProtection -Test 'spelling' -Name 'unit' | Should -BeFalse
    }

    It 'protects after query -> green -> promote, and skips the repeat' {
        Test-GlobSetProtection -Test 'spelling' -Name 'unit' | Should -BeFalse
        Protect-GlobSet -Test 'spelling' -Name 'unit'
        Test-GlobSetProtection -Test 'spelling' -Name 'unit' | Should -BeTrue
    }

    It 'unprotects when the globset identity changes' {
        Test-GlobSetProtection -Test 'spelling' -Name 'unit' | Should -BeFalse
        Protect-GlobSet -Test 'spelling' -Name 'unit'
        $script:currentHash = 'b' * 64
        Test-GlobSetProtection -Test 'spelling' -Name 'unit' | Should -BeFalse
    }

    It 'promotes the hash captured BEFORE the scan, not one computed at promote time' {
        Test-GlobSetProtection -Test 'spelling' -Name 'unit' | Should -BeFalse
        # an edit lands mid-scan: the identity moves between query and promote
        $script:currentHash = 'b' * 64
        Protect-GlobSet -Test 'spelling' -Name 'unit'
        # the recorded identity is the pre-scan one, so the changed tree is NOT protected
        Test-GlobSetProtection -Test 'spelling' -Name 'unit' | Should -BeFalse
    }

    It 'keys protection by test AND globset' {
        Test-GlobSetProtection -Test 'spelling' -Name 'unit' | Should -BeFalse
        Protect-GlobSet -Test 'spelling' -Name 'unit'
        Test-GlobSetProtection -Test 'markdown' -Name 'unit' | Should -BeFalse
    }

    It 'never reads protection in a pipeline' {
        Test-GlobSetProtection -Test 'spelling' -Name 'unit' | Should -BeFalse
        Protect-GlobSet -Test 'spelling' -Name 'unit'
        Mock Test-IsRunningInPipeline { $true } -ModuleName Catzc.Base.Globs
        Test-GlobSetProtection -Test 'spelling' -Name 'unit' | Should -BeFalse
    }

    It 'never records protection in a pipeline' {
        Mock Test-IsRunningInPipeline { $true } -ModuleName Catzc.Base.Globs
        Protect-GlobSet -Test 'spelling' -Name 'unit'
        Mock Test-IsRunningInPipeline { $false } -ModuleName Catzc.Base.Globs
        Test-GlobSetProtection -Test 'spelling' -Name 'unit' | Should -BeFalse
    }

    It 'Protect-GlobSet works without a prior query (computes the hash itself)' {
        Protect-GlobSet -Test 'spelling' -Name 'unit'
        Test-GlobSetProtection -Test 'spelling' -Name 'unit' | Should -BeTrue
    }

    It 'Clear-GlobSetProtection forces the next run to scan' {
        Protect-GlobSet -Test 'spelling' -Name 'unit'
        Clear-GlobSetProtection
        Test-GlobSetProtection -Test 'spelling' -Name 'unit' | Should -BeFalse
    }

    It 'logs the skip with the globset and its short hash' {
        Protect-GlobSet -Test 'spelling' -Name 'unit'
        Test-GlobSetProtection -Test 'spelling' -Name 'unit' | Out-Null
        Should -Invoke Write-Message -ModuleName Catzc.Base.Globs -ParameterFilter {
            $Message -match 'spelling' -and $Message -match 'unit' -and $Message -match 'aaaaaaaa'
        }
    }

    Context '-Hash (a caller-computed composite identity)' {
        It 'keys on the supplied identity and never hashes a declared set' {
            Test-GlobSetProtection -Test 'suite' -Name 'Some.Module' -Hash ('c' * 64) | Should -BeFalse
            Protect-GlobSet -Test 'suite' -Name 'Some.Module'
            Test-GlobSetProtection -Test 'suite' -Name 'Some.Module' -Hash ('c' * 64) | Should -BeTrue
            Should -Invoke Get-GlobSetHash -ModuleName Catzc.Base.Globs -Exactly -Times 0
        }

        It 'unprotects when the supplied identity changes' {
            Test-GlobSetProtection -Test 'suite' -Name 'Some.Module' -Hash ('c' * 64) | Out-Null
            Protect-GlobSet -Test 'suite' -Name 'Some.Module'
            Test-GlobSetProtection -Test 'suite' -Name 'Some.Module' -Hash ('d' * 64) | Should -BeFalse
        }

        It 'promotes the queried (pre-run) identity, not a later -Hash' {
            Test-GlobSetProtection -Test 'suite' -Name 'Some.Module' -Hash ('c' * 64) | Out-Null
            Protect-GlobSet -Test 'suite' -Name 'Some.Module' -Hash ('d' * 64)   # pending wins (ADR-PROTGLOB:4)
            Test-GlobSetProtection -Test 'suite' -Name 'Some.Module' -Hash ('c' * 64) | Should -BeTrue
        }

        It 'records a direct -Hash protection when nothing is pending' {
            Protect-GlobSet -Test 'suite' -Name 'Some.Module' -Hash ('e' * 64)
            Test-GlobSetProtection -Test 'suite' -Name 'Some.Module' -Hash ('e' * 64) | Should -BeTrue
        }
    }
}
