# The gitignored companion writer (ADR-GLOBS:11): timestamp + two list SHAs + scan filter + FULL included +
# OPTIONAL filtered (capped at 500, graceful cut-off). Idempotent ignoring the timestamp. Tested through the
# module (private); Get-RepositoryRoot is redirected to a temp tree.
Describe 'Write-CompanionFile' -Tag 'L1', 'logic' {
    BeforeEach {
        $script:root = Join-Path ([System.IO.Path]::GetTempPath()) ([guid]::NewGuid())
        [System.IO.Directory]::CreateDirectory((Join-Path $script:root '.sha-markers')) | Out-Null
        Mock Get-RepositoryRoot { $script:root } -ModuleName Catzc.Base.Globs
        $script:set = [Catzc.Base.Globs.GlobSet]::new('unit', 'd', 'loose-fileset', @('src/**'), @('**/*.md'), @(), @(), -1, $null)
        $script:companion = Join-Path $script:root '.sha-markers/unit.files.yml'
    }

    AfterEach {
        [System.IO.Directory]::Delete($script:root, $true)
    }

    It 'writes a timestamp, both list SHAs, the scan filter, the full included list, and filtered' {
        $resolution = [pscustomobject]@{
            Name = 'unit'; Included = @('src/a.cs', 'src/b.cs'); Filtered = @('src/x.tmp')
            ScopedSha = ('a' * 64); FilteredSha = ('b' * 64)
        }
        & (Get-Module Catzc.Base.Globs) { param($s, $r) Write-CompanionFile -GlobSet $s -Resolution $r } $script:set $resolution

        $text = [System.IO.File]::ReadAllText($script:companion)
        $text | Should -Match 'generated_at: \d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}Z'
        $text | Should -Match 'scoped_sha256: a{64}'
        $text | Should -Match 'filtered_sha256: b{64}'
        $text | Should -Match "scan:`n- '\+ src/\*\*'"
        $text | Should -Match "included:`n- src/a.cs`n- src/b.cs"
        $text | Should -Match "filtered:`n- src/x.tmp"
    }

    It 'renders included: [] when empty and omits an empty filtered block' {
        $resolution = [pscustomobject]@{ Name = 'unit'; Included = @(); Filtered = @(); ScopedSha = ('a' * 64); FilteredSha = ('b' * 64) }
        & (Get-Module Catzc.Base.Globs) { param($s, $r) Write-CompanionFile -GlobSet $s -Resolution $r } $script:set $resolution

        $text = [System.IO.File]::ReadAllText($script:companion)
        $text | Should -Match 'included: \[\]'
        $text | Should -Not -Match 'filtered:'
    }

    It 'caps filtered at 500 with a graceful cut-off, a truncation marker, and a red message' {
        $big = 1..600 | ForEach-Object { 'gen/f{0:d4}.tmp' -f $_ }
        $resolution = [pscustomobject]@{ Name = 'unit'; Included = @(); Filtered = $big; ScopedSha = ('a' * 64); FilteredSha = ('b' * 64) }
        Mock Write-Message { } -ModuleName Catzc.Base.Globs
        & (Get-Module Catzc.Base.Globs) { param($s, $r) Write-CompanionFile -GlobSet $s -Resolution $r } $script:set $resolution

        $lines = [System.IO.File]::ReadAllLines($script:companion)
        @($lines | Where-Object { $_ -like '- gen/*' }).Count | Should -Be 500
        $lines | Should -Contain 'filtered_truncated: true'
        Should -Invoke Write-Message -ModuleName Catzc.Base.Globs -ParameterFilter { $ForegroundColor -eq 'Red' -and $Message -match 'cut off at 500' }
    }

    It 'is idempotent ignoring the timestamp: an unchanged resolution does not rewrite' {
        $resolution = [pscustomobject]@{ Name = 'unit'; Included = @('src/a.cs'); Filtered = @(); ScopedSha = ('a' * 64); FilteredSha = ('b' * 64) }
        $write = { & (Get-Module Catzc.Base.Globs) { param($s, $r) Write-CompanionFile -GlobSet $s -Resolution $r } $script:set $resolution }
        & $write
        $stamp = [System.IO.File]::GetLastWriteTimeUtc($script:companion)
        Start-Sleep -Milliseconds 40
        & $write
        [System.IO.File]::GetLastWriteTimeUtc($script:companion) | Should -Be $stamp
    }
}
