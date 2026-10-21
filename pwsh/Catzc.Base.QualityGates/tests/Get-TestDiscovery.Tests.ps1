<#
---
catzc:
  immutable:
    with_body_sha: "7422ed38fd0e"
  edges:
    docs: "[Get-TestDiscovery.Tests.ps1.md](../../../docs/references/pwsh/catzc-base-quality-gates/tests/Get-TestDiscovery.Tests.ps1.md)"
    code: pwsh/Catzc.Base.QualityGates/private/Get-TestDiscovery.ps1
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

        $discovery.Tests | Should -HaveCount 2
        @($discovery.Tests.Result) | Should -Be @('NotRun', 'NotRun')
        $discovery.Tests[0].Block.Tag | Should -Contain 'L0'
    }
}
