# Integrity gate for managed root config files.
#
# rootconfig.yml is the registry of repository-root files fully managed by the source-of-truth automation.
# Per opted-in entry, `committed` decides git membership, and registry, .gitignore, and git's tracked set
# must agree:
#   committed false -> the target is a derived, gitignored artifact: matched by an ignore rule and absent
#                      from tracking (removed with `git rm --cached` if it was ever committed).
#   committed true  -> the target is tracked (needed before the importer runs) and NOT ignored.
# Mirrors the generated-README integrity gate (Test-GeneratedReadmes.Tests.ps1). See
# docs/adr/repository/generated-root-configs.md.
Describe 'Managed root config files agree with .gitignore and git tracking' -Tag 'L2', 'integrity' {
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

        # Resolve the opted-in entries exactly as Build-RootConfig does (private resolver, reached via the
        # module per ADR-PESTER:4) against the real registry.
        $script:entries = @()
        if (-not $script:skip) {
            $config = Get-Config -Config rootconfig
            $script:entries = @(InModuleScope Catzc.Base.RootConfig -Parameters @{ Config = $config } {
                    param($Config) Get-RootConfigTargets -Config $Config
                })
        }
    }

    It 'resolves opted-in managed files (guards against a vacuous pass)' {
        if ($script:skip) {
            Set-ItResult -Skipped -Because $script:skip; return
        }
        @($script:entries).Count | Should -BeGreaterThan 0
    }

    It 'ignores every committed:false target with a .gitignore rule' {
        if ($script:skip) {
            Set-ItResult -Skipped -Because $script:skip; return
        }

        # --no-index evaluates the ignore RULES alone (default check-ignore consults the index and would
        # report a wrongly-tracked file as "not ignored", masking the defect the tracking test isolates).
        $notIgnored = @(foreach ($entry in $script:entries) {
                if ($entry.committed) {
                    continue
                }
                & git -C $script:repoRoot check-ignore --no-index -- $entry.target *> $null
                if ($LASTEXITCODE -ne 0) {
                    $entry.target
                }
            })
        $notIgnored | Should -HaveCount 0 -Because "no .gitignore rule ignores these managed root files: $($notIgnored -join '; ')"
    }

    It 'tracks no committed:false target in git' {
        if ($script:skip) {
            Set-ItResult -Skipped -Because $script:skip; return
        }

        $tracked = @(foreach ($entry in $script:entries) {
                if ($entry.committed) {
                    continue
                }
                & git -C $script:repoRoot ls-files --error-unmatch -- $entry.target *> $null
                if ($LASTEXITCODE -eq 0) {
                    $entry.target
                }
            })
        $tracked | Should -HaveCount 0 -Because "these managed root files are committed but must be gitignored artifacts — run 'git rm --cached <path>': $($tracked -join '; ')"
    }

    It 'tracks every committed:true target in git' {
        if ($script:skip) {
            Set-ItResult -Skipped -Because $script:skip; return
        }

        $untracked = @(foreach ($entry in $script:entries) {
                if (-not $entry.committed) {
                    continue
                }
                & git -C $script:repoRoot ls-files --error-unmatch -- $entry.target *> $null
                if ($LASTEXITCODE -ne 0) {
                    $entry.target
                }
            })
        $untracked | Should -HaveCount 0 -Because "these committed:true managed files must stay tracked (they are needed before the importer runs): $($untracked -join '; ')"
    }

    It 'ignores no committed:true target' {
        if ($script:skip) {
            Set-ItResult -Skipped -Because $script:skip; return
        }

        $ignored = @(foreach ($entry in $script:entries) {
                if (-not $entry.committed) {
                    continue
                }
                & git -C $script:repoRoot check-ignore --no-index -- $entry.target *> $null
                if ($LASTEXITCODE -eq 0) {
                    $entry.target
                }
            })
        $ignored | Should -HaveCount 0 -Because "these committed:true managed files must not match an ignore rule: $($ignored -join '; ')"
    }
}

# The root PSScriptAnalyzerSettings.psd1 is the first migrated copy-in and has a consumer-format contract of
# its own: PSScriptAnalyzer requires a literal-hashtable settings file, so the generated copy (hash header +
# copied source) must still parse as one — and carry exactly the authored settings.
Describe 'Root PSScriptAnalyzerSettings.psd1 copy-in' -Tag 'L1', 'integrity' {
    It 'parses as a settings hashtable with exactly the authored content' {
        $entry = @(Get-Config -Config rootconfig | ForEach-Object files |
                Where-Object { $_.target -eq 'PSScriptAnalyzerSettings.psd1' -and $_.optIn })
        if (-not $entry) {
            Set-ItResult -Skipped -Because 'entry_not_opted_in'; return
        }

        $rootPath = Resolve-RepoPath 'PSScriptAnalyzerSettings.psd1'
        if (-not (Test-Path $rootPath)) {
            # The importer tail materialises it on every load; produce it here if this session predates the entry.
            Build-RootConfig -Target 'PSScriptAnalyzerSettings.psd1' -Silent | Out-Null
        }

        $root = Import-PowerShellDataFile $rootPath
        $source = Import-PowerShellDataFile (Resolve-RepoPath $entry[0].source)
        ($root | ConvertTo-Json -Depth 8) | Should -Be ($source | ConvertTo-Json -Depth 8)
    }
}
