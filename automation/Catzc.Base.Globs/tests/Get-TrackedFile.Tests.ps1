<#
---
catzc:
  derived:
    path: automation/Catzc.Base.Globs/tests/Get-TrackedFile.Tests.ps1
    kind: pester-test
    language: powershell
    track: automation
    module: Catzc.Base.Globs
    relatives:
      page: docs/references/automation/catzc-base-globs/tests/Get-TrackedFile.Tests.ps1.md
      source: automation/Catzc.Base.Globs/Get-TrackedFile.ps1
    adrs:
      - ADR-FLOW-CD-GLOBS#4
---
#>

Describe 'Get-TrackedFile' -Tag 'L0', 'logic' {
    It "returns the whole repository's tracked set from Get-GitTrackedPath" {
        Mock Get-GitTrackedPath { @('a.txt', 'src/b.cs') } -ModuleName Catzc.Base.Globs

        InModuleScope Catzc.Base.Globs { Get-TrackedFile } | Should -Be @('a.txt', 'src/b.cs')
        Should -Invoke Get-GitTrackedPath -ModuleName Catzc.Base.Globs -Times 1 -Exactly -ParameterFilter { $Path -eq '.' }
    }
}

Describe 'Get-TrackedFile (real index)' -Tag 'L1', 'integrity', 'source-only' {
    It 'lists this repository''s tracked files as /-separated repo-relative paths' {
        $files = @(InModuleScope Catzc.Base.Globs { Get-TrackedFile })
        $files.Count | Should -BeGreaterThan 100
        $files | Should -Contain 'importer.ps1'
        @($files | Where-Object { $_ -like '*\*' }).Count | Should -Be 0
    }
}
