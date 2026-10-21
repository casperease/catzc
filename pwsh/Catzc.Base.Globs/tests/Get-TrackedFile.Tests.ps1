<#
---
catzc:
  immutable:
    with_body_sha: "0693259581ac"
  edges:
    docs: "[Get-TrackedFile.Tests.ps1.md](docs/references/pwsh/catzc-base-globs/tests/Get-TrackedFile.Tests.ps1.md)"
    code: pwsh/Catzc.Base.Globs/Get-TrackedFile.ps1
    cites:
      - ADR-FLOW-CD-GLOBS-TRACKEDFILESONLY
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
