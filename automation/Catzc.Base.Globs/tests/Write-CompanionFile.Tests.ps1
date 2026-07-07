# The out/ companion writer (ADR-GLOBS:11): a timestamp + the list SHA + the files count + the scan filter +
# the FULL included list, written under Get-OutputRoot (out/ on a devbox, the build staging dir in CI) — so
# the committed marker stays lean and deterministic while the expansion is one Get-OutputRoot away. No
# 'filtered' half. Tested through the module (private); Get-OutputRoot -> a temp tree.
Describe 'Write-CompanionFile' -Tag 'L1', 'logic' {
    BeforeEach {
        $script:out = Join-Path ([System.IO.Path]::GetTempPath()) ([guid]::NewGuid())
        [System.IO.Directory]::CreateDirectory($script:out) | Out-Null
        Mock Get-OutputRoot { $script:out } -ModuleName Catzc.Base.Globs
        $script:set = [Catzc.Base.Globs.GlobSet]::new('unit', 'd', 'loose-fileset', @('src/**'), @('**/*.md'), @(), @(), -1, $null)
        $script:companion = Join-Path $script:out 'sha-markers/unit.files.yml'
    }

    AfterEach {
        [System.IO.Directory]::Delete($script:out, $true)
    }

    It 'writes under Get-OutputRoot: timestamp, list SHA, files count, scan filter, and the full included list' {
        $resolution = [pscustomobject]@{ Name = 'unit'; Included = @('src/a.cs', 'src/b.cs'); Count = 2; ScopedSha = ('a' * 64) }
        & (Get-Module Catzc.Base.Globs) { param($s, $r) Write-CompanionFile -GlobSet $s -Resolution $r } $script:set $resolution

        $text = [System.IO.File]::ReadAllText($script:companion)
        $text | Should -Match 'generated_at: \d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}Z'   # timestamped — it lives in transient out/
        $text | Should -Match 'scoped_sha256: a{64}'
        $text | Should -Match 'files: 2'
        $text | Should -Match "scan:`n- '\+ src/\*\*'"
        $text | Should -Match "included:`n- src/a.cs`n- src/b.cs"
        $text | Should -Not -Match 'filtered'                                        # no local-tree half
    }

    It 'renders included: [] when the package is empty' {
        $resolution = [pscustomobject]@{ Name = 'unit'; Included = @(); Count = 0; ScopedSha = ('a' * 64) }
        & (Get-Module Catzc.Base.Globs) { param($s, $r) Write-CompanionFile -GlobSet $s -Resolution $r } $script:set $resolution

        [System.IO.File]::ReadAllText($script:companion) | Should -Match 'included: \[\]'
    }
}
