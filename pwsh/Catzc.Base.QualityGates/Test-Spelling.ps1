<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.QualityGates/Test-Spelling.ps1
    name: test-spelling
    filetype: ps1
    role: function
    subkind: gate
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: pwsh/Catzc.Base.QualityGates/tests/Test-Spelling.Tests.ps1
    docs: "[Test-Spelling.ps1.md](docs/references/pwsh/catzc-base-qualitygates/Test-Spelling.ps1.md)"
    cites:
      - ADR-AUTO-CONSOLE-SELFCONTAINEDERRORS
      - ADR-AUTO-TEST-QUALITYGATE
      - ADR-REPO-README-AUTHOREDSOURCES
---
#>

function Test-Spelling {
    [CmdletBinding()]
    [OutputType([Catzc.Base.Reports.QualityGateResult])]
    param(
        [string[]] $Path = @(
            '**/*.md'
            '**/*.ps1'
            '**/*.psm1'
            '**/*.psd1'
            '**/*.yml'
            '**/*.yaml'
            '**/*.json'
            '**/*.cs'
            '**/*.csproj'
            '**/*.bicep'
            '**/*.go'
            '**/*.py'
        ),

        [string[]] $Exclude = @(
            'out/**'
            'docs/notes/**'
            '.unordered/**'
            "$(Get-TrackPlace -Track infrastructure -TrackKind configs)/**"
            '**/README.md'
            'docs/adr/index.md'
            'docs/adr/glossary.md'
        ),

        [string] $OutputFolder,

        [switch] $PassThru
    )

    $root = Get-RepositoryRoot
    $configPath = Join-Path $root 'cspell.yml'
    Assert-PathExist $configPath

    if (-not (Test-Command 'cspell')) {
        throw (
            'cspell is not installed. Install it with:  Install-Cspell   (or: npm install -g cspell), ' +
            'then re-run Test-Spelling.'
        )
    }

    $excludeArgs = foreach ($e in $Exclude) {
        "--exclude '$e'"
    }

    # Batches keep each command line short: one call with hundreds of paths overflows the OS command-line limit.
    $batchSize = 50
    $exitCode = 0
    $outputs = [System.Collections.Generic.List[string]]::new()
    for ($start = 0; $start -lt $Path.Count; $start += $batchSize) {
        $batch = @($Path[$start..([Math]::Min($start + $batchSize, $Path.Count) - 1)])
        $quotedPaths = foreach ($p in $batch) {
            "'$p'"
        }
        $command = (
            "cspell lint $($quotedPaths -join ' ') $($excludeArgs -join ' ') " +
            "--config '$configPath' --no-progress --no-color --relative"
        )

        # -Silent: capture cspell's output instead of streaming it to the console; the report prints the issues.
        $result = Invoke-Executable $command -PassThru -NoAssert -Silent

        # cspell exit codes: 0 = clean, 1 = spelling issues found, >1 = tool error.
        if ($result.ExitCode -gt 1) {
            throw "cspell failed (exit $($result.ExitCode)): $($result.Full)"
        }

        $checkedMatch = [regex]::Match($result.Full, 'Files checked:\s*(?<n>\d+)')
        if ($result.ExitCode -ne 0 -and $checkedMatch.Success -and [int]$checkedMatch.Groups['n'].Value -eq 0) {
            throw "Test-Spelling matched no files for the given paths: $($batch -join ', ')."
        }
        $exitCode = [Math]::Max($exitCode, $result.ExitCode)
        $outputs.Add($result.Full)
    }
    $full = $outputs -join "`n"

    $issues = @($full -split '\r?\n' | Where-Object { $_ -match ':\d+:\d+ - ' })
    if ($exitCode -ne 0 -and $issues.Count -eq 0) {
        # A failing exit with no parsable issue line: the wording changed — report the raw output, never pass.
        $issues = @("cspell exited $exitCode with no parsable issue line: $full")
    }
    $fileCount = @($issues | ForEach-Object { ($_ -split ':')[0] } | Select-Object -Unique).Count

    $facts = [ordered]@{
        FileCount = $fileCount
        ExitCode  = $exitCode
    }
    Write-QualityGateReport -Subject spelling -Title Test-Spelling -Issues $issues -Facts $facts `
        -OutputFolder $OutputFolder -PassThru:$PassThru
}
