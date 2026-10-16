<#
---
catzc:
  derived:
    path: automation/Catzc.Tooling.Provisioning/tests/Get-PackageTreePlan.Tests.ps1
    kind: pester-test
    language: powershell
    track: automation
    module: Catzc.Tooling.Provisioning
    relatives:
      page: docs/references/automation/catzc-tooling-provisioning/tests/Get-PackageTreePlan.Tests.ps1.md
      source: automation/Catzc.Tooling.Provisioning/private/Get-PackageTreePlan.ps1
    adrs:
      - ADR-AUTO-TEST#3
---
#>

Describe 'Get-PackageTreePlan' -Tag 'L0', 'logic' {
    BeforeAll {
        function Set-FixtureFile {
            param([string] $Path)
            [void][System.IO.Directory]::CreateDirectory([System.IO.Path]::GetDirectoryName($Path))
            [System.IO.File]::WriteAllText($Path, 'widget')
        }
        $script:source = Join-Path $TestDrive 'source'
        $script:destination = Join-Path $TestDrive 'destination'
        Set-FixtureFile (Join-Path $script:source 'usr/bin/widget')
        Set-FixtureFile (Join-Path $script:source 'usr/bin/gadget')
        Set-FixtureFile (Join-Path $script:source 'usr/share/widget/deep/gadget')
        Set-FixtureFile (Join-Path $script:destination 'usr/bin/gadget')

        $script:plan = InModuleScope Catzc.Tooling.Provisioning -Parameters @{ Source = $script:source; Destination = $script:destination } {
            param($Source, $Destination)
            Get-PackageTreePlan -Source $Source -Destination $Destination
        }
    }

    It 'lists the folders the destination lacks, parents first' {
        $script:plan.Directories | Should -Be @('usr/share', 'usr/share/widget', 'usr/share/widget/deep')
    }

    It 'lists the files the destination lacks as the ones to copy' {
        $script:plan.Files | Should -Be @('usr/bin/widget', 'usr/share/widget/deep/gadget')
    }

    It 'lists the files the destination already has as kept' {
        $script:plan.Kept | Should -Be @('usr/bin/gadget')
    }

    It 'changes nothing on disk' {
        [System.IO.File]::Exists((Join-Path $script:destination 'usr/bin/widget')) | Should -BeFalse
    }
}
