<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/tests/Get-TestDiscovery.Tests.ps1
    kind: pester-test
---
#>

Describe 'Get-TestDiscovery' -Tag 'L1', 'logic' {
    It 'discovers every test in the given folders without running any' {
        $testsFolder = Join-Path $TestDrive 'tests'
        [void][System.IO.Directory]::CreateDirectory($testsFolder)
        $fixtureContent = @'
Describe 'DiscoveryFixture' -Tag 'L0', 'logic' {
    It 'one' { throw 'discovery must never execute a test body' }
    It 'two' { throw 'discovery must never execute a test body' }
}
'@
        [System.IO.File]::WriteAllText((Join-Path $testsFolder 'DiscoveryFixture.Tests.ps1'), $fixtureContent)

        $discovery = InModuleScope Catzc.Base.QualityGates -Parameters @{ Path = $testsFolder } {
            param($Path)
            Get-TestDiscovery -TestPath $Path
        }

        # Both tests are discovered, none ran (the throwing bodies prove SkipRun held), and the block chain is live —...
        # [comment:1](/docs/references/automation/catzc-base-qualitygates/tests/Get-TestDiscovery.Tests.ps1.md#comment1)
        $discovery.Tests | Should -HaveCount 2
        @($discovery.Tests.Result) | Should -Be @('NotRun', 'NotRun')
        $discovery.Tests[0].Block.Tag | Should -Contain 'L0'
    }
}
