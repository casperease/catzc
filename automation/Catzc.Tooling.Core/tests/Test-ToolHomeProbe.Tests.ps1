<#
---
catzc:
  derived:
    path: automation/Catzc.Tooling.Core/tests/Test-ToolHomeProbe.Tests.ps1
    kind: test
    language: powershell
    filekind: ps1
    track: automation
    module: Catzc.Tooling.Core
    relatives:
      source: automation/Catzc.Tooling.Core/private/Test-ToolHomeProbe.ps1
---
#>

Describe 'Test-ToolHomeProbe' -Tag 'L0', 'logic' {
    BeforeEach {
        $script:toolHome = Join-Path $TestDrive ([Guid]::NewGuid())
        [void][System.IO.Directory]::CreateDirectory($script:toolHome)
    }

    It 'matches a version directory that starts with the version and a dot' {
        [void][System.IO.Directory]::CreateDirectory((Join-Path $script:toolHome 'sdk/10.0.201'))
        InModuleScope Catzc.Tooling.Core -Parameters @{ ToolHome = $script:toolHome } {
            param($ToolHome)
            Test-ToolHomeProbe -ToolHome $ToolHome -Probe 'sdk/{version}' -Version '10.0'
        } | Should -BeTrue
    }

    It 'matches a version directory named exactly the version' {
        [void][System.IO.Directory]::CreateDirectory((Join-Path $script:toolHome 'shared/Widget.Runtime/10.0'))
        InModuleScope Catzc.Tooling.Core -Parameters @{ ToolHome = $script:toolHome } {
            param($ToolHome)
            Test-ToolHomeProbe -ToolHome $ToolHome -Probe 'shared/Widget.Runtime/{version}' -Version '10.0'
        } | Should -BeTrue
    }

    It 'does not match another version, or a name that only shares a prefix: <name>' -ForEach @(
        @{ name = '6.0.428' }
        @{ name = '10.01' }
        @{ name = '100.0.1' }
    ) {
        [void][System.IO.Directory]::CreateDirectory((Join-Path $script:toolHome "sdk/$name"))
        InModuleScope Catzc.Tooling.Core -Parameters @{ ToolHome = $script:toolHome } {
            param($ToolHome)
            Test-ToolHomeProbe -ToolHome $ToolHome -Probe 'sdk/{version}' -Version '10.0'
        } | Should -BeFalse
    }

    It 'returns false when the probe folder does not exist' {
        InModuleScope Catzc.Tooling.Core -Parameters @{ ToolHome = $script:toolHome } {
            param($ToolHome)
            Test-ToolHomeProbe -ToolHome $ToolHome -Probe 'sdk/{version}' -Version '10.0'
        } | Should -BeFalse
    }
}
