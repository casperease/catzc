# The freshness query: Fresh/Stale/Missing per globset plus Orphaned files — clean exactly when all Fresh.
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
        Mock Get-Config { $script:config } -ModuleName Catzc.Base.Globs
        Mock Get-GlobSetHash { $script:hashA } -ModuleName Catzc.Base.Globs
    }

    AfterEach {
        Remove-FakeRepositoryRoot $script:fake
    }

    It 'reports Fresh when the file carries the recomputed hash' {
        [System.IO.File]::WriteAllText((Join-Path $script:markersDir 'unit-a.sha256'), "$script:hashA`n")
        $result = Test-ShaMarker -Name unit-a
        $result.Status | Should -Be 'Fresh'
        $result.Actual | Should -Be $script:hashA
    }

    It 'reports Stale when the file differs, carrying both hashes' {
        [System.IO.File]::WriteAllText((Join-Path $script:markersDir 'unit-a.sha256'), "$script:hashB`n")
        $result = Test-ShaMarker -Name unit-a
        $result.Status | Should -Be 'Stale'
        $result.Expected | Should -Be $script:hashA
        $result.Actual | Should -Be $script:hashB
    }

    It 'reports Missing when no marker file exists' {
        $result = Test-ShaMarker -Name unit-a
        $result.Status | Should -Be 'Missing'
        $result.Actual | Should -BeNullOrEmpty
    }

    It 'reports Orphaned for a marker file with no globset, even on a named run' {
        [System.IO.File]::WriteAllText((Join-Path $script:markersDir 'dead-unit.sha256'), "$script:hashB`n")
        $result = @(Test-ShaMarker -Name unit-a)
        ($result | Where-Object Status -EQ 'Orphaned').Name | Should -Be 'dead-unit'
    }

    It 'covers every globset on a full run and never throws' {
        [System.IO.File]::WriteAllText((Join-Path $script:markersDir 'unit-a.sha256'), "$script:hashA`n")
        $result = @(Test-ShaMarker)
        $result.Count | Should -Be 2
        ($result | Where-Object Name -EQ 'unit-a').Status | Should -Be 'Fresh'
        ($result | Where-Object Name -EQ 'unit-b').Status | Should -Be 'Missing'
    }

    It 'is clean exactly when everything is Fresh' {
        [System.IO.File]::WriteAllText((Join-Path $script:markersDir 'unit-a.sha256'), "$script:hashA`n")
        [System.IO.File]::WriteAllText((Join-Path $script:markersDir 'unit-b.sha256'), "$script:hashA`n")
        @(Test-ShaMarker | Where-Object Status -NE 'Fresh').Count | Should -Be 0
    }
}
