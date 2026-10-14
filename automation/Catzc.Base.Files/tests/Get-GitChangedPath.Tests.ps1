Describe 'Get-GitChangedPath' -Tag 'L0', 'logic' {
    # git status is the mocked boundary: the -z porcelain it would print, NUL-separated. Neutral fixture names
    # ([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)).
    BeforeEach {
        $script:porcelain = ''
        Mock Get-RepositoryRoot -ModuleName Catzc.Base.Files { 'C:\widget-repo' }
        Mock Invoke-Executable -ModuleName Catzc.Base.Files { [pscustomobject]@{ ExitCode = 0; Output = $script:porcelain } }
    }

    It 'lists modified, staged, untracked and deleted paths once each, sorted ordinally' {
        $script:porcelain = (' M widget/b.ps1', 'A  widget/a.ps1', '?? gadget/new file.md', ' D widget/gone.ps1', 'MM widget/b.ps1', '') -join "`0"
        Get-GitChangedPath | Should -Be @('gadget/new file.md', 'widget/a.ps1', 'widget/b.ps1', 'widget/gone.ps1')
    }

    It 'returns nothing when the working tree matches HEAD' {
        @(Get-GitChangedPath) | Should -HaveCount 0
    }

    It 'asks git once, from the repository root, for every change under the paths with renames split' {
        Get-GitChangedPath 'widget', 'docs' | Out-Null
        Should -Invoke Invoke-Executable -ModuleName Catzc.Base.Files -Times 1 -Exactly -ParameterFilter {
            $Command -eq 'git status --porcelain=v1 -z --untracked-files=all --no-renames -- "widget" "docs"' -and
            $WorkingDirectory -eq 'C:\widget-repo'
        }
    }
}

Describe 'Get-GitChangedPath against real git' -Tag 'L2', 'logic' {
    # One real repository in TestDrive: the porcelain parse against git's own -z output, rename split included.
    BeforeAll {
        $script:repo = Join-Path $TestDrive 'gadget-repo'
        [void][System.IO.Directory]::CreateDirectory($script:repo)
        $git = { param([string] $Arguments) Invoke-Executable "git $Arguments" -WorkingDirectory $script:repo -Silent }
        & $git 'init -q'
        & $git 'config user.email widget@example.invalid'
        & $git 'config user.name Widget'
        foreach ($name in 'kept.txt', 'edited.txt', 'moved.txt', 'removed.txt') {
            [System.IO.File]::WriteAllText((Join-Path $script:repo $name), "$name`n")
        }
        & $git 'add -A'
        & $git 'commit -q -m fixture'
        [System.IO.File]::WriteAllText((Join-Path $script:repo 'edited.txt'), "changed`n")
        & $git 'mv moved.txt renamed.txt'
        [System.IO.File]::Delete((Join-Path $script:repo 'removed.txt'))
        [System.IO.File]::WriteAllText((Join-Path $script:repo 'new.txt'), "new`n")
        Mock Get-RepositoryRoot -ModuleName Catzc.Base.Files { $script:repo }
    }

    It 'lists the edited, the new, the deleted, and both paths of a rename' {
        Get-GitChangedPath | Should -Be @('edited.txt', 'moved.txt', 'new.txt', 'removed.txt', 'renamed.txt')
    }
}
