<#
---
catzc:
  derived:
    path: automation/Catzc.Base.RootConfig/tests/Test-RootConfigIntegrity.Tests.ps1
    kind: test
---
#>

# Integrity test for managed root config files, through the quality gates Test-RootConfigFiles and
# Test-RootAnalyzerSettings ([ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35)).
#
# rootconfig.yml is the registry of repository-root files fully managed by the source-of-truth automation.
# Per opted-in entry, `committed` decides git membership, and registry, .gitignore, and git's tracked set
# must agree:
#   committed false -> the target is a derived, gitignored artifact: matched by an ignore rule and absent
#                      from tracking (removed with `git rm --cached` if it was ever committed).
#   committed true  -> the target is tracked (needed before the importer runs) and NOT ignored.
# and a copyAsLink target is an effective link to its source, any other target a real file. Mirrors the
# generated-README integrity test (Test-GeneratedReadmes.Tests.ps1). See
# [ADR-REPO-ROOTCFG](/docs/adr/repository/generated-root-configs.md).
Describe 'Managed root config files agree with .gitignore and git tracking' -Tag 'L2', 'integrity', 'source-only' {
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
            $script:result = Test-RootConfigFiles -PassThru -OutputFolder (Join-Path $TestDrive 'root-config-files')
        }
    }

    It 'resolves opted-in managed files (guards against a vacuous pass)' {
        if ($script:skip) {
            Set-ItResult -Skipped -Because $script:skip; return
        }
        $result.Files | Should -BeGreaterThan 0
    }

    It 'agrees with the registry on git tracking, .gitignore, and the link mechanism' {
        if ($script:skip) {
            Set-ItResult -Skipped -Because $script:skip; return
        }
        $result.IssueCount | Should -Be 0 -Because ($result.Issues -join "`n")
    }
}

# The root PSScriptAnalyzerSettings.psd1 has a consumer-format contract of its own: PSScriptAnalyzer requires
# a literal-hashtable settings file at the path it is given. The target is a copyAsLink entry, so content
# equality with the source holds by construction (a hard link is the same bytes; a symbolic link resolves) —
# what remains to prove is that a consumer opening the ROOT path can follow the link and parse the settings.
Describe 'Root PSScriptAnalyzerSettings.psd1 link' -Tag 'L1', 'integrity', 'source-only' {
    It 'parses as a settings hashtable through the link' {
        $result = Test-RootAnalyzerSettings -PassThru -OutputFolder (Join-Path $TestDrive 'root-analyzer-settings')
        if (-not $result.Checked) {
            Set-ItResult -Skipped -Because 'entry_not_opted_in'; return
        }
        $result.IssueCount | Should -Be 0 -Because ($result.Issues -join "`n")
    }
}
