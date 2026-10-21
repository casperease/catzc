<#
---
catzc:
  immutable:
    with_body_sha: "6b2d6d55098b"
  edges:
    docs: "[Test-GeneratedReadmes.Tests.ps1.md](../../../docs/references/pwsh/catzc-base-docs/tests/Test-GeneratedReadmes.Tests.ps1.md)"
    code: pwsh/Catzc.Base.Docs/Test-GeneratedReadmes.ps1
    cites:
      - ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES
      - ADR-REPO-README
---
#>

Describe 'Test-GeneratedReadmes' -Tag 'L0', 'logic' {
    BeforeAll {
        $script:root = Join-Path $TestDrive 'repo'
        foreach ($folder in 'docs', 'widget', 'gadget') {
            [void][System.IO.Directory]::CreateDirectory((Join-Path $script:root $folder))
        }
        [System.IO.File]::WriteAllText((Join-Path $script:root 'docs/widget.md'), "# docs/widget.md`n`nSee [gadget](gadget.md).`n")
        [System.IO.File]::WriteAllText((Join-Path $script:root 'docs/gadget.md'), "# docs/gadget.md`n")
        $script:out = Join-Path $TestDrive 'out'
    }

    BeforeEach {
        Mock Get-RepositoryRoot -ModuleName Catzc.Base.Docs { $script:root }
        Mock Resolve-RepoPath -ModuleName Catzc.Base.Docs { Join-Path $script:root $Path }
        Mock Write-Message -ModuleName Catzc.Base.Reports { }
        Mock Get-Config -ModuleName Catzc.Base.Docs -ParameterFilter { $Config -eq 'readme' } { [pscustomobject]@{} }
        $script:mappings = @(
            [pscustomobject]@{ folder = 'widget'; source = 'docs/widget.md' }
            [pscustomobject]@{ folder = 'gadget'; source = 'docs/gadget.md' }
        )
        Mock Get-ReadmeMappings -ModuleName Catzc.Base.Docs { $script:mappings }
        $script:ignored = @('widget/README.md', 'gadget/README.md')
        Mock Invoke-Executable -ModuleName Catzc.Base.Docs -ParameterFilter { $Command -match ' check-ignore --no-index ' } {
            [pscustomobject]@{ Output = $script:ignored -join "`n"; Errors = ''; ExitCode = [int]($script:ignored.Count -eq 0) }
        }
        Mock Get-GitTrackedPath -ModuleName Catzc.Base.Docs { }

        # Every README current, as Build-Readme writes it.
        foreach ($mapping in $script:mappings) {
            $content = InModuleScope Catzc.Base.Docs -Parameters @{ Mapping = $mapping } { param($Mapping) Get-ReadmeContent -Mapping $Mapping }
            [System.IO.File]::WriteAllText((Join-Path $script:root "$($mapping.folder)/README.md"), $content)
        }
    }

    It 'passes when every generated README is ignored, not tracked, and current' {
        $result = Test-GeneratedReadmes -OutputFolder $script:out -PassThru
        $result.IssueCount | Should -Be 0 -Because ($result.Issues -join "`n")
        $result.Facts['Readmes'] | Should -Be 2
    }

    It 'throws once naming an unignored, a tracked, and a stale README' {
        $script:ignored = @('gadget/README.md')
        Mock Get-GitTrackedPath -ModuleName Catzc.Base.Docs { 'gadget/README.md' }
        [System.IO.File]::WriteAllText((Join-Path $script:root 'gadget/README.md'), "# An old copy`n")
        $thrown = { Test-GeneratedReadmes -OutputFolder $script:out } | Should -Throw -PassThru
        $message = $thrown.Exception.Message
        $message | Should -BeLike 'Test-GeneratedReadmes failed: 3 issue(s)*'
        $message | Should -Match 'widget/README.md: no .gitignore rule ignores this generated README'
        $message | Should -Match 'gadget/README.md: committed, but a generated README is a gitignored artifact'
        $message | Should -Match 'gadget/README.md: missing, or stale against docs/gadget.md'
    }

    It 'reports a missing README' {
        [System.IO.File]::Delete((Join-Path $script:root 'widget/README.md'))
        $result = Test-GeneratedReadmes -OutputFolder $script:out -PassThru
        $result.Issues | Should -Be @('widget/README.md: missing, or stale against docs/widget.md — re-run the importer (Build-Readme regenerates it)')
    }

    It 'accepts a CRLF copy of current content' {
        $path = Join-Path $script:root 'widget/README.md'
        [System.IO.File]::WriteAllText($path, ([System.IO.File]::ReadAllText($path) -replace "`n", "`r`n"))
        (Test-GeneratedReadmes -OutputFolder $script:out -PassThru).IssueCount | Should -Be 0
    }

    It 'throws on a git failure rather than reporting every README unignored' {
        Mock Invoke-Executable -ModuleName Catzc.Base.Docs -ParameterFilter { $Command -match ' check-ignore ' } {
            [pscustomobject]@{ Output = ''; Errors = 'fatal: not a git repository'; ExitCode = 128 }
        }
        { Test-GeneratedReadmes -OutputFolder $script:out } | Should -Throw '*git check-ignore failed (128)*'
    }

    It 'returns the issues under -PassThru instead of throwing' {
        $script:ignored = @('widget/README.md')
        $result = Test-GeneratedReadmes -OutputFolder $script:out -PassThru
        $result.Subject | Should -Be 'generated-readmes'
        $result.Issues | Should -HaveCount 1
    }
}

Describe 'Generated READMEs are gitignored, untracked, and current' -Tag 'L2', 'integrity', 'source-only' {
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
            $script:result = Test-GeneratedReadmes -PassThru -OutputFolder (Join-Path $TestDrive 'generated-readmes')
        }
    }

    It 'resolves configured README targets (guards against a vacuous pass)' {
        if ($script:skip) {
            Set-ItResult -Skipped -Because $script:skip; return
        }
        $script:result.Facts['Readmes'] | Should -BeGreaterThan 0
    }

    It 'ignores every generated README, keeps it out of git, and keeps it current with its source' {
        if ($script:skip) {
            Set-ItResult -Skipped -Because $script:skip; return
        }
        $script:result.IssueCount | Should -Be 0 -Because ($script:result.Issues -join "`n")
    }
}
