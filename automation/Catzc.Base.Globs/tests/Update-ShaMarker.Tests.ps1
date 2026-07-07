# The trigger-file writer: one full-information YAML marker per globset — the definition representation
# plus its sha256 line, LF, no BOM (ADR-GLOBS:5/6/9); idempotent; declared AND derived sets
# (ADR-PROTGLOB:7); orphans removed.
Describe 'Update-ShaMarker' -Tag 'L1', 'logic' {
    BeforeAll {
        Import-InternalModule TestKit
        $script:hashA = 'a' * 64
        $script:hashB = 'b' * 64
        $script:scopedA = 'c' * 64
        $script:count = 1
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
        # The resolution (scoped/filtered lists + list SHAs) and the companion writer are exercised by their
        # own tests; here they are mocked so the marker assertions stay deterministic and no git shell / fake
        # companion write happens in the fake repo.
        Mock Get-GlobSetResolution {
            [pscustomobject]@{ Name = 'x'; Included = @('src/a'); Count = 1; ScopedSha = $script:scopedA }
        } -ModuleName Catzc.Base.Globs
        Mock Write-CompanionFile { } -ModuleName Catzc.Base.Globs
    }

    AfterEach {
        Remove-FakeRepositoryRoot $script:fake
    }

    It 'creates .sha-markers/ and writes the definition plus the sha256 line, LF-terminated, no BOM' {
        $report = Update-ShaMarker -PassThru

        $path = Join-Path $script:markersDir 'unit-a.yml'
        Test-Path $path | Should -BeTrue
        $bytes = [System.IO.File]::ReadAllBytes($path)
        $bytes[0] | Should -Not -Be 0xEF                   # no BOM
        $bytes[-1] | Should -Be 0x0A                       # trailing LF
        [System.IO.File]::ReadAllText($path) | Should -Be $script:config.Get('unit-a').MarkerContent($script:count, $script:scopedA, $script:hashA)
        ($report | Where-Object Name -EQ 'unit-a').Status | Should -Be 'Written'
    }

    It 'is idempotent: a second run reports Unchanged and rewrites nothing' {
        Update-ShaMarker
        $path = Join-Path $script:markersDir 'unit-a.yml'
        $stamp = (Get-Item $path).LastWriteTimeUtc

        Start-Sleep -Milliseconds 30
        $report = Update-ShaMarker -PassThru

        ($report | Where-Object Name -EQ 'unit-a').Status | Should -Be 'Unchanged'
        (Get-Item $path).LastWriteTimeUtc | Should -Be $stamp
    }

    It 'rewrites when the hash changes — only the sha256 line moves' {
        Update-ShaMarker
        Mock Get-GlobSetHash { $script:hashB } -ModuleName Catzc.Base.Globs

        $report = Update-ShaMarker -PassThru

        ($report | Where-Object Name -EQ 'unit-a').Status | Should -Be 'Written'
        $content = [System.IO.File]::ReadAllText((Join-Path $script:markersDir 'unit-a.yml'))
        $content | Should -Be $script:config.Get('unit-a').MarkerContent($script:count, $script:scopedA, $script:hashB)
        $content | Should -Match "sha256: $script:hashB"
    }

    It 'rewrites when the definition changes, even with an unchanged hash' {
        Update-ShaMarker
        $redefined = [Catzc.Base.Globs.GlobsConfig]::new(@{
                globsets = [ordered]@{
                    'unit-a' = @{ description = 'd'; layer = 'deployable-unit'; include = @('src/**', 'extra/**') }
                    'unit-b' = @{ description = 'd'; layer = 'deployable-unit'; include = @('docs/**') }
                }
            })
        Mock Get-Config { $redefined } -ModuleName Catzc.Base.Globs

        $report = Update-ShaMarker -PassThru

        ($report | Where-Object Name -EQ 'unit-a').Status | Should -Be 'Written'
        [System.IO.File]::ReadAllText((Join-Path $script:markersDir 'unit-a.yml')) |
            Should -Match ([regex]::Escape("- '+ extra/**'"))
    }

    It 'writes a marker for a derived set on a full run' {
        $report = Update-ShaMarker -PassThru

        ($report | Where-Object Name -EQ 'mod-x').Status | Should -Be 'Written'
        [System.IO.File]::ReadAllText((Join-Path $script:markersDir 'mod-x.yml')) |
            Should -Be $script:derivedSet.MarkerContent($script:count, $script:scopedA, $script:hashA)
    }

    It 'updates only the named set but still removes orphans' {
        New-Item -ItemType Directory -Path $script:markersDir -Force | Out-Null
        Set-Content (Join-Path $script:markersDir 'dead-unit.yml') 'name: dead-unit'

        $report = Update-ShaMarker -Name unit-a -PassThru

        ($report | Where-Object Name -EQ 'unit-a').Status | Should -Be 'Written'
        $report.Name | Should -Not -Contain 'unit-b'
        ($report | Where-Object Name -EQ 'dead-unit').Status | Should -Be 'Removed'
        Test-Path (Join-Path $script:markersDir 'dead-unit.yml') | Should -BeFalse
    }

    It 'never removes a derived set''s marker as an orphan' {
        New-Item -ItemType Directory -Path $script:markersDir -Force | Out-Null
        Set-Content (Join-Path $script:markersDir 'mod-x.yml') 'name: mod-x'

        $report = Update-ShaMarker -Name unit-a -PassThru

        ($report | Where-Object Name -EQ 'mod-x') | Should -BeNullOrEmpty
        Test-Path (Join-Path $script:markersDir 'mod-x.yml') | Should -BeTrue
    }

    It 'leaves non-marker files in .sha-markers/ alone' {
        New-Item -ItemType Directory -Path $script:markersDir -Force | Out-Null
        Set-Content (Join-Path $script:markersDir 'README.md') 'generated - do not edit'

        Update-ShaMarker

        Test-Path (Join-Path $script:markersDir 'README.md') | Should -BeTrue
    }

    It 'returns nothing without -PassThru' {
        Update-ShaMarker | Should -BeNullOrEmpty
    }
}
