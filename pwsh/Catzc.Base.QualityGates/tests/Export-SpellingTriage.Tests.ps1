<#
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-quality-gates/tests/Export-SpellingTriage.Tests.ps1.md"
  warning: "Generated Header"
---
#>

Describe 'Export-SpellingTriage' -Tag 'L0', 'logic' {
    BeforeEach {
        $script:queuePath = Join-Path $TestDrive 'terminology-triage.yml'
        # $TestDrive persists across Its in a file; clear any queue a prior test wrote.
        if (Test-Path $script:queuePath) {
            Remove-Item $script:queuePath -Force
        }

        $script:cspellExit = 1
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
        Mock Get-Config -ModuleName Catzc.Base.QualityGates -ParameterFilter { $Config -eq 'terminology' } {
            [pscustomobject]@{ terms = @(
                    [pscustomobject]@{ term = 'apple' }
                    [pscustomobject]@{ term = 'mango' }
                )
            }
        }
    }

    It 'queues only the not-yet-known flagged tokens, ordinal-sorted' {
        $queued = Export-SpellingTriage
        @($queued) | Should -Be @('banana', 'kiwi')
    }

    It 'writes paste-ready, uncategorized stubs to the triage queue under out/' {
        Export-SpellingTriage | Out-Null
        Test-Path $script:queuePath | Should -BeTrue
        $raw = [System.IO.File]::ReadAllText($script:queuePath)
        $raw | Should -Match '(?m)^- term: banana'
        $raw | Should -Match '(?m)^- term: kiwi'
        $raw | Should -Match "meaning: ''"
        $raw | Should -Not -Match '(?m)^\s*category:'
    }

    It 'is case-insensitive against the registry (does not queue Apple/mango)' {
        $queued = Export-SpellingTriage
        @($queued) | Should -Not -Contain 'apple'
        @($queued) | Should -Not -Contain 'mango'
    }

    It 'with -DryRun returns the tokens but writes no triage file' {
        $queued = Export-SpellingTriage -DryRun
        @($queued) | Should -Be @('banana', 'kiwi')
        Test-Path $script:queuePath | Should -BeFalse
    }

    It 'is a no-op (no file) when every flagged token is already accepted' {
        $script:cspellOut = @('apple', 'Mango') -join "`n"
        @(Export-SpellingTriage).Count | Should -Be 0
        Test-Path $script:queuePath | Should -BeFalse
    }

    It 'is a no-op when cspell finds nothing (clean, exit 0)' {
        $script:cspellExit = 0
        $script:cspellOut = ''
        @(Export-SpellingTriage).Count | Should -Be 0
        Test-Path $script:queuePath | Should -BeFalse
    }

    It 'never writes to cspell.yml (the pump is gone)' {
        Export-SpellingTriage | Out-Null
        Should -Not -Invoke Invoke-Executable -ModuleName Catzc.Base.QualityGates -ParameterFilter {
            $Command -match 'WriteAllText'
        }
        # cspell.yml is read-only input here; the only file written is the out/ triage queue.
        Test-Path (Join-Path $TestDrive 'cspell.yml') | Should -BeFalse
    }

    It 'asks cspell for bare tokens only (--words-only) over the repo config' {
        Export-SpellingTriage | Out-Null
        Should -Invoke Invoke-Executable -ModuleName Catzc.Base.QualityGates -ParameterFilter {
            $Command -match 'lint' -and $Command -match '--words-only' -and $Command -match 'cspell\.yml'
        }
    }

    It 'excludes the configuration slots by the infrastructure track''s configs kind, not a fixed path' {
        Mock Get-TrackPlace -ModuleName Catzc.Base.QualityGates -ParameterFilter { $Track -eq 'infrastructure' -and $TrackKind -eq 'configs' } { 'gadgets/*/settings' }
        Export-SpellingTriage | Out-Null
        Should -Invoke Invoke-Executable -ModuleName Catzc.Base.QualityGates -ParameterFilter {
            $Command -match ([regex]::Escape("--exclude 'gadgets/*/settings/**'"))
        }
    }

    It 'throws an actionable error when cspell is not installed' {
        Mock Test-Command -ModuleName Catzc.Base.QualityGates { $false }
        { Export-SpellingTriage } | Should -Throw '*Install-Cspell*'
    }

    It 'throws a tool error when cspell exits greater than 1' {
        $script:cspellExit = 2
        $script:cspellOut = 'configuration error'
        { Export-SpellingTriage } | Should -Throw '*cspell failed*'
    }
}
