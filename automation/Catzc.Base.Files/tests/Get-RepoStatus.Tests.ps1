<#
---
catzc:
  immutable:
    path: automation/Catzc.Base.Files/tests/Get-RepoStatus.Tests.ps1
    folder: tests
    name: get-repo-status-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.Files
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    cites:
      - ADR-REPO-FILEMETA#13
---
#>

Describe 'Get-RepoStatus' -Tag 'L0', 'logic' {
    BeforeEach {
        $script:tracked = @('widget/a.md')
        $script:porcelain = ''
        $script:branch = 'main'
        $script:upstream = 'origin/main'
        $script:unpushed = ''
        Mock Get-RepositoryRoot -ModuleName Catzc.Base.Files { 'C:\widget-repo' }
        Mock Get-GitTrackedPath -ModuleName Catzc.Base.Files { $script:tracked }
        Mock Invoke-Executable -ModuleName Catzc.Base.Files {
            $output = switch -Wildcard ($Command) {
                'git status*' { $script:porcelain }
                'git branch*' { $script:branch }
                'git for-each-ref*' { $script:upstream }
                'git log*' { $script:unpushed }
            }
            [pscustomobject]@{ ExitCode = 0; Output = $output }
        }
    }

    It 'is unset for a file git does not track' {
        Get-RepoStatus 'gadget/new.md' | Should -Be 'unset'
    }

    It 'is edited when the working tree differs from the index' {
        $script:porcelain = " M widget/a.md`0"
        Get-RepoStatus 'widget/a.md' | Should -Be 'edited'
        $script:porcelain = "MM widget/a.md`0"
        Get-RepoStatus 'widget/a.md' | Should -Be 'edited'
    }

    It 'is staged when only the index differs from HEAD' {
        $script:porcelain = "M  widget/a.md`0"
        Get-RepoStatus 'widget/a.md' | Should -Be 'staged'
    }

    It 'is ready when unchanged on a branch with no upstream' {
        $script:upstream = ''
        Get-RepoStatus 'widget/a.md' | Should -Be 'ready'
    }

    It 'is committed when a commit touching the file is not on the upstream' {
        $script:unpushed = 'abc123'
        Get-RepoStatus 'widget/a.md' | Should -Be 'committed'
    }

    It 'is pushed when every commit touching the file is on the upstream' {
        Get-RepoStatus 'widget/a.md' | Should -Be 'pushed'
    }

    It 'accepts a backslash path' {
        Get-RepoStatus 'widget\a.md' | Should -Be 'pushed'
    }
}
