<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Globs/tests/Test-GlobSetIndependence.Tests.ps1
    kind: pester-test
    adrs:
      - ADR-AUTO-TEST#3
      - ADR-AUTO-TEST#35
      - ADR-FLOW-CD-GLOBS#10
---
#>

# Test-GlobSetIndependence is a quality gate over per-layer independence.
# [comment:1](/docs/references/automation/catzc-base-globs/tests/Test-GlobSetIndependence.Tests.ps1.md#comment1)
Describe 'Test-GlobSetIndependence' -Tag 'L0', 'logic' {
    BeforeAll {
        # A globset fixture: Name, Layer, and SelectOwnMembers over the tracked files by path prefix.
        function New-FixtureSet {
            param([string] $Name, [string] $Layer, [string[]] $Prefixes)
            $set = [pscustomobject]@{ Name = $Name; Layer = $Layer; Prefixes = $Prefixes }
            $set | Add-Member -MemberType ScriptMethod -Name SelectOwnMembers -Value {
                param([string[]] $Tracked)
                $prefixes = $this.Prefixes
                @($Tracked | Where-Object { $path = $_; @($prefixes | Where-Object { $path.StartsWith($_) }).Count -gt 0 })
            }
            $set
        }
    }

    BeforeEach {
        $script:sets = @()
        Mock Get-GlobSet -ModuleName Catzc.Base.Globs { $script:sets }
        Mock Get-ModuleGlobSet -ModuleName Catzc.Base.Globs { @() }
        Mock Get-TrackedFile -ModuleName Catzc.Base.Globs { @('widget/a.ps1', 'widget/b.ps1', 'gadget/c.ps1', 'shared/d.md') }
        Mock Write-Message -ModuleName Catzc.Base.Reports { }
    }

    It 'passes when every same-layer pair is disjoint' -Tag 'ADR-AUTO-TEST#35' {
        $script:sets = @(
            (New-FixtureSet -Name widget -Layer module -Prefixes 'widget/')
            (New-FixtureSet -Name gadget -Layer module -Prefixes 'gadget/')
        )
        { Test-GlobSetIndependence -OutputFolder (Join-Path $TestDrive 'gi') } | Should -Not -Throw
    }

    It 'throws once listing every overlapping same-layer pair' -Tag 'ADR-AUTO-TEST#35' {
        $script:sets = @(
            (New-FixtureSet -Name widget -Layer module -Prefixes 'widget/', 'shared/')
            (New-FixtureSet -Name gadget -Layer module -Prefixes 'gadget/', 'shared/')
            (New-FixtureSet -Name widget-tst -Layer deployable-unit -Prefixes 'widget/')
            (New-FixtureSet -Name gadget-tst -Layer deployable-unit -Prefixes 'widget/a')
        )
        $thrown = { Test-GlobSetIndependence -OutputFolder (Join-Path $TestDrive 'gi') } | Should -Throw -PassThru
        $thrown.Exception.Message | Should -BeLike 'Test-GlobSetIndependence failed: 2 issue(s)*'
        $thrown.Exception.Message | Should -Match 'module: widget <-> gadget share 1 file\(s\), e\.g\. shared/d\.md'
        $thrown.Exception.Message | Should -Match 'deployable-unit: widget-tst <-> gadget-tst share 1 file\(s\)'
    }

    It 'returns the result with its facts under -PassThru' -Tag 'ADR-AUTO-TEST#35' {
        $script:sets = @(
            (New-FixtureSet -Name widget -Layer module -Prefixes 'widget/', 'shared/')
            (New-FixtureSet -Name gadget -Layer module -Prefixes 'shared/')
        )
        $result = Test-GlobSetIndependence -PassThru -OutputFolder (Join-Path $TestDrive 'gi')
        $result.Subject | Should -Be 'globset-independence'
        $result.IssueCount | Should -Be 1
        $result.GlobSets | Should -Be 2
        $result.Files | Should -Be 4
    }

    It 'does not check across layers' {
        $script:sets = @(
            (New-FixtureSet -Name widget -Layer module -Prefixes 'widget/')
            (New-FixtureSet -Name widget-tst -Layer deployable-unit -Prefixes 'widget/')
        )
        (Test-GlobSetIndependence -PassThru -OutputFolder (Join-Path $TestDrive 'gi')).IssueCount | Should -Be 0
    }

    It 'exempts the loose-fileset layer' {
        $script:sets = @(
            (New-FixtureSet -Name widget-scan -Layer loose-fileset -Prefixes 'widget/')
            (New-FixtureSet -Name gadget-scan -Layer loose-fileset -Prefixes 'widget/')
        )
        (Test-GlobSetIndependence -PassThru -OutputFolder (Join-Path $TestDrive 'gi')).IssueCount | Should -Be 0
    }

    It 'checks the derived module sets beside the declared registry' {
        $script:sets = @((New-FixtureSet -Name widget -Layer module -Prefixes 'widget/'))
        Mock Get-ModuleGlobSet -ModuleName Catzc.Base.Globs { New-FixtureSet -Name gadget -Layer module -Prefixes 'widget/b' }
        (Test-GlobSetIndependence -PassThru -OutputFolder (Join-Path $TestDrive 'gi')).Issues |
            Should -BeLike 'module: widget <-> gadget share 1 file(s)*'
    }
}
