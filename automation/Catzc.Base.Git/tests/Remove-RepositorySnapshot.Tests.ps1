<#
---
catzc:
  immutable:
    path: automation/Catzc.Base.Git/tests/Remove-RepositorySnapshot.Tests.ps1
    folder: tests
    name: remove-repository-snapshot-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.Git
    moduletype: pwsh-folder
    catzc_bundle: azure
---
#>

Describe 'Remove-RepositorySnapshot' -Tag 'L0', 'logic' {
    It 'refuses a folder that carries no snapshot marker and leaves it in place' {
        $folder = Join-Path $TestDrive 'not-a-snapshot'
        [System.IO.Directory]::CreateDirectory((Join-Path $folder '.git')) | Out-Null
        { Remove-RepositorySnapshot $folder } | Should -Throw '*not a repository snapshot*'
        [System.IO.Directory]::Exists($folder) | Should -BeTrue
    }

    It 'is a no-op for a path that does not exist' {
        { Remove-RepositorySnapshot (Join-Path $TestDrive 'never-created') } | Should -Not -Throw
    }
}
