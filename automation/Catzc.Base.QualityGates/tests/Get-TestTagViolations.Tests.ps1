Describe 'Get-TestTagViolations' -Tag 'L0', 'logic' {
    It 'flags tests missing or ambiguous on either axis, and passes fully-tagged tests' {
        InModuleScope Catzc.Base.QualityGates {
            $root = [pscustomobject]@{ IsRoot = $true; Tag = @(); Parent = $null }
            function New-FakeTest {
                param([string] $Name, [string[]] $Tags)
                [pscustomobject]@{
                    Tag          = @()
                    Block        = [pscustomobject]@{ IsRoot = $false; Tag = @($Tags); Parent = $root }
                    ExpandedName = $Name
                    ScriptBlock  = [pscustomobject]@{ File = 'fixture.Tests.ps1' }
                }
            }

            $discovered = [pscustomobject]@{
                Tests = @(
                    (New-FakeTest 'good' @('L1', 'logic'))
                    (New-FakeTest 'noTier' @('logic'))
                    (New-FakeTest 'noCategory' @('L2'))
                    (New-FakeTest 'ambiguousTier' @('L1', 'L2', 'logic'))
                )
            }

            $violations = Get-TestTagViolations -Discovery $discovered

            $violations | Should -HaveCount 3
            $violations.Test | Should -Not -Contain 'good'
            $violations.Test | Should -Contain 'noTier'
            $violations.Test | Should -Contain 'noCategory'
            $violations.Test | Should -Contain 'ambiguousTier'
            ($violations | Where-Object Test -EQ 'noTier').Reason | Should -BeLike '*tier resolves to 0*'
            ($violations | Where-Object Test -EQ 'ambiguousTier').Reason | Should -BeLike '*tier resolves to 2*L1,L2*'
        }
    }

    It 'tolerates a tag outside the two axes (the optional serial tag is not a violation)' {
        InModuleScope Catzc.Base.QualityGates {
            $root = [pscustomobject]@{ IsRoot = $true; Tag = @(); Parent = $null }
            $discovered = [pscustomobject]@{
                Tests = @(
                    [pscustomobject]@{
                        Tag          = @()
                        Block        = [pscustomobject]@{ IsRoot = $false; Tag = @('L1', 'logic', 'serial'); Parent = $root }
                        ExpandedName = 'taggedSerial'
                        ScriptBlock  = [pscustomobject]@{ File = 'fixture.Tests.ps1' }
                    }
                )
            }

            $violations = Get-TestTagViolations -Discovery $discovered
            $violations | Should -HaveCount 0
        }
    }

    It 'returns an empty array when every test is fully tagged' {
        InModuleScope Catzc.Base.QualityGates {
            $root = [pscustomobject]@{ IsRoot = $true; Tag = @(); Parent = $null }
            $clean = [pscustomobject]@{
                Tests = @(
                    [pscustomobject]@{
                        Tag          = @()
                        Block        = [pscustomobject]@{ IsRoot = $false; Tag = @('L1', 'integrity'); Parent = $root }
                        ExpandedName = 'ok'
                        ScriptBlock  = [pscustomobject]@{ File = 'fixture.Tests.ps1' }
                    }
                )
            }

            $violations = Get-TestTagViolations -Discovery $clean
            $violations | Should -HaveCount 0
        }
    }

    Context 'the optional ADR provenance axis' {
        BeforeAll {
            # A fixture rule-id set (registry ':' form) so the validation is hermetic — it never reads the
            # shipped ADR tree. Mocking the whole boundary function is the seam (ADR-TEST).
            Mock Get-CatsAdrRuleIds { @('ADR-ERROR:3', 'ADR-IDEM:1') } -ModuleName Catzc.Base.QualityGates

            # The fake discovery is plain data, so it is built here (Pester scope) and passed INTO InModuleScope
            # via -Parameters — a function defined here is not visible in the module's session state.
            function New-Discovery {
                param([string] $Name, [string[]] $Tags)
                $root = [pscustomobject]@{ IsRoot = $true; Tag = @(); Parent = $null }
                [pscustomobject]@{
                    Tests = @(
                        [pscustomobject]@{
                            Tag          = @()
                            Block        = [pscustomobject]@{ IsRoot = $false; Tag = @($Tags); Parent = $root }
                            ExpandedName = $Name
                            ScriptBlock  = [pscustomobject]@{ File = 'fixture.Tests.ps1' }
                        }
                    )
                }
            }
            $script:violate = { param($D) InModuleScope Catzc.Base.QualityGates -Parameters @{ D = $D } { param($D) Get-TestTagViolations -Discovery $D } }
        }

        It 'passes a well-formed citation that resolves to a real rule' {
            $v = & $script:violate (New-Discovery 'cites' @('L1', 'logic', 'ADR-ERROR#3'))
            @($v) | Should -HaveCount 0
        }

        It 'flags a malformed citation without consulting the rule-id set' {
            $v = & $script:violate (New-Discovery 'bad' @('L1', 'logic', 'ADR-ERROR:3'))
            @($v) | Should -HaveCount 1
            $v.Reason | Should -BeLike "*malformed ADR citation 'ADR-ERROR:3'*"
            Should -Invoke Get-CatsAdrRuleIds -ModuleName Catzc.Base.QualityGates -Times 0
        }

        It 'flags a well-formed citation that names no real rule' {
            $v = & $script:violate (New-Discovery 'ghost' @('L1', 'logic', 'ADR-ERROR#999'))
            @($v) | Should -HaveCount 1
            $v.Reason | Should -BeLike "*unknown ADR rule 'ADR-ERROR#999'*"
        }

        It 'does not consult the rule-id set when no test carries a citation (stays hermetic)' {
            $v = & $script:violate (New-Discovery 'plain' @('L1', 'logic'))
            @($v) | Should -HaveCount 0
            Should -Invoke Get-CatsAdrRuleIds -ModuleName Catzc.Base.QualityGates -Times 0
        }
    }
}
