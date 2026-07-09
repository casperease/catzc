Describe 'Format-Pipelines' -Tag 'L0', 'logic' {
    BeforeEach {
        $script:prettierExit = 0
        $script:prettierOut = ''

        # Mock the tool boundary — never launch a real process in a unit test.
        Mock Invoke-Executable -ModuleName Catzc.Base.QualityGates {
            [pscustomobject]@{
                ExitCode = $script:prettierExit
                Full     = $script:prettierOut
                Output   = $script:prettierOut
            }
        }
        Mock Test-Command -ModuleName Catzc.Base.QualityGates { $true }
        Mock Write-Message -ModuleName Catzc.Base.QualityGates { }
    }

    It 'is reachable via the Invoke-PipelinePrettier alias' {
        (Get-Alias Invoke-PipelinePrettier -ErrorAction Ignore).Definition | Should -Be 'Format-Pipelines'
    }

    It 'defaults its scope to every ADO pipeline YAML (**/*.yaml)' {
        Format-Pipelines | Out-Null
        Should -Invoke Invoke-Executable -ModuleName Catzc.Base.QualityGates -ParameterFilter {
            $Command -match '\*\*/\*\.yaml'
        }
    }

    It 'in --write mode counts only the changed files (those without "(unchanged)")' {
        $script:prettierOut = @(
            'pipelines/ci-automation.yaml 10ms'
            'pipelines/cd-shared.yaml 5ms (unchanged)'
        ) -join "`n"
        $result = Format-Pipelines -PassThru
        $result.ChangedCount | Should -Be 1
        $result.ChangedFiles | Should -Be @('pipelines/ci-automation.yaml')
        $result.DryRun | Should -BeFalse
    }

    It '-DryRun calls prettier with --list-different and does not write' {
        Format-Pipelines -DryRun | Out-Null
        Should -Invoke Invoke-Executable -ModuleName Catzc.Base.QualityGates -ParameterFilter {
            $Command -match 'prettier' -and $Command -match '--list-different' -and $Command -notmatch '--write'
        }
    }

    It '-Check calls prettier with --check, returns unformatted files, and surfaces warnings' {
        $script:prettierExit = 1
        $script:prettierOut = "Checking formatting...`n[warn] pipelines/ci-infrastructure.yaml`n[warn] Code style issues found in 1 file. Run Prettier with --write to fix.`n"
        $result = Format-Pipelines -Check -PassThru
        $result.Check | Should -BeTrue
        $result.ChangedFiles | Should -Be @('pipelines/ci-infrastructure.yaml')
        $result.Warnings.Count | Should -Be 2
    }

    It 'throws a tool error when prettier exits greater than 1' {
        $script:prettierExit = 2
        $script:prettierOut = 'some prettier error'
        { Format-Pipelines } | Should -Throw '*Prettier failed*'
    }

    It 'throws an actionable error when prettier is not installed' {
        Mock Test-Command -ModuleName Catzc.Base.QualityGates { $false }
        { Format-Pipelines } | Should -Throw '*Install-Prettier*'
    }
}

Describe 'Format-Pipelines (real prettier)' -Tag 'L2', 'logic' {
    It 'formats a messy pipeline YAML so Prettier then reports it clean, preserving structure' {
        if (-not (Get-Command prettier -ErrorAction Ignore)) {
            Set-ItResult -Skipped -Because 'tool_prettier_missing'
            return
        }
        $file = Join-Path $TestDrive 'ci-sample.yaml'
        # Badly-indented mapping Prettier will normalise; keep a ${{ }} expression to prove it survives.
        $messy = @'
trigger:
    branches:
        include: [main]
steps:
  - script: "echo ${{ parameters.x }}"
'@
        Set-Content -Path $file -Value $messy -Encoding utf8
        $glob = $file -replace '\\', '/'
        $result = Format-Pipelines -Glob $glob -PassThru
        $result.ChangedCount | Should -Be 1
        (Get-Content $file -Raw) | Should -Match '\$\{\{ parameters\.x \}\}'
        # After formatting, prettier --list-different reports nothing to change.
        (Format-Pipelines -Glob $glob -DryRun -PassThru).ChangedCount | Should -Be 0
    }
}

# Integrity: the ACTUAL repository pipeline YAML is Prettier-clean. Binds to the real repo — Format-Pipelines
# with no -Glob scans its default **/*.yaml scope. L2 because it drives the Prettier CLI; self-skips when the
# tool is absent (ADR-AUTO-TEST:8/9). This is the formatting half of the L2 pipeline gate (Assert-Pipelines is the
# naming/placement half); a drifted .yaml fails CI here.
Describe 'Repository pipeline formatting integrity' -Tag 'L2', 'integrity' {
    It 'the real repository pipeline YAML is already Prettier-formatted (default **/*.yaml scope)' {
        if (-not (Get-Command prettier -ErrorAction Ignore)) {
            Set-ItResult -Skipped -Because 'tool_prettier_missing'
            return
        }
        $result = Format-Pipelines -Check -PassThru
        $result.ChangedCount | Should -Be 0 -Because "run Format-Pipelines to fix: $($result.ChangedFiles -join ', ')"
    }
}
