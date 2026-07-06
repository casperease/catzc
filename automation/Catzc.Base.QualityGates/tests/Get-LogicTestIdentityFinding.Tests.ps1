Describe 'Get-LogicTestIdentityFinding' -Tag 'L0', 'logic' {
    BeforeAll {
        # A SYNTHETIC live-identity map: 'contoso' stands in for a live customer. It is deliberately NOT a real
        # shipped identity, so this very test file (which must contain the token to exercise the finder) is not
        # itself flagged by the real gate. The finder's logic is identical for any token set.
        $script:live = @{ contoso = [pscustomobject]@{ Token = 'contoso'; Kind = 'customer-key'; Source = 'customer.yml'; Suggest = 'a fixture customer (acme)' } }
        $script:find = {
            param([string] $Content, [string] $Name = 'Fixture.Tests.ps1')
            $path = Join-Path $TestDrive $Name
            [System.IO.File]::WriteAllText($path, $Content)
            & (Get-Module Catzc.Base.QualityGates) { Get-LogicTestIdentityFinding -Path $args[0] -LiveToken $args[1] } $path $script:live
        }
    }

    It 'flags a live identity used as a literal in a logic test' {
        $found = & $script:find @'
Describe 'X' -Tag 'L0', 'logic' {
    It 'a' { Do-Thing -Customer 'contoso' | Should -Be 1 }
}
'@
        @($found).Count | Should -Be 1
        $found[0].Token | Should -Be 'contoso'
        $found[0].Kind | Should -Be 'customer-key'
    }

    It 'does NOT flag a live identity inside an integrity-tagged block' {
        $found = & $script:find @'
Describe 'X' -Tag 'L0' {
    Context 'integrity (shipped)' -Tag 'integrity' {
        It 'a' { Do-Thing -Customer 'contoso' | Should -Be 1 }
    }
    Context 'logic (fixtures)' -Tag 'logic' {
        It 'b' { Do-Thing -Customer 'acme' | Should -Be 1 }
    }
}
'@
        @($found).Count | Should -Be 0
    }

    It 'flags a live identity in the LOGIC context of a mixed file, integrity carved out' {
        $found = & $script:find @'
Describe 'X' -Tag 'L0' {
    Context 'integrity' -Tag 'integrity' {
        It 'a' { Do-Thing -Customer 'contoso' | Should -Be 1 }
    }
    Context 'logic' -Tag 'logic' {
        It 'b' { Do-Thing -Customer 'contoso' | Should -Be 1 }
    }
}
'@
        @($found).Count | Should -Be 1
        $found[0].Line | Should -BeGreaterThan 4
    }

    It 'skips a *.Integrity.Tests.ps1 file by convention' {
        $found = & $script:find @'
Describe 'X' -Tag 'L0', 'logic' {
    It 'a' { Do-Thing -Customer 'contoso' | Should -Be 1 }
}
'@ 'Thing.Integrity.Tests.ps1'
        @($found).Count | Should -Be 0
    }

    It 'skips a pure-integrity file (no logic tag)' {
        $found = & $script:find @'
Describe 'X' -Tag 'L0', 'integrity' {
    It 'a' { Do-Thing -Customer 'contoso' | Should -Be 1 }
}
'@
        @($found).Count | Should -Be 0
    }

    It 'matches EXACTLY — a path segment does not trip the token' {
        $found = & $script:find @'
Describe 'X' -Tag 'logic' {
    It 'a' { Get-Item 'contoso/sub/main.bicep' | Should -Not -BeNullOrEmpty }
}
'@
        @($found).Count | Should -Be 0
    }

    It 'is comment-blind — a live identity in a comment is not a finding' {
        $found = & $script:find @'
Describe 'X' -Tag 'logic' {
    It 'a' {
        # unlike the real contoso customer, this uses a fixture
        Do-Thing -Customer 'acme' | Should -Be 1
    }
}
'@
        @($found).Count | Should -Be 0
    }
}
