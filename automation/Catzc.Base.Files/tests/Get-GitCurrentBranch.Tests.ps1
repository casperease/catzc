<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Files/tests/Get-GitCurrentBranch.Tests.ps1
    kind: test
    language: powershell
    filekind: ps1
    track: automation
    module: Catzc.Base.Files
    relatives:
      source: automation/Catzc.Base.Files/Get-GitCurrentBranch.ps1
---
#>

Describe 'Get-GitCurrentBranch' -Tag 'L0', 'logic' {
    BeforeEach {
        # A checkout written by hand. No git process starts.
        $script:root = Join-Path $TestDrive ([guid]::NewGuid().ToString('N'))
        [System.IO.Directory]::CreateDirectory((Join-Path $script:root '.git')) | Out-Null
        Mock Get-RepositoryRoot { $script:root } -ModuleName Catzc.Base.Files
        Mock Invoke-Executable { throw 'no git process should start' } -ModuleName Catzc.Base.Files
    }

    It 'returns the short branch name HEAD is on' {
        [System.IO.File]::WriteAllText((Join-Path $script:root '.git/HEAD'), "ref: refs/heads/feature/widget`n")
        Get-GitCurrentBranch | Should -Be 'feature/widget'
    }

    It "returns 'HEAD' when HEAD is detached" {
        [System.IO.File]::WriteAllText((Join-Path $script:root '.git/HEAD'), ('{0:x40}' -f 7) + "`n")
        Get-GitCurrentBranch | Should -Be 'HEAD'
    }
}
