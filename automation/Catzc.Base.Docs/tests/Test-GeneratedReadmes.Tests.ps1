# Integrity gate for generated README copy-ins.
#
# readme.yml (expanded by Get-ReadmeMappings) is the registry of folders whose README.md is a GENERATED
# copy-in of a docs/ source — a derived artifact, never authored in place. Every such README must therefore be:
#   1. matched by a .gitignore ignore rule (so a fresh Build-Readme output is never accidentally stageable), and
#   2. absent from git tracking (removed with `git rm --cached` if it was ever committed).
# Hand-authored READMEs are exactly the folders NOT in readme.yml; they are individually un-ignored in
# .gitignore and are out of scope here. See docs/adr/repository/generated-readmes.md.
Describe 'Generated README copy-ins are gitignored and untracked' -Tag 'L2', 'integrity' {
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

        # Resolve the configured targets exactly as Build-Readme does: expand readme.yml through
        # Get-ReadmeMappings (private, so reached via the module per ADR-PESTER:4) against the real repo root.
        # Each target folder's generated file is "<folder>/README.md".
        $script:targets = @()
        if (-not $script:skip) {
            $config = Get-Config -Config readme
            $mappings = InModuleScope Catzc.Base.Docs -Parameters @{ Config = $config } {
                param($Config) Get-ReadmeMappings -Config $Config
            }
            $script:targets = @($mappings.folder | ForEach-Object { "$_/README.md" } | Sort-Object -Unique)
        }
    }

    It 'resolves configured README targets (guards against a vacuous pass)' {
        if ($script:skip) {
            Set-ItResult -Skipped -Because $script:skip; return
        }
        @($script:targets).Count | Should -BeGreaterThan 0
    }

    It 'covers every generated README with a .gitignore ignore rule' {
        if ($script:skip) {
            Set-ItResult -Skipped -Because $script:skip; return
        }

        # --no-index evaluates the ignore RULES alone. Default check-ignore consults the index and would report
        # a wrongly-tracked file as "not ignored", masking the very defect the next test isolates. Exit 0 = the
        # path is ignored; a negated/opted-in path exits non-zero, which for a configured target is itself a
        # violation worth surfacing here.
        $notIgnored = @($script:targets | Where-Object {
                & git -C $script:repoRoot check-ignore --no-index -- $_ *> $null
                $LASTEXITCODE -ne 0
            })
        $notIgnored | Should -HaveCount 0 -Because "no .gitignore rule ignores these generated READMEs: $($notIgnored -join '; ')"
    }

    It 'tracks none of the generated READMEs in git' {
        if ($script:skip) {
            Set-ItResult -Skipped -Because $script:skip; return
        }

        # ls-files --error-unmatch exits 0 only when the path is tracked. A generated artifact that is tracked
        # must be removed from the index: `git rm --cached <path>` (the file stays on disk, now correctly ignored).
        $tracked = @($script:targets | Where-Object {
                & git -C $script:repoRoot ls-files --error-unmatch -- $_ *> $null
                $LASTEXITCODE -eq 0
            })
        $tracked | Should -HaveCount 0 -Because "these generated READMEs are committed but must be gitignored artifacts — run 'git rm --cached <path>': $($tracked -join '; ')"
    }
}
