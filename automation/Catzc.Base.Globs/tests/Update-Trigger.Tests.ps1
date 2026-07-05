# The trigger-file writer: one 64-hex line + LF, no BOM; idempotent; orphans removed (ADR-GLOBS:5/6).
Describe 'Update-Trigger' -Tag 'L1', 'logic' {
    BeforeAll {
        Import-InternalModule TestKit
        $script:hashA = 'a' * 64
        $script:hashB = 'b' * 64
    }

    BeforeEach {
        $script:fake = New-FakeRepositoryRoot
        $script:triggersDir = Join-Path $script:fake.Root '.triggers'

        $script:config = [Catzc.Base.Globs.GlobsConfig]::new(@{
                globsets = [ordered]@{
                    'unit-a' = @{ description = 'd'; include = @('src/**') }
                    'unit-b' = @{ description = 'd'; include = @('docs/**') }
                }
            })
        Mock Get-Config { $script:config } -ModuleName Catzc.Base.Globs
        Mock Get-GlobSetHash { $script:hashA } -ModuleName Catzc.Base.Globs
    }

    AfterEach {
        Remove-FakeRepositoryRoot $script:fake
    }

    It 'creates .triggers/ and writes one 64-hex line + LF, no BOM' {
        $report = Update-Trigger -PassThru

        $path = Join-Path $script:triggersDir 'unit-a.sha256'
        Test-Path $path | Should -BeTrue
        $bytes = [System.IO.File]::ReadAllBytes($path)
        $bytes.Count | Should -Be 65                       # 64 hex + LF, no BOM, no CR
        $bytes[0] | Should -Not -Be 0xEF                   # no BOM
        $bytes[-1] | Should -Be 0x0A                       # trailing LF
        [System.Text.Encoding]::ASCII.GetString($bytes, 0, 64) | Should -Be $script:hashA
        ($report | Where-Object Name -EQ 'unit-a').Status | Should -Be 'Written'
    }

    It 'is idempotent: a second run reports Unchanged and rewrites nothing' {
        Update-Trigger
        $path = Join-Path $script:triggersDir 'unit-a.sha256'
        $stamp = (Get-Item $path).LastWriteTimeUtc

        Start-Sleep -Milliseconds 30
        $report = Update-Trigger -PassThru

        ($report | Where-Object Name -EQ 'unit-a').Status | Should -Be 'Unchanged'
        (Get-Item $path).LastWriteTimeUtc | Should -Be $stamp
    }

    It 'rewrites when the hash changes' {
        Update-Trigger
        Mock Get-GlobSetHash { $script:hashB } -ModuleName Catzc.Base.Globs

        $report = Update-Trigger -PassThru

        ($report | Where-Object Name -EQ 'unit-a').Status | Should -Be 'Written'
        (Get-Content (Join-Path $script:triggersDir 'unit-a.sha256') -Raw) | Should -Be "$script:hashB`n"
    }

    It 'updates only the named set but still removes orphans' {
        New-Item -ItemType Directory -Path $script:triggersDir -Force | Out-Null
        Set-Content (Join-Path $script:triggersDir 'dead-unit.sha256') $script:hashB

        $report = Update-Trigger -Name unit-a -PassThru

        ($report | Where-Object Name -EQ 'unit-a').Status | Should -Be 'Written'
        $report.Name | Should -Not -Contain 'unit-b'
        ($report | Where-Object Name -EQ 'dead-unit').Status | Should -Be 'Removed'
        Test-Path (Join-Path $script:triggersDir 'dead-unit.sha256') | Should -BeFalse
    }

    It 'leaves non-sha256 files in .triggers/ alone' {
        New-Item -ItemType Directory -Path $script:triggersDir -Force | Out-Null
        Set-Content (Join-Path $script:triggersDir 'README.md') 'generated - do not edit'

        Update-Trigger

        Test-Path (Join-Path $script:triggersDir 'README.md') | Should -BeTrue
    }

    It 'returns nothing without -PassThru' {
        Update-Trigger | Should -BeNullOrEmpty
    }
}
