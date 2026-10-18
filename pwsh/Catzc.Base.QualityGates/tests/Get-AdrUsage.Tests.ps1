Describe 'Get-AdrUsage (repository)' -Tag 'L1', 'integrity', 'source-only' {
    BeforeAll {
        $script:rows = @(Get-AdrUsage)
        $script:map = Get-AdrCitationMap
    }

    It 'lists citations and links from the tracked files' -Tag 'ADR-REPO-FILEMETA-IMPRINTEDPARTS' {
        $rows.Count | Should -BeGreaterThan 0
        @($rows.Source | Sort-Object -Unique) | Should -Be @('cites', 'link')
    }

    It 'gives every row a path, a registered code, and a rule that code declares' -Tag 'ADR-REPO-FILEMETA-IMPRINTEDPARTS' {
        $rows | Where-Object { -not $_.Path } | Should -BeNullOrEmpty
        $rows | Where-Object { -not ($map.HasCode($_.Code) -or $map.IsDomainCode($_.Code)) } | Should -BeNullOrEmpty
        $rows | Where-Object { $null -ne $_.Rule -and $map.AdrOf($_.Rule) -cne $_.Code } | Should -BeNullOrEmpty
    }

    It 'keeps a number out of a row: a rule is one rule code or none' -Tag 'ADR-REPO-FILEMETA-IMPRINTEDPARTS' {
        $rows | Where-Object { $_.Code -match '[#{}:]' } | Should -BeNullOrEmpty
        $rows | Where-Object { $null -ne $_.Rule -and -not $map.IsRule($_.Rule) } | Should -BeNullOrEmpty
    }

    It 'narrows to the codes and the source asked for' -Tag 'ADR-REPO-FILEMETA-IMPRINTEDPARTS' {
        $code = $rows[0].Code
        $narrowed = @(Get-AdrUsage -Code $code -Source $rows[0].Source)
        $narrowed.Count | Should -BeGreaterThan 0
        @($narrowed.Code | Sort-Object -Unique) | Should -Be @($code)
        @($narrowed.Source | Sort-Object -Unique) | Should -Be @($rows[0].Source)
    }

    It 'groups by rule and by document' -Tag 'ADR-REPO-FILEMETA-IMPRINTEDPARTS' {
        $byRule = @(Get-AdrUsage -GroupBy Rule)
        $byRule.Count | Should -BeGreaterThan 0
        $byRule | Where-Object { $_.Count -ne @($_.Documents).Count } | Should -BeNullOrEmpty
        $byDocument = @(Get-AdrUsage -GroupBy Document)
        $byDocument.Count | Should -Be @($rows.Path | Sort-Object -Unique).Count
        $byDocument | Where-Object { $_.Count -ne @($_.Citations).Count } | Should -BeNullOrEmpty
    }

    It 'limits the scan to the path given' -Tag 'ADR-REPO-FILEMETA-IMPRINTEDPARTS' {
        $path = 'docs/adr/repository/file-meta.md'
        # An absolute path: a relative one resolves against the process location, which a test worker does not hold at the root.
        $one = @(Get-AdrUsage -Path (Join-Path (Get-RepositoryRoot) $path))
        $one.Count | Should -BeGreaterThan 0
        @($one.Path | Sort-Object -Unique) | Should -Be @($path)
    }
}
