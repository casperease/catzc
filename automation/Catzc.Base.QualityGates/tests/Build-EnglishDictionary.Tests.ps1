<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/tests/Build-EnglishDictionary.Tests.ps1
    kind: test
    language: powershell
    filekind: ps1
    track: automation
    module: Catzc.Base.QualityGates
    relatives:
      page: docs/references/automation/catzc-base-qualitygates/tests/Build-EnglishDictionary.Tests.ps1.md
      source: automation/Catzc.Base.QualityGates/Build-EnglishDictionary.ps1
    adrs:
      - ADR-AUTO-TEST#1
---
#>

Describe 'Build-EnglishDictionary' -Tag 'L0', 'logic' {
    It 'refuses to run outside the source tree before touching node (Assert-SourceTree)' {
        Mock Assert-SourceTree -ModuleName Catzc.Base.QualityGates { throw 'operates on the catzc source tree' }
        Mock Assert-Command -ModuleName Catzc.Base.QualityGates { }

        { Build-EnglishDictionary -DryRun } | Should -Throw '*operates on the catzc source tree*'
        Should -Invoke Assert-Command -ModuleName Catzc.Base.QualityGates -Times 0
    }
}

# source-only: it reads the committed artifact in the repository, which gives the same answer in both run modes.
Describe 'Build-EnglishDictionary — committed dictionary drift guard' -Tag 'L1', 'integrity', 'source-only' {
    It 'the committed english.txt.gz and its stamp match the tools.yml pin and each other (Test-GeneratedFiles)' {
        $result = Test-GeneratedFiles -Generator Build-EnglishDictionary -PassThru -OutputFolder (Join-Path $TestDrive 'generated-files')
        $result.IssueCount | Should -Be 0 -Because ($result.Issues -join "`n")
    }
}
