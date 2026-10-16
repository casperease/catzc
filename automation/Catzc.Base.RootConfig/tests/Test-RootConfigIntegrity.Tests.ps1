<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.RootConfig/tests/Test-RootConfigIntegrity.Tests.ps1
    folder: tests
    name: test-root-config-integrity-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.RootConfig
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    page: docs/references/automation/catzc-base-rootconfig/tests/Test-RootConfigIntegrity.Tests.ps1.md
    cites:
      - ADR-AUTO-TEST#35
      - ADR-REPO-ROOTCFG
---
#>

Describe 'Managed root config files agree with .gitignore and git tracking' -Tag 'L2', 'integrity', 'source-only' {
    BeforeAll {
        $script:repoRoot = Get-RepositoryRoot
        $script:skip = $null

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

Describe 'Root PSScriptAnalyzerSettings.psd1 link' -Tag 'L1', 'integrity', 'source-only' {
    It 'parses as a settings hashtable through the link' {
        $result = Test-RootAnalyzerSettings -PassThru -OutputFolder (Join-Path $TestDrive 'root-analyzer-settings')
        if (-not $result.Checked) {
            Set-ItResult -Skipped -Because 'entry_not_opted_in'; return
        }
        $result.IssueCount | Should -Be 0 -Because ($result.Issues -join "`n")
    }
}
