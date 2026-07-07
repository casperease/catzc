# cspell:ignore nlayer nsha  -- the escape-sequence artifacts in the "…`nlayer:…`nsha256:…" fixture strings
# The freshness query: Fresh/Stale/Missing per PERSISTED globset marker — one full-information YAML per set
# (ADR-GLOBS:9). Persistence is opt-out for declared sets and opt-in for derived ones (ADR-PROTGLOB:7): a
# non-persisted set carries no marker, so a leftover file is Unexpected and an absent one is no row at all.
# Plus Orphaned files (no globset owns them); clean exactly when every row is Fresh.
Describe 'Test-ShaMarker' -Tag 'L1', 'logic' {
    BeforeAll {
        Import-InternalModule TestKit
        $script:hashA = 'a' * 64
        $script:hashB = 'b' * 64
    }

    BeforeEach {
        $script:fake = New-FakeRepositoryRoot
        $script:markersDir = Join-Path $script:fake.Root '.sha-markers'
        New-Item -ItemType Directory -Path $script:markersDir -Force | Out-Null

        $script:config = [Catzc.Base.Globs.GlobsConfig]::new(@{
                globsets = [ordered]@{
                    'unit-a' = @{ description = 'd'; layer = 'deployable-unit'; include = @('src/**') }
                    'unit-b' = @{ description = 'd'; layer = 'deployable-unit'; include = @('docs/**') }
                }
            })
        $script:derivedSet = [Catzc.Base.Globs.GlobSet]::new(
            'mod-x', 'derived module scope', 'module', @('automation/Mod.X/**'), @(), @(), @(), -1, $null)
        Mock Get-Config { $script:config } -ModuleName Catzc.Base.Globs
        Mock Get-ModuleGlobSet { $script:derivedSet } -ModuleName Catzc.Base.Globs
        Mock Get-GlobSetHash { $script:hashA } -ModuleName Catzc.Base.Globs
        # The gate now folds a scoped-list SHA (scoped_sha256, ADR-GLOBS:11) beside the content SHA; fix the
        # member list so that scoped SHA is deterministic, and mirror it into the expected marker content.
        $script:members = @('src/a')
        Mock Get-GlobSetMember { $script:members } -ModuleName Catzc.Base.Globs
        $script:scopedA = [Catzc.Base.Globs.DurableHash]::HashPathList([string[]] $script:members)
        $script:count = @($script:members).Count
    }

    AfterEach {
        Remove-FakeRepositoryRoot $script:fake
    }

    It 'reports Fresh when the file carries the recomputed definition and hash' {
        [System.IO.File]::WriteAllText((Join-Path $script:markersDir 'unit-a.yml'), $script:config.Get('unit-a').MarkerContent($script:count, $script:scopedA, $script:hashA))
        $result = Test-ShaMarker -Name unit-a
        $result.Status | Should -Be 'Fresh'
        $result.Actual | Should -Match "sha256: $script:hashA"
    }

    It 'reports Stale when the sha256 line differs' {
        [System.IO.File]::WriteAllText((Join-Path $script:markersDir 'unit-a.yml'), $script:config.Get('unit-a').MarkerContent($script:count, $script:scopedA, $script:hashB))
        $result = Test-ShaMarker -Name unit-a
        $result.Status | Should -Be 'Stale'
        $result.Expected | Should -Match "sha256: $script:hashA"
        $result.Actual | Should -Match "sha256: $script:hashB"
    }

    It 'reports Stale when the definition body differs, even with a fresh hash' {
        [System.IO.File]::WriteAllText((Join-Path $script:markersDir 'unit-a.yml'), "name: unit-a`nlayer: scope`nsha256: $script:hashA`n")
        $result = Test-ShaMarker -Name unit-a
        $result.Status | Should -Be 'Stale'
        $result.Expected | Should -Be $script:config.Get('unit-a').MarkerContent($script:count, $script:scopedA, $script:hashA)
    }

    It 'reports Missing when no marker file exists' {
        $result = Test-ShaMarker -Name unit-a
        $result.Status | Should -Be 'Missing'
        $result.Actual | Should -BeNullOrEmpty
    }

    It 'reports Orphaned for a marker file with no globset, even on a named run' {
        [System.IO.File]::WriteAllText((Join-Path $script:markersDir 'dead-unit.yml'), "name: dead-unit`n")
        $result = @(Test-ShaMarker -Name unit-a)
        ($result | Where-Object Status -EQ 'Orphaned').Name | Should -Be 'dead-unit'
    }

    It 'covers declared sets on a full run and omits a non-persisted derived set with no marker' {
        [System.IO.File]::WriteAllText((Join-Path $script:markersDir 'unit-a.yml'), $script:config.Get('unit-a').MarkerContent($script:count, $script:scopedA, $script:hashA))
        $result = @(Test-ShaMarker)
        ($result | Where-Object Name -EQ 'unit-a').Status | Should -Be 'Fresh'
        ($result | Where-Object Name -EQ 'unit-b').Status | Should -Be 'Missing'
        # mod-x is derived and not opted in -> not persisted -> no marker on disc -> no row at all.
        ($result | Where-Object Name -EQ 'mod-x') | Should -BeNullOrEmpty
        $result.Count | Should -Be 2
    }

    It 'reports a non-persisted derived set''s leftover marker as Unexpected (never Orphaned)' {
        [System.IO.File]::WriteAllText((Join-Path $script:markersDir 'mod-x.yml'), $script:derivedSet.MarkerContent($script:count, $script:scopedA, $script:hashA))
        $result = @(Test-ShaMarker -Name mod-x)
        ($result | Where-Object Name -EQ 'mod-x').Status | Should -Be 'Unexpected'
        ($result | Where-Object Status -EQ 'Orphaned') | Should -BeNullOrEmpty
    }

    It 'persists a derived set opted in via persist_modules (Missing when absent, Fresh when present)' {
        $optedIn = [Catzc.Base.Globs.GlobsConfig]::new(@{
                globsets        = [ordered]@{
                    'unit-a' = @{ description = 'd'; layer = 'deployable-unit'; include = @('src/**') }
                }
                persist_modules = @('mod-x')
            })
        Mock Get-Config { $optedIn } -ModuleName Catzc.Base.Globs
        (Test-ShaMarker -Name mod-x).Status | Should -Be 'Missing'
        [System.IO.File]::WriteAllText((Join-Path $script:markersDir 'mod-x.yml'), $script:derivedSet.MarkerContent($script:count, $script:scopedA, $script:hashA))
        (Test-ShaMarker -Name mod-x).Status | Should -Be 'Fresh'
    }

    It 'treats a declared set with persist:false as not persisted — no row when absent, Unexpected when present' {
        $optedOut = [Catzc.Base.Globs.GlobsConfig]::new(@{
                globsets = [ordered]@{
                    'unit-a' = @{ description = 'd'; layer = 'deployable-unit'; include = @('src/**'); persist = $false }
                }
            })
        Mock Get-Config { $optedOut } -ModuleName Catzc.Base.Globs
        Test-ShaMarker -Name unit-a | Should -BeNullOrEmpty
        [System.IO.File]::WriteAllText((Join-Path $script:markersDir 'unit-a.yml'), "name: unit-a`n")
        (Test-ShaMarker -Name unit-a).Status | Should -Be 'Unexpected'
    }

    It 'is clean exactly when every persisted marker is Fresh and no leftover is present' {
        foreach ($setName in 'unit-a', 'unit-b') {
            [System.IO.File]::WriteAllText((Join-Path $script:markersDir "$setName.yml"), $script:config.Get($setName).MarkerContent($script:count, $script:scopedA, $script:hashA))
        }
        @(Test-ShaMarker | Where-Object Status -NE 'Fresh').Count | Should -Be 0
        # a leftover marker for the non-persisted derived set makes the tree unclean (Unexpected).
        [System.IO.File]::WriteAllText((Join-Path $script:markersDir 'mod-x.yml'), $script:derivedSet.MarkerContent($script:count, $script:scopedA, $script:hashA))
        @(Test-ShaMarker | Where-Object Status -NE 'Fresh').Count | Should -Be 1
    }
}
