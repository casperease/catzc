Describe 'Build-EnglishDictionary' -Tag 'L0', 'logic' {
    It 'refuses to run outside the source tree before touching node (Assert-SourceTree)' {
        Mock Assert-SourceTree -ModuleName Catzc.Base.QualityGates { throw 'operates on the catzc source tree' }
        Mock Assert-Command -ModuleName Catzc.Base.QualityGates { }

        { Build-EnglishDictionary -DryRun } | Should -Throw '*operates on the catzc source tree*'
        Should -Invoke Assert-Command -ModuleName Catzc.Base.QualityGates -Times 0
    }
}

# source-only: it reads the committed artifact in the repository, which gives the same answer in both run modes.
Describe 'Build-EnglishDictionary — committed dictionary drift guard' -Tag 'L2', 'integrity', 'source-only' {
    It 'the committed english.txt.gz and its stamp match the tools.yml pin and each other (Test-GeneratedFiles)' {
        if (-not (Get-Command git -ErrorAction Ignore)) {
            Set-ItResult -Skipped -Because 'tool_git_missing'; return
        }
        $result = Test-GeneratedFiles -Generator Build-EnglishDictionary -PassThru -OutputFolder (Join-Path $TestDrive 'generated-files')
        $result.IssueCount | Should -Be 0 -Because ($result.Issues -join "`n")
    }
}

Describe 'Build-EnglishDictionary — shipped assets/english.txt.gz' -Tag 'L1', 'integrity', 'ADR-AUTO-ASSETDEP-COVEREDBYREALTEST' {
    It 'finds the word list and its stamp where it writes them, in the loaded QualityGates module' {
        $assets = [Catzc.Base.QualityGates.SpellingOracle]::AssetsFolder((Get-CatzcModuleRoot -Module Catzc.Base.QualityGates))
        [Catzc.Base.QualityGates.SpellingOracle]::DictionaryPath($assets) | Should -Exist
        [Catzc.Base.QualityGates.SpellingOracle]::DictionaryStampPath($assets) | Should -Exist
    }
}
