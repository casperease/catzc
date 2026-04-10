Describe 'Format-Spelling' -Tag 'L0', 'logic' {
    BeforeEach {
        $script:queuePath = Join-Path $TestDrive 'terminology-triage.yml'
        # $TestDrive persists across Its in a file; clear any queue a prior test wrote.
        if (Test-Path $script:queuePath) {
            Remove-Item $script:queuePath -Force
        }

        $script:cspellExit = 1
        # Build the newline-delimited output by joining real words, so the test's own source carries no
        # coined tokens for the spelling gate to flag. Apple/mango are 'known' via the mocked registry below.
        $script:cspellOut = @('mango', 'banana', 'Apple', 'kiwi') -join "`n"

        Mock Get-RepositoryRoot -ModuleName Catzc.Base.QualityGates { $TestDrive }
        Mock Get-OutputRoot -ModuleName Catzc.Base.QualityGates { $TestDrive }
        Mock Assert-PathExist -ModuleName Catzc.Base.QualityGates { }
        Mock Test-Command -ModuleName Catzc.Base.QualityGates { $true }
        Mock Write-Message -ModuleName Catzc.Base.QualityGates { }
        Mock Invoke-Executable -ModuleName Catzc.Base.QualityGates {
            [pscustomobject]@{ ExitCode = $script:cspellExit; Full = $script:cspellOut; Output = $script:cspellOut }
        }
        # The registry already accepts apple/mango, so those are not queued for triage.
        Mock Get-Config -ModuleName Catzc.Base.QualityGates {
            [pscustomobject]@{ terms = @(
                    [pscustomobject]@{ term = 'apple' }
                    [pscustomobject]@{ term = 'mango' }
                )
            }
        }
    }

    It 'queues only the not-yet-known flagged tokens, ordinal-sorted' {
        $queued = Format-Spelling
        @($queued) | Should -Be @('banana', 'kiwi')
    }

    It 'writes paste-ready, uncategorized stubs to the triage queue under out/' {
        Format-Spelling | Out-Null
        Test-Path $script:queuePath | Should -BeTrue
        $raw = [System.IO.File]::ReadAllText($script:queuePath)
        $raw | Should -Match '(?m)^- term: banana'
        $raw | Should -Match '(?m)^- term: kiwi'
        # The stub carries a blank meaning and no category, so a copy-paste into terminology.yml fails to load
        # (category is required) until a human classifies it.
        $raw | Should -Match "meaning: ''"
        $raw | Should -Not -Match '(?m)^\s*category:'
    }

    It 'is case-insensitive against the registry (does not queue Apple/mango)' {
        $queued = Format-Spelling
        @($queued) | Should -Not -Contain 'apple'
        @($queued) | Should -Not -Contain 'mango'
    }

    It 'with -DryRun returns the tokens but writes no triage file' {
        $queued = Format-Spelling -DryRun
        @($queued) | Should -Be @('banana', 'kiwi')
        Test-Path $script:queuePath | Should -BeFalse
    }

    It 'is a no-op (no file) when every flagged token is already accepted' {
        $script:cspellOut = @('apple', 'Mango') -join "`n"
        @(Format-Spelling).Count | Should -Be 0
        Test-Path $script:queuePath | Should -BeFalse
    }

    It 'is a no-op when cspell finds nothing (clean, exit 0)' {
        $script:cspellExit = 0
        $script:cspellOut = ''
        @(Format-Spelling).Count | Should -Be 0
        Test-Path $script:queuePath | Should -BeFalse
    }

    It 'never writes to cspell.yml (the pump is gone)' {
        Format-Spelling | Out-Null
        Should -Not -Invoke Invoke-Executable -ModuleName Catzc.Base.QualityGates -ParameterFilter {
            $Command -match 'WriteAllText'
        }
        # cspell.yml is read-only input here; the only file written is the out/ triage queue.
        Test-Path (Join-Path $TestDrive 'cspell.yml') | Should -BeFalse
    }

    It 'asks cspell for bare tokens only (--words-only) over the repo config' {
        Format-Spelling | Out-Null
        Should -Invoke Invoke-Executable -ModuleName Catzc.Base.QualityGates -ParameterFilter {
            $Command -match 'lint' -and $Command -match '--words-only' -and $Command -match 'cspell\.yml'
        }
    }

    It 'throws an actionable error when cspell is not installed' {
        Mock Test-Command -ModuleName Catzc.Base.QualityGates { $false }
        { Format-Spelling } | Should -Throw '*Install-Cspell*'
    }

    It 'throws a tool error when cspell exits greater than 1' {
        $script:cspellExit = 2
        $script:cspellOut = 'configuration error'
        { Format-Spelling } | Should -Throw '*cspell failed*'
    }
}
