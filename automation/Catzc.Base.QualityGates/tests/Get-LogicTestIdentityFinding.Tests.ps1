<#
---
catzc:
  immutable:
    path: automation/Catzc.Base.QualityGates/tests/Get-LogicTestIdentityFinding.Tests.ps1
    folder: tests
    name: get-logic-test-identity-finding-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    page: docs/references/automation/catzc-base-qualitygates/tests/Get-LogicTestIdentityFinding.Tests.ps1.md
---
#>

Describe 'Get-LogicTestIdentityFinding' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:live = @{
            contoso = [pscustomobject]@{ Token = 'contoso'; Kind = 'customer-key'; Source = 'customer.yml'; Suggest = 'a fixture customer (acme)'; MatchMode = 'exact' }
            staging = [pscustomobject]@{ Token = 'staging'; Kind = 'environment'; Source = 'azure.yml'; Suggest = 'a fixture environment (alpha)'; MatchMode = 'position' }
        }
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

    It 'does NOT flag a hashtable key that spells a live identity, but flags it as a value' {
        $found = & $script:find @'
Describe 'X' -Tag 'L0', 'logic' {
    It 'a' {
        $splat = @{ Contoso = $true; Name = 'contoso' }
        Do-Thing @splat | Should -Be 1
    }
}
'@
        @($found).Count | Should -Be 1
        $found[0].Line | Should -Be 3
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

    It 'flags an environment identity bound to an identity parameter (position match)' {
        $found = & $script:find @'
Describe 'X' -Tag 'logic' {
    It 'a' { Get-Thing -Environment 'staging' | Should -Be 1 }
}
'@
        @($found).Count | Should -Be 1
        $found[0].Token | Should -Be 'staging'
        $found[0].Kind | Should -Be 'environment'
    }

    It 'does NOT flag an environment name as a bare literal (position-only)' {
        $found = & $script:find @'
Describe 'X' -Tag 'logic' {
    It 'a' { $label = 'staging'; Write-Output $label }
}
'@
        @($found).Count | Should -Be 0
    }

    It 'does NOT flag an environment bound to -Environment inside an integrity block' {
        $found = & $script:find @'
Describe 'X' -Tag 'L0' {
    Context 'integrity' -Tag 'integrity' { It 'a' { Get-Thing -Environment 'staging' } }
    Context 'logic' -Tag 'logic' { It 'b' { Get-Thing -Environment 'alpha' } }
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
