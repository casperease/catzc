<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Files/tests/Get-GitIndexPath.Tests.ps1
    kind: test
    language: powershell
    filetype: ps1
    track: automation
    module: Catzc.Base.Files
    moduletype: pwsh-folder-module
    bundle: azure
---
#>

Describe 'Get-GitIndexPath' -Tag 'L0', 'logic' {
    BeforeEach {
        $script:root = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))
        [System.IO.Directory]::CreateDirectory($script:root) | Out-Null
        Mock Get-RepositoryRoot { $script:root } -ModuleName Catzc.Base.Files
    }

    It 'returns .git/index under the root for a plain checkout' {
        [System.IO.Directory]::CreateDirectory((Join-Path $script:root '.git')) | Out-Null
        InModuleScope Catzc.Base.Files { Get-GitIndexPath } | Should -Be (Join-Path $script:root '.git/index')
    }

    It 'follows a relative gitdir pointer (a linked worktree), resolved against the root' {
        [System.IO.File]::WriteAllText((Join-Path $script:root '.git'), "gitdir: ../main/.git/worktrees/widget`n")
        $expected = Join-Path ([System.IO.Path]::GetFullPath('../main/.git/worktrees/widget', $script:root)) 'index'
        InModuleScope Catzc.Base.Files { Get-GitIndexPath } | Should -Be $expected
    }

    It 'follows an absolute gitdir pointer' {
        $gitDir = Join-Path $TestDrive 'gadget.git'
        [System.IO.File]::WriteAllText((Join-Path $script:root '.git'), "gitdir: $gitDir")
        InModuleScope Catzc.Base.Files { Get-GitIndexPath } | Should -Be (Join-Path $gitDir 'index')
    }

    It 'throws when the root is not a git checkout' {
        { InModuleScope Catzc.Base.Files { Get-GitIndexPath } } | Should -Throw '*is not a git checkout*'
    }

    It 'throws when .git is a file that is not a gitdir pointer' {
        [System.IO.File]::WriteAllText((Join-Path $script:root '.git'), 'widget')
        { InModuleScope Catzc.Base.Files { Get-GitIndexPath } } | Should -Throw "*not a 'gitdir:' pointer*"
    }
}
