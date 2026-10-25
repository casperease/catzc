Describe 'Get-DrsUsage (repository)' -Tag 'L2', 'integrity', 'source-only' {
    BeforeAll {
        $script:gitMissing = -not (Get-Command git -ErrorAction Ignore)
        if (-not $script:gitMissing) {
            $script:rows = @(Get-DrsUsage)
            $script:map = Get-DrsCitationMap
            # Narrowing and grouping run over one folder, not the whole tree.
            $script:slicePath = Join-Path (Get-RepositoryRoot) 'docs/drs/repository'
            $script:slice = @(Get-DrsUsage -Path $script:slicePath)
        }
    }

    It 'lists citations and links from the tracked files' -Tag 'ADR-REPO-FILEMETA-IMPRINTEDPARTS' {
        if ($script:gitMissing) {
            Set-ItResult -Skipped -Because 'tool_git_missing'; return
        }
        $rows.Count | Should -BeGreaterThan 0
        @($rows.Source | Sort-Object -Unique) | Should -Be @('cites', 'link')
    }

    It 'gives every row a path, a registered code, and a rule that code declares' -Tag 'ADR-REPO-FILEMETA-IMPRINTEDPARTS' {
        if ($script:gitMissing) {
            Set-ItResult -Skipped -Because 'tool_git_missing'; return
        }
        $rows | Where-Object { -not $_.Path } | Should -BeNullOrEmpty
        $rows | Where-Object { -not ($map.HasCode($_.Code) -or $map.IsDomainCode($_.Code)) } | Should -BeNullOrEmpty
        $rows | Where-Object { $null -ne $_.Rule -and $map.AdrOf($_.Rule) -cne $_.Code } | Should -BeNullOrEmpty
    }

    It 'keeps a number out of a row: a rule is one rule code or none' -Tag 'ADR-REPO-FILEMETA-IMPRINTEDPARTS' {
        if ($script:gitMissing) {
            Set-ItResult -Skipped -Because 'tool_git_missing'; return
        }
        $rows | Where-Object { $_.Code -match '[#{}:]' } | Should -BeNullOrEmpty
        $rows | Where-Object { $null -ne $_.Rule -and -not $map.IsRule($_.Rule) } | Should -BeNullOrEmpty
    }

    It 'narrows to the codes and the source asked for' -Tag 'ADR-REPO-FILEMETA-IMPRINTEDPARTS' {
        if ($script:gitMissing) {
            Set-ItResult -Skipped -Because 'tool_git_missing'; return
        }
        $code = $slice[0].Code
        $narrowed = @(Get-DrsUsage -Path $slicePath -Code $code -Source $slice[0].Source)
        $narrowed.Count | Should -BeGreaterThan 0
        @($narrowed.Code | Sort-Object -Unique) | Should -Be @($code)
        @($narrowed.Source | Sort-Object -Unique) | Should -Be @($slice[0].Source)
    }

    It 'groups by rule and by document' -Tag 'ADR-REPO-FILEMETA-IMPRINTEDPARTS' {
        if ($script:gitMissing) {
            Set-ItResult -Skipped -Because 'tool_git_missing'; return
        }
        $byRule = @(Get-DrsUsage -Path $slicePath -GroupBy Rule)
        $byRule.Count | Should -BeGreaterThan 0
        $byRule | Where-Object { $_.Count -ne @($_.Documents).Count } | Should -BeNullOrEmpty
        $byDocument = @(Get-DrsUsage -Path $slicePath -GroupBy Document)
        $byDocument.Count | Should -Be @($slice.Path | Sort-Object -Unique).Count
        $byDocument | Where-Object { $_.Count -ne @($_.Citations).Count } | Should -BeNullOrEmpty
    }

    It 'limits the scan to the path given' -Tag 'ADR-REPO-FILEMETA-IMPRINTEDPARTS' {
        if ($script:gitMissing) {
            Set-ItResult -Skipped -Because 'tool_git_missing'; return
        }
        $path = 'docs/drs/repository/file-meta.md'
        # An absolute path: a relative one resolves against the process location, which a test worker does not hold at the root.
        $one = @(Get-DrsUsage -Path (Join-Path (Get-RepositoryRoot) $path))
        $one.Count | Should -BeGreaterThan 0
        @($one.Path | Sort-Object -Unique) | Should -Be @($path)
    }
}

Describe 'Get-DrsUsage' -Tag 'L0', 'logic' {
    It 'skips a path the index still lists but the working tree has deleted' -Tag 'ADR-REPO-FILEMETA-IMPRINTEDPARTS' {
        $root = Join-Path $TestDrive 'repo'
        $path = 'docs/widget.md'
        [void] [System.IO.Directory]::CreateDirectory((Join-Path $root 'docs'))
        [System.IO.File]::WriteAllText((Join-Path $root $path), "# Widget`n`nThe widget spins, as ADR-GADGET-SPIN says.`n")
        Mock Get-DrsCitationMap -ModuleName Catzc.Base.QualityGates {
            [Catzc.Base.Drs.DrsCitationMap]::new(@{ 'ADR-GADGET' = @{ path = 'docs/drs/gadget.md'; rules = [string[]] @('ADR-GADGET-SPIN') } }, @())
        }
        Mock Get-FileMetaScope -ModuleName Catzc.Base.QualityGates {
            [pscustomobject]@{ Path = 'docs/widget-deleted.md'; Carrier = [pscustomobject]@{ carrier = [Catzc.Base.Languages.CarrierKind]::FrontMatter } }
            [pscustomobject]@{ Path = 'docs/widget.md'; Carrier = [pscustomobject]@{ carrier = [Catzc.Base.Languages.CarrierKind]::FrontMatter } }
        }
        $kept = @(Get-DrsUsage -RepositoryRoot $root)
        $kept.Count | Should -BeGreaterThan 0
        @($kept.Path | Sort-Object -Unique) | Should -Be @($path)
    }
}
