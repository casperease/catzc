<#
---
catzc:
  derived:
    path: automation/Catzc.Base.RootConfig/tests/Test-RootConfigIntegrity.Tests.ps1
    kind: pester-test
    adrs:
      - ADR-AUTO-TEST#35
      - ADR-REPO-ROOTCFG
---
#>

# Integrity test for managed root config files, through the quality gates Test-RootConfigFiles and...
# [comment:1](/docs/references/automation/catzc-base-rootconfig/tests/Test-RootConfigIntegrity.Tests.ps1.md#comment1)
Describe 'Managed root config files agree with .gitignore and git tracking' -Tag 'L2', 'integrity', 'source-only' {
    BeforeAll {
        $script:repoRoot = Get-RepositoryRoot
        $script:skip = $null

        # L2: drives the real git CLI.
        # [comment:2](/docs/references/automation/catzc-base-rootconfig/tests/Test-RootConfigIntegrity.Tests.ps1.md#comment2)
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

# The root PSScriptAnalyzerSettings.psd1 has a consumer-format contract of its own: PSScriptAnalyzer requires a...
# [comment:3](/docs/references/automation/catzc-base-rootconfig/tests/Test-RootConfigIntegrity.Tests.ps1.md#comment3)
Describe 'Root PSScriptAnalyzerSettings.psd1 link' -Tag 'L1', 'integrity', 'source-only' {
    It 'parses as a settings hashtable through the link' {
        $result = Test-RootAnalyzerSettings -PassThru -OutputFolder (Join-Path $TestDrive 'root-analyzer-settings')
        if (-not $result.Checked) {
            Set-ItResult -Skipped -Because 'entry_not_opted_in'; return
        }
        $result.IssueCount | Should -Be 0 -Because ($result.Issues -join "`n")
    }
}
