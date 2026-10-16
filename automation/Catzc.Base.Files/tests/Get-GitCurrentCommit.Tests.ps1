<#
---
catzc:
  immutable:
    path: automation/Catzc.Base.Files/tests/Get-GitCurrentCommit.Tests.ps1
    folder: tests
    name: get-git-current-commit-tests
    filetype: ps1
    kind: test
    language: powershell
    track: automation
    module: Catzc.Base.Files
    moduletype: pwsh-folder
    catzc_bundle: azure
---
#>

Describe 'Get-GitCurrentCommit' -Tag 'L0', 'logic' {
    BeforeEach {
        # A checkout written by hand: HEAD on main, main at a made-up commit. No git process starts.
        $script:root = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))
        $gitDir = Join-Path $script:root '.git'
        [System.IO.Directory]::CreateDirectory((Join-Path $gitDir 'refs/heads')) | Out-Null
        [System.IO.File]::WriteAllText((Join-Path $gitDir 'HEAD'), "ref: refs/heads/main`n")
        $script:commit = '{0:x40}' -f 42
        [System.IO.File]::WriteAllText((Join-Path $gitDir 'refs/heads/main'), "$script:commit`n")
        Mock Get-RepositoryRoot { $script:root } -ModuleName Catzc.Base.Files
        Mock Invoke-Executable { throw 'no git process should start' } -ModuleName Catzc.Base.Files
    }

    It 'returns the commit HEAD names, read from the ref files without starting git' {
        Get-GitCurrentCommit | Should -Be $script:commit
        Should -Invoke Invoke-Executable -ModuleName Catzc.Base.Files -Times 0
    }

    It 'returns the commit of a detached HEAD' {
        $detached = '{0:x40}' -f 7
        [System.IO.File]::WriteAllText((Join-Path $script:root '.git/HEAD'), "$detached`n")
        Get-GitCurrentCommit | Should -Be $detached
    }
}
