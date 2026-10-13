# Test-GeneratedReadmes over fixture READMEs in $TestDrive: the mappings, git's ignore check, and the index are
# mocked, so each test pins one rule. A hard link stands in for a materialised link (no privilege needed). Neutral
# fixture names ([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
Describe 'Test-GeneratedReadmes' -Tag 'L0', 'logic' {
    BeforeAll {
        $root = Join-Path $TestDrive 'repo'
        foreach ($folder in 'docs', 'widget', 'gadget') {
            [void][System.IO.Directory]::CreateDirectory((Join-Path $root $folder))
        }
        [System.IO.File]::WriteAllText((Join-Path $root 'docs/widget.md'), "# Widget`n")
        [System.IO.File]::WriteAllText((Join-Path $root 'docs/gadget.md'), "# Gadget`n")
        New-Item -ItemType HardLink -Path (Join-Path $root 'widget/README.md') -Value (Join-Path $root 'docs/widget.md') | Out-Null
        New-Item -ItemType HardLink -Path (Join-Path $root 'gadget/README.md') -Value (Join-Path $root 'docs/gadget.md') | Out-Null
        $script:out = Join-Path $TestDrive 'out'
    }

    BeforeEach {
        Mock Get-RepositoryRoot -ModuleName Catzc.Base.Docs { Join-Path $TestDrive 'repo' }
        Mock Write-Message -ModuleName Catzc.Base.Reports { }
        Mock Get-Config -ModuleName Catzc.Base.Docs -ParameterFilter { $Config -eq 'readme' } { [pscustomobject]@{} }
        Mock Get-ReadmeMappings -ModuleName Catzc.Base.Docs {
            [pscustomobject]@{ folder = 'widget'; source = 'docs/widget.md' }
            [pscustomobject]@{ folder = 'gadget'; source = 'docs/gadget.md' }
        }
        $script:ignored = @('widget/README.md', 'gadget/README.md')
        Mock Invoke-Executable -ModuleName Catzc.Base.Docs -ParameterFilter { $Command -match ' check-ignore --no-index ' } {
            [pscustomobject]@{ Output = $ignored -join "`n"; Errors = ''; ExitCode = [int]($ignored.Count -eq 0) }
        }
        Mock Get-GitTrackedPath -ModuleName Catzc.Base.Docs { }
    }

    It 'passes when every generated README is ignored, untracked, and a link to its source' {
        $result = Test-GeneratedReadmes -OutputFolder $out -PassThru
        $result.IssueCount | Should -Be 0
        $result.Readmes | Should -Be 2
    }

    It 'throws once naming an unignored, a tracked, and a broken README' {
        $script:ignored = @('gadget/README.md')
        Mock Get-GitTrackedPath -ModuleName Catzc.Base.Docs { 'gadget/README.md' }
        Mock Get-ReadmeMappings -ModuleName Catzc.Base.Docs {
            [pscustomobject]@{ folder = 'widget'; source = 'docs/widget.md' }
            [pscustomobject]@{ folder = 'gadget'; source = 'docs/widget.md' }
        }
        $thrown = { Test-GeneratedReadmes -OutputFolder $out } | Should -Throw -PassThru
        $message = $thrown.Exception.Message
        $message | Should -BeLike 'Test-GeneratedReadmes failed: 3 issue(s)*'
        $message | Should -Match 'widget/README.md: no .gitignore rule ignores this generated README'
        $message | Should -Match "gadget/README.md: committed, but a generated README is a gitignored artifact"
        $message | Should -Match 'gadget/README.md: missing, stale, or not a link to docs/widget.md'
    }

    It 'throws on a git failure rather than reporting every README unignored' {
        Mock Invoke-Executable -ModuleName Catzc.Base.Docs -ParameterFilter { $Command -match ' check-ignore ' } {
            [pscustomobject]@{ Output = ''; Errors = 'fatal: not a git repository'; ExitCode = 128 }
        }
        { Test-GeneratedReadmes -OutputFolder $out } | Should -Throw '*git check-ignore failed (128)*'
    }

    It 'returns the issues under -PassThru instead of throwing' {
        $script:ignored = @('widget/README.md')
        $result = Test-GeneratedReadmes -OutputFolder $out -PassThru
        $result.Subject | Should -Be 'generated-readmes'
        $result.Issues | Should -HaveCount 1
    }
}

# Integrity gate for generated README links, over the real repository through Test-GeneratedReadmes
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
            $script:result = Test-GeneratedReadmes -PassThru -OutputFolder (Join-Path $TestDrive 'generated-readmes')
        }
    }

    It 'resolves configured README targets (guards against a vacuous pass)' {
        if ($script:skip) {
            Set-ItResult -Skipped -Because $script:skip; return
        }
        $result.Readmes | Should -BeGreaterThan 0
    }

    It 'ignores, untracks, and links every generated README' {
        if ($script:skip) {
            Set-ItResult -Skipped -Because $script:skip; return
        }
        $result.IssueCount | Should -Be 0 -Because ($result.Issues -join "`n")
    }
}
