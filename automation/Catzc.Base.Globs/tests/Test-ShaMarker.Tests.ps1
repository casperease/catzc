# cspell:ignore nlayer nsha  -- the escape-sequence artifacts in the "…`nlayer:…`nsha256:…" fixture strings
# The freshness query: Fresh/Stale/Missing per globset marker — one full-information YAML per set
# (ADR-GLOBS:9), declared AND derived (ADR-PROTGLOB:7) — plus Orphaned files; clean exactly when all Fresh.
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
    }

    AfterEach {
        Remove-FakeRepositoryRoot $script:fake
    }

    It 'reports Fresh when the file carries the recomputed definition and hash' {
        [System.IO.File]::WriteAllText((Join-Path $script:markersDir 'unit-a.yml'), $script:config.Get('unit-a').MarkerContent($script:hashA))
        $result = Test-ShaMarker -Name unit-a
        $result.Status | Should -Be 'Fresh'
        $result.Actual | Should -Match "sha256: $script:hashA"
    }

    It 'reports Stale when the sha256 line differs' {
        [System.IO.File]::WriteAllText((Join-Path $script:markersDir 'unit-a.yml'), $script:config.Get('unit-a').MarkerContent($script:hashB))
        $result = Test-ShaMarker -Name unit-a
        $result.Status | Should -Be 'Stale'
        $result.Expected | Should -Match "sha256: $script:hashA"
        $result.Actual | Should -Match "sha256: $script:hashB"
    }

    It 'reports Stale when the definition body differs, even with a fresh hash' {
        [System.IO.File]::WriteAllText((Join-Path $script:markersDir 'unit-a.yml'), "name: unit-a`nlayer: scope`nsha256: $script:hashA`n")
        $result = Test-ShaMarker -Name unit-a
        $result.Status | Should -Be 'Stale'
        $result.Expected | Should -Be $script:config.Get('unit-a').MarkerContent($script:hashA)
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

    It 'covers every globset — declared and derived — on a full run and never throws' {
        [System.IO.File]::WriteAllText((Join-Path $script:markersDir 'unit-a.yml'), $script:config.Get('unit-a').MarkerContent($script:hashA))
        $result = @(Test-ShaMarker)
        $result.Count | Should -Be 3
        ($result | Where-Object Name -EQ 'unit-a').Status | Should -Be 'Fresh'
        ($result | Where-Object Name -EQ 'unit-b').Status | Should -Be 'Missing'
        ($result | Where-Object Name -EQ 'mod-x').Status | Should -Be 'Missing'
    }

    It 'resolves a derived set by name and never reports its marker as orphaned' {
        [System.IO.File]::WriteAllText((Join-Path $script:markersDir 'mod-x.yml'), $script:derivedSet.MarkerContent($script:hashA))
        $result = @(Test-ShaMarker -Name mod-x)
        ($result | Where-Object Name -EQ 'mod-x').Status | Should -Be 'Fresh'
        ($result | Where-Object Status -EQ 'Orphaned') | Should -BeNullOrEmpty
    }

    It 'is clean exactly when everything is Fresh' {
        foreach ($setName in 'unit-a', 'unit-b') {
            [System.IO.File]::WriteAllText((Join-Path $script:markersDir "$setName.yml"), $script:config.Get($setName).MarkerContent($script:hashA))
        }
        [System.IO.File]::WriteAllText((Join-Path $script:markersDir 'mod-x.yml'), $script:derivedSet.MarkerContent($script:hashA))
        @(Test-ShaMarker | Where-Object Status -NE 'Fresh').Count | Should -Be 0
    }
}
