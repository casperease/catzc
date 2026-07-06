# The freshness query: Fresh/Stale/Missing per marker file AND per .globset companion (ADR-GLOBS:9) —
# declared AND derived sets (ADR-PROTGLOB:7) — plus Orphaned files; clean exactly when all Fresh.
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

    It 'reports Fresh when the file carries the recomputed hash' {
        [System.IO.File]::WriteAllText((Join-Path $script:markersDir 'unit-a.sha256'), "$script:hashA`n")
        $result = @(Test-ShaMarker -Name unit-a | Where-Object Path -Like '*.sha256')
        $result.Status | Should -Be 'Fresh'
        $result.Actual | Should -Be $script:hashA
    }

    It 'reports Stale when the file differs, carrying both hashes' {
        [System.IO.File]::WriteAllText((Join-Path $script:markersDir 'unit-a.sha256'), "$script:hashB`n")
        $result = @(Test-ShaMarker -Name unit-a | Where-Object Path -Like '*.sha256')
        $result.Status | Should -Be 'Stale'
        $result.Expected | Should -Be $script:hashA
        $result.Actual | Should -Be $script:hashB
    }

    It 'reports Missing when no marker file exists' {
        $result = @(Test-ShaMarker -Name unit-a | Where-Object Path -Like '*.sha256')
        $result.Status | Should -Be 'Missing'
        $result.Actual | Should -BeNullOrEmpty
    }

    It 'reports the .globset companion beside the marker — Missing, then Fresh, then Stale on a definition change' {
        [System.IO.File]::WriteAllText((Join-Path $script:markersDir 'unit-a.sha256'), "$script:hashA`n")
        $companion = @(Test-ShaMarker -Name unit-a | Where-Object Path -Like '*.globset')
        $companion.Status | Should -Be 'Missing'

        [System.IO.File]::WriteAllText((Join-Path $script:markersDir 'unit-a.globset'), $script:config.Get('unit-a').Representation)
        $companion = @(Test-ShaMarker -Name unit-a | Where-Object Path -Like '*.globset')
        $companion.Status | Should -Be 'Fresh'

        [System.IO.File]::WriteAllText((Join-Path $script:markersDir 'unit-a.globset'), "name: unit-a`nlayer: scope`n")
        $companion = @(Test-ShaMarker -Name unit-a | Where-Object Path -Like '*.globset')
        $companion.Status | Should -Be 'Stale'
        $companion.Expected | Should -Be $script:config.Get('unit-a').Representation
    }

    It 'reports Orphaned for a marker or companion file with no globset, even on a named run' {
        [System.IO.File]::WriteAllText((Join-Path $script:markersDir 'dead-unit.sha256'), "$script:hashB`n")
        [System.IO.File]::WriteAllText((Join-Path $script:markersDir 'dead-unit.globset'), "name: dead-unit`n")
        $result = @(Test-ShaMarker -Name unit-a)
        $orphans = @($result | Where-Object Status -EQ 'Orphaned')
        $orphans.Count | Should -Be 2
        ($orphans.Path | Sort-Object) | Should -Be @('.sha-markers/dead-unit.globset', '.sha-markers/dead-unit.sha256')
    }

    It 'covers every globset — declared and derived, marker and companion — on a full run and never throws' {
        [System.IO.File]::WriteAllText((Join-Path $script:markersDir 'unit-a.sha256'), "$script:hashA`n")
        $result = @(Test-ShaMarker)
        $result.Count | Should -Be 6
        ($result | Where-Object Path -EQ '.sha-markers/unit-a.sha256').Status | Should -Be 'Fresh'
        ($result | Where-Object Path -EQ '.sha-markers/unit-a.globset').Status | Should -Be 'Missing'
        ($result | Where-Object Name -EQ 'unit-b').Status | Should -Be @('Missing', 'Missing')
        ($result | Where-Object Name -EQ 'mod-x').Status | Should -Be @('Missing', 'Missing')
    }

    It 'resolves a derived set by name and never reports its marker as orphaned' {
        [System.IO.File]::WriteAllText((Join-Path $script:markersDir 'mod-x.sha256'), "$script:hashA`n")
        [System.IO.File]::WriteAllText((Join-Path $script:markersDir 'mod-x.globset'), $script:derivedSet.Representation)
        $result = @(Test-ShaMarker -Name mod-x)
        ($result | Where-Object Name -EQ 'mod-x').Status | Should -Be @('Fresh', 'Fresh')
        ($result | Where-Object Status -EQ 'Orphaned') | Should -BeNullOrEmpty
    }

    It 'is clean exactly when everything is Fresh' {
        foreach ($setName in 'unit-a', 'unit-b') {
            [System.IO.File]::WriteAllText((Join-Path $script:markersDir "$setName.sha256"), "$script:hashA`n")
            [System.IO.File]::WriteAllText((Join-Path $script:markersDir "$setName.globset"), $script:config.Get($setName).Representation)
        }
        [System.IO.File]::WriteAllText((Join-Path $script:markersDir 'mod-x.sha256'), "$script:hashA`n")
        [System.IO.File]::WriteAllText((Join-Path $script:markersDir 'mod-x.globset'), $script:derivedSet.Representation)
        @(Test-ShaMarker | Where-Object Status -NE 'Fresh').Count | Should -Be 0
    }
}
