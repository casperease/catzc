Describe 'Managed root config files agree with .gitignore and git tracking' -Tag 'L2', 'integrity', 'source-only' {
    BeforeAll {
        $script:repoRoot = Get-RepositoryRoot
        $script:skip = $null

        # L2 drives the real git CLI, so it self-skips without git or outside a work tree.
        if (-not (Get-Command git -ErrorAction Ignore)) {
            $script:skip = 'tool_git_missing'
        }
        else {
            $inside = try {
                & git -C $script:repoRoot rev-parse --is-inside-work-tree 2>$null
            }
            catch {
                $null
            }
            if ($inside -ne 'true') {
                $script:skip = 'repo_no_worktree'
            }
        }

        $script:result = $null
        if (-not $script:skip) {
            $script:result = Test-RootConfigFiles -PassThru -OutputFolder (Join-Path $TestDrive 'root-config-files')
        }
    }

    It 'resolves opted-in managed files (guards against a vacuous pass)' {
        if ($script:skip) {
            Set-ItResult -Skipped -Because $script:skip; return
        }
        $result.Facts['Files'] | Should -BeGreaterThan 0
    }

    It 'agrees with the registry on git tracking, .gitignore, and the headed copies' {
        if ($script:skip) {
            Set-ItResult -Skipped -Because $script:skip; return
        }
        $result.IssueCount | Should -Be 0 -Because ($result.Issues -join "`n")
    }
}

# PSScriptAnalyzer needs a literal-hashtable settings file at the path it is given.
Describe 'Root PSScriptAnalyzerSettings.psd1 copy' -Tag 'L1', 'integrity', 'source-only' {
    It 'parses as a settings hashtable under its generated head' {
        $result = Test-RootAnalyzerSettings -PassThru -OutputFolder (Join-Path $TestDrive 'root-analyzer-settings')
        if (-not $result.Facts['Checked']) {
            Set-ItResult -Skipped -Because 'entry_not_opted_in'; return
        }
        $result.IssueCount | Should -Be 0 -Because ($result.Issues -join "`n")
    }
}
