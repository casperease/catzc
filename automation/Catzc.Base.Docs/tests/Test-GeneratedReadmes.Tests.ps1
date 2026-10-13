# Integrity gate for generated README links, over the real repository through the quality gate Test-ReadmeLinks
# ([ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35)).
#
# readme.yml (expanded by Get-ReadmeMappings) is the registry of folders whose README.md is a LINK to a
# docs/ source — a derived artifact, never authored in place. Every such README must therefore be:
#   1. matched by a .gitignore ignore rule (so a fresh Build-Readme output is never accidentally stageable), and
#   2. absent from git tracking (removed with `git rm --cached` if it was ever committed), and
#   3. an effective link to its source.
# Hand-authored READMEs are exactly the folders NOT in readme.yml; they are individually un-ignored in
# .gitignore and are out of scope here. See [ADR-REPO-README](/docs/adr/repository/generated-readmes.md).
#
# Reads only the repository's files and git index (through the source-tree-only Get-ReadmeMappings) — the same
# answer in both run modes, so the build run skips it.
Describe 'Generated README links are gitignored and untracked' -Tag 'L2', 'integrity', 'source-only' {
    BeforeAll {
        $script:repoRoot = Get-RepositoryRoot
        $script:skip = $null

        # L2: drives the real git CLI. Self-skip when git is absent or we are not inside a work tree
        # (e.g. running from an exported tarball), per the test-automation tiering ADR.
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
            $script:result = Test-ReadmeLinks -PassThru -OutputFolder (Join-Path $TestDrive 'readme-links')
        }
    }

    It 'resolves configured README targets (guards against a vacuous pass)' {
        if ($script:skip) {
            Set-ItResult -Skipped -Because $script:skip; return
        }
        $result.Links | Should -BeGreaterThan 0
    }

    It 'ignores every generated README, keeps it out of git, and links it to its source' {
        if ($script:skip) {
            Set-ItResult -Skipped -Because $script:skip; return
        }
        $result.IssueCount | Should -Be 0 -Because ($result.Issues -join "`n")
    }
}
