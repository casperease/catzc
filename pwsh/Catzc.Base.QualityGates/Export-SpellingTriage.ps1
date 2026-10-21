<#
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.QualityGates/Export-SpellingTriage.ps1
    name: export-spelling-triage
    filetype: ps1
    role: function
    language: powershell
    track: pwsh
    tracktype: modules
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    test: pwsh/Catzc.Base.QualityGates/tests/Export-SpellingTriage.Tests.ps1
    docs: "[Export-SpellingTriage.ps1.md](docs/references/pwsh/catzc-base-qualitygates/Export-SpellingTriage.ps1.md)"
    cites:
      - ADR-AUTO-DRYRUN
      - ADR-AUTO-SPELL-ONEVOCABULARYSOURCE
      - ADR-AUTO-SPELL-CATEGORYANDMEANING
      - ADR-AUTO-SPELL-FLAGGEDTOKENREVIEWED
---
#>

function Export-SpellingTriage {
    [CmdletBinding()]
    [OutputType([string[]])]
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
        ),

        [switch] $DryRun
    )

    $root = Get-RepositoryRoot
    $configPath = Join-Path $root 'cspell.yml'
    Assert-PathExist $configPath

    if (-not (Test-Command 'cspell')) {
        throw (
            'cspell is not installed. Install it with:  Install-Cspell   (or: npm install -g cspell), ' +
            'then re-run Export-SpellingTriage.'
        )
    }

    $quotedPaths = foreach ($p in $Path) {
        "'$p'"
    }
    $excludeArgs = foreach ($e in $Exclude) {
        "--exclude '$e'"
    }
    $command = (
        "cspell lint $($quotedPaths -join ' ') $($excludeArgs -join ' ') " +
        "--config '$configPath' --words-only --unique --no-summary --no-progress --no-color"
    )

    $result = Invoke-Executable $command -PassThru -NoAssert -Silent
    if ($result.ExitCode -gt 1) {
        throw "cspell failed (exit $($result.ExitCode)): $($result.Full)"
    }

    # A flagged-token line is a single bare token; lower-case it and drop blanks and any stray spaced lines.
    $flagged = @(
        $result.Full -split '\r?\n' |
            ForEach-Object { $_.Trim() } |
            Where-Object { $_ -and $_ -notmatch '\s' } |
            ForEach-Object { $_.ToLowerInvariant() }
    )

    # Skip tokens already in the registry (defensive — cspell accepts those, so they should not be flagged).
    $known = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
    foreach ($term in (Get-Config -Config terminology).terms) {
        [void] $known.Add($term.term)
    }

    $ret = [string[]] @($flagged | Where-Object { -not $known.Contains($_) } | Select-Object -Unique)
    [System.Array]::Sort($ret, [System.StringComparer]::Ordinal)

    $queuePath = Join-Path (Get-OutputRoot -EnsureExists) 'terminology-triage.yml'

    if ($ret.Count -eq 0) {
        Write-Message 'No flagged tokens to triage — every scanned token is already accepted vocabulary.'
        return [string[]] @()
    }

    foreach ($token in $ret) {
        $verb = if ($DryRun) {
            'would queue'
        }
        else {
            'queued'
        }
        Write-Message "${verb}: $token"
    }

    if (-not $DryRun) {
        $lines = [System.Collections.Generic.List[string]]::new()
        $lines.Add('# Terminology triage queue — spell-checker-flagged tokens awaiting classification.')
        $lines.Add('#')
        $lines.Add('# Move each entry into the terminology registry')
        $lines.Add('# (Catzc.Base.QualityGates configs/terminology.yml): add it under its category group')
        $lines.Add('# in the terms: map (pick a category from categories:; an abbreviation also needs expands_to), OR')
        $lines.Add('# spell the token out in the code. Nothing here is accepted until promoted (ADR-AUTO-SPELL-FLAGGEDTOKENREVIEWED). This file')
        $lines.Add('# is gitignored output — cspell never reads it.')
        foreach ($token in $ret) {
            $lines.Add("- term: $token")
            $lines.Add("  meaning: ''       # TODO: one line — what it is and why it is legitimate vocabulary")
        }
        $utf8NoBom = [System.Text.UTF8Encoding]::new($false)
        [System.IO.File]::WriteAllText($queuePath, (($lines -join "`n") + "`n"), $utf8NoBom)
    }

    $summaryVerb = if ($DryRun) {
        'would be queued'
    }
    else {
        "queued in $queuePath"
    }
    Write-Message "Done. $($ret.Count) flagged token(s) $summaryVerb — classify into terminology.yml or spell out."

    [string[]] $ret
}
