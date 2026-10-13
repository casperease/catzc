# Test-ReadmeLinks over fixture READMEs in $TestDrive: the mappings, git's ignore check, and the index are mocked, so
# each test pins one rule. A hard link stands in for a materialised link (no privilege needed). Neutral fixture names
# ([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
Describe 'Test-ReadmeLinks' -Tag 'L0', 'logic' {
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

    It 'passes when every generated README is ignored, not tracked, and a link to its source' {
        $result = Test-ReadmeLinks -OutputFolder $out -PassThru
        $result.IssueCount | Should -Be 0
        $result.Links | Should -Be 2
    }

    It 'throws once naming an unignored, a tracked, and a broken README' {
        $script:ignored = @('gadget/README.md')
        Mock Get-GitTrackedPath -ModuleName Catzc.Base.Docs { 'gadget/README.md' }
        Mock Get-ReadmeMappings -ModuleName Catzc.Base.Docs {
            [pscustomobject]@{ folder = 'widget'; source = 'docs/widget.md' }
            [pscustomobject]@{ folder = 'gadget'; source = 'docs/widget.md' }
        }
        $thrown = { Test-ReadmeLinks -OutputFolder $out } | Should -Throw -PassThru
        $message = $thrown.Exception.Message
        $message | Should -BeLike 'Test-ReadmeLinks failed: 3 issue(s)*'
        $message | Should -Match 'widget/README.md: no .gitignore rule ignores this generated README'
        $message | Should -Match 'gadget/README.md: committed, but a generated README is a gitignored artifact'
        $message | Should -Match 'gadget/README.md: missing, stale, or not a link to docs/widget.md'
    }

    It 'throws on a git failure rather than reporting every README unignored' {
        Mock Invoke-Executable -ModuleName Catzc.Base.Docs -ParameterFilter { $Command -match ' check-ignore ' } {
            [pscustomobject]@{ Output = ''; Errors = 'fatal: not a git repository'; ExitCode = 128 }
        }
        { Test-ReadmeLinks -OutputFolder $out } | Should -Throw '*git check-ignore failed (128)*'
    }

    It 'returns the issues under -PassThru instead of throwing' {
        $script:ignored = @('widget/README.md')
        $result = Test-ReadmeLinks -OutputFolder $out -PassThru
        $result.Subject | Should -Be 'readme-links'
        $result.Issues | Should -HaveCount 1
    }
}
