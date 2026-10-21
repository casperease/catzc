<#
---
catzc:
  immutable:
    with_body_sha: "7b617f13a486"
  edges:
    code: pwsh/Catzc.Base.Git/Test-RepositorySnapshot.ps1
---
#>

Describe 'Test-RepositorySnapshot' -Tag 'L0', 'logic' {
    BeforeEach {
        $script:widgetRoot = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))
        [System.IO.Directory]::CreateDirectory((Join-Path $script:widgetRoot '.git')) | Out-Null
    }

    It 'is false for an ordinary repository' {
        Test-RepositorySnapshot $script:widgetRoot | Should -BeFalse
    }

    It 'is true for a repository carrying the snapshot marker' {
        [System.IO.File]::WriteAllText((Join-Path $script:widgetRoot '.git/catzc-snapshot.json'), '{}')
        Test-RepositorySnapshot $script:widgetRoot | Should -BeTrue
    }

    It 'defaults to the loaded repository root' {
        Mock Get-RepositoryRoot { $script:widgetRoot } -ModuleName Catzc.Base.Git
        [System.IO.File]::WriteAllText((Join-Path $script:widgetRoot '.git/catzc-snapshot.json'), '{}')
        Test-RepositorySnapshot | Should -BeTrue
    }
}
