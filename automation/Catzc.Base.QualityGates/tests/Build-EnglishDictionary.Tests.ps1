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
    # Binds to the shipped english.txt.gz + its stamp and the pinned tools.yml version — an integrity test
    # ([ADR-AUTO-TEST#1](/docs/adr/automation/test-automation.md#rule-adr-auto-test1)). It detects a stale dictionary
    # WITHOUT re-running node: it compares the recorded cspell version
    # against the tools.yml pin, and the recorded word count against the actual gz. Re-run Build-EnglishDictionary
    # (and commit the gz + stamp) when a failure says the pin moved.
    BeforeAll {
        $assetsDir = Join-Path (Get-RepositoryRoot) 'automation/Catzc.Base.QualityGates/assets'
        $script:gzipPath = Join-Path $assetsDir 'english.txt.gz'
        $script:stampPath = Join-Path $assetsDir 'english.stamp'
    }

    It 'ships the committed english.txt.gz and its stamp' {
        $script:gzipPath | Should -Exist
        $script:stampPath | Should -Exist
    }

    It 'the stamp records a cspell version matching the tools.yml pin' {
        $stamp = Get-Content $script:stampPath -Raw | ConvertFrom-Json
        $pinned = (Get-ToolConfig -Tool 'cspell').version
        $stamp.cspell.StartsWith($pinned) |
            Should -BeTrue -Because "english.txt.gz was flattened from cspell $($stamp.cspell) but tools.yml now pins '$pinned' — re-run Build-EnglishDictionary and commit the gz + stamp"
    }

    It 'the stamp word count matches the committed gz' {
        $bytes = [System.IO.File]::ReadAllBytes($script:gzipPath)
        $text = [System.Text.Encoding]::UTF8.GetString([Catzc.Base.QualityGates.GzipText]::Decompress($bytes))
        $actual = @($text -split "`n" | Where-Object { $_ }).Count
        $stamp = Get-Content $script:stampPath -Raw | ConvertFrom-Json
        $actual |
            Should -Be $stamp.word_count -Because 'the committed gz and its stamp are out of sync — re-run Build-EnglishDictionary and commit both'
    }
}
