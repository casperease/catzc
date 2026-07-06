# The trigger-file writer: one 64-hex line + LF, no BOM; a .globset definition companion per set
# (ADR-GLOBS:9); idempotent; declared AND derived sets (ADR-PROTGLOB:7); orphans removed (ADR-GLOBS:5/6).
Describe 'Update-ShaMarker' -Tag 'L1', 'logic' {
    BeforeAll {
        Import-InternalModule TestKit
        $script:hashA = 'a' * 64
        $script:hashB = 'b' * 64
    }

    BeforeEach {
        $script:fake = New-FakeRepositoryRoot
        $script:markersDir = Join-Path $script:fake.Root '.sha-markers'

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

    It 'creates .sha-markers/ and writes one 64-hex line + LF, no BOM' {
        $report = Update-ShaMarker -PassThru

        $path = Join-Path $script:markersDir 'unit-a.sha256'
        Test-Path $path | Should -BeTrue
        $bytes = [System.IO.File]::ReadAllBytes($path)
        $bytes.Count | Should -Be 65                       # 64 hex + LF, no BOM, no CR
        $bytes[0] | Should -Not -Be 0xEF                   # no BOM
        $bytes[-1] | Should -Be 0x0A                       # trailing LF
        [System.Text.Encoding]::ASCII.GetString($bytes, 0, 64) | Should -Be $script:hashA
        ($report | Where-Object Name -EQ 'unit-a').Status | Should -Be 'Written'
    }

    It 'is idempotent: a second run reports Unchanged and rewrites nothing' {
        Update-ShaMarker
        $path = Join-Path $script:markersDir 'unit-a.sha256'
        $stamp = (Get-Item $path).LastWriteTimeUtc

        Start-Sleep -Milliseconds 30
        $report = Update-ShaMarker -PassThru

        ($report | Where-Object Name -EQ 'unit-a').Status | Should -Be 'Unchanged'
        (Get-Item $path).LastWriteTimeUtc | Should -Be $stamp
    }

    It 'rewrites the marker when the hash changes, leaving the unchanged companion alone' {
        Update-ShaMarker
        Mock Get-GlobSetHash { $script:hashB } -ModuleName Catzc.Base.Globs

        $report = Update-ShaMarker -PassThru

        ($report | Where-Object Path -EQ '.sha-markers/unit-a.sha256').Status | Should -Be 'Written'
        ($report | Where-Object Path -EQ '.sha-markers/unit-a.globset').Status | Should -Be 'Unchanged'
        (Get-Content (Join-Path $script:markersDir 'unit-a.sha256') -Raw) | Should -Be "$script:hashB`n"
    }

    It 'writes a .globset companion carrying the set''s canonical representation' {
        Update-ShaMarker

        $path = Join-Path $script:markersDir 'unit-a.globset'
        Test-Path $path | Should -BeTrue
        $bytes = [System.IO.File]::ReadAllBytes($path)
        $bytes[0] | Should -Not -Be 0xEF                   # no BOM
        [System.IO.File]::ReadAllText($path) | Should -Be $script:config.Get('unit-a').Representation
    }

    It 'rewrites the companion only when the definition changes, leaving the unchanged marker alone' {
        Update-ShaMarker
        $redefined = [Catzc.Base.Globs.GlobsConfig]::new(@{
                globsets = [ordered]@{
                    'unit-a' = @{ description = 'd'; layer = 'deployable-unit'; include = @('src/**', 'extra/**') }
                    'unit-b' = @{ description = 'd'; layer = 'deployable-unit'; include = @('docs/**') }
                }
            })
        Mock Get-Config { $redefined } -ModuleName Catzc.Base.Globs

        $report = Update-ShaMarker -PassThru

        ($report | Where-Object Path -EQ '.sha-markers/unit-a.globset').Status | Should -Be 'Written'
        ($report | Where-Object Path -EQ '.sha-markers/unit-a.sha256').Status | Should -Be 'Unchanged'
        [System.IO.File]::ReadAllText((Join-Path $script:markersDir 'unit-a.globset')) |
            Should -Match ([regex]::Escape('extra/**'))
    }

    It 'writes a marker and companion for a derived set on a full run' {
        $report = Update-ShaMarker -PassThru

        ($report | Where-Object Name -EQ 'mod-x').Status | Should -Be @('Written', 'Written')
        Test-Path (Join-Path $script:markersDir 'mod-x.sha256') | Should -BeTrue
        Test-Path (Join-Path $script:markersDir 'mod-x.globset') | Should -BeTrue
    }

    It 'updates only the named set but still removes orphans' {
        New-Item -ItemType Directory -Path $script:markersDir -Force | Out-Null
        Set-Content (Join-Path $script:markersDir 'dead-unit.sha256') $script:hashB

        $report = Update-ShaMarker -Name unit-a -PassThru

        ($report | Where-Object Name -EQ 'unit-a').Status | Should -Be 'Written'
        $report.Name | Should -Not -Contain 'unit-b'
        ($report | Where-Object Name -EQ 'dead-unit').Status | Should -Be 'Removed'
        Test-Path (Join-Path $script:markersDir 'dead-unit.sha256') | Should -BeFalse
    }

    It 'never removes a derived set''s marker as an orphan' {
        New-Item -ItemType Directory -Path $script:markersDir -Force | Out-Null
        Set-Content (Join-Path $script:markersDir 'mod-x.sha256') $script:hashB

        $report = Update-ShaMarker -Name unit-a -PassThru

        ($report | Where-Object Name -EQ 'mod-x') | Should -BeNullOrEmpty
        Test-Path (Join-Path $script:markersDir 'mod-x.sha256') | Should -BeTrue
    }

    It 'removes an orphaned .globset companion' {
        New-Item -ItemType Directory -Path $script:markersDir -Force | Out-Null
        Set-Content (Join-Path $script:markersDir 'dead-unit.globset') 'name: dead-unit'

        $report = Update-ShaMarker -Name unit-a -PassThru

        ($report | Where-Object Path -EQ '.sha-markers/dead-unit.globset').Status | Should -Be 'Removed'
        Test-Path (Join-Path $script:markersDir 'dead-unit.globset') | Should -BeFalse
    }

    It 'leaves non-sha256 files in .sha-markers/ alone' {
        New-Item -ItemType Directory -Path $script:markersDir -Force | Out-Null
        Set-Content (Join-Path $script:markersDir 'README.md') 'generated - do not edit'

        Update-ShaMarker

        Test-Path (Join-Path $script:markersDir 'README.md') | Should -BeTrue
    }

    It 'returns nothing without -PassThru' {
        Update-ShaMarker | Should -BeNullOrEmpty
    }
}
