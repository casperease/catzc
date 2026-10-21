<#
---
catzc:
  immutable:
    with_body_sha: "5d6a0343d927"
  edges:
    code: pwsh/Catzc.Base.Git/Remove-RepositorySnapshot.ps1
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
