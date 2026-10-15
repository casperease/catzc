<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/Export-SpellingTriage.ps1
    kind: function
    module: Catzc.Base.QualityGates
    visibility: public
    adrs:
      - ADR-AUTO-DRYRUN
      - ADR-AUTO-SPELL#5
      - ADR-AUTO-SPELL#6
      - ADR-AUTO-SPELL#7
---
#>

<#
.SYNOPSIS
    Collects the spell-checker's flagged tokens into a triage queue for classification — the on-ramp to the
    terminology registry, never an automatic acceptance.
.DESCRIPTION
    The queue is a to-do list: cspell never reads it, so a token stays flagged until a human promotes it.
    [comment:1](/docs/references/automation/catzc-base-qualitygates/Export-SpellingTriage.ps1.md#comment1)
.PARAMETER Path
    The default scope equals Test-Spelling's, though cspell still applies the ignorePaths from cspell.yml.
    [comment:2](/docs/references/automation/catzc-base-qualitygates/Export-SpellingTriage.ps1.md#comment2)
.PARAMETER Exclude
    The defaults match Test-Spelling, so the tokens queued are exactly the tokens the gate flags.
    [comment:3](/docs/references/automation/catzc-base-qualitygates/Export-SpellingTriage.ps1.md#comment3)
    Third-party noise belongs in the cspell.yml ignorePaths, not in this list.
    [comment:5](/docs/references/automation/catzc-base-qualitygates/Export-SpellingTriage.ps1.md#comment5)
.PARAMETER DryRun
    The returned list is the same in either mode; -DryRun only skips the write.
    [comment:4](/docs/references/automation/catzc-base-qualitygates/Export-SpellingTriage.ps1.md#comment4)
.OUTPUTS
    [string[]] The flagged tokens queued for triage (or, under -DryRun, that would be queued), ordinal-sorted.
.EXAMPLE
    Export-SpellingTriage
    Writes every currently-flagged token to the triage queue for classification.
.EXAMPLE
    Export-SpellingTriage -DryRun
    Returns which tokens would be queued without writing the file.
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
            '**/*.bicep'
            '**/*.go'
            '**/*.py'
        ),

        [string[]] $Exclude = @(
            'out/**'
            'docs/notes/**'
            '.unordered/**'
            'infrastructure/templates/**/configuration/**'
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
    # --no-summary keeps the trailing issue-count line out of the stream, which is parsed as bare tokens.
    # [comment:6](/docs/references/automation/catzc-base-qualitygates/Export-SpellingTriage.ps1.md#comment6)
    $command = (
        "cspell lint $($quotedPaths -join ' ') $($excludeArgs -join ' ') " +
        "--config '$configPath' --words-only --unique --no-summary --no-progress --no-color"
    )

    # Exit 1 means tokens were flagged, which is the expected case; only an exit above 1 is a tool error.
    # [comment:7](/docs/references/automation/catzc-base-qualitygates/Export-SpellingTriage.ps1.md#comment7)
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
        # The blank meaning is deliberate: a pasted stub fails Test-Terminology until a human classifies it.
        # [comment:8](/docs/references/automation/catzc-base-qualitygates/Export-SpellingTriage.ps1.md#comment8)
        $lines = [System.Collections.Generic.List[string]]::new()
        $lines.Add('# Terminology triage queue — spell-checker-flagged tokens awaiting classification.')
        $lines.Add('#')
        $lines.Add('# Move each entry into the terminology registry')
        $lines.Add('# (automation/Catzc.Base.QualityGates/configs/terminology.yml): add it under its category group')
        $lines.Add('# in the terms: map (pick a category from categories:; an abbreviation also needs expands_to), OR')
        $lines.Add('# spell the token out in the code. Nothing here is accepted until promoted (ADR-AUTO-SPELL#7). This file')
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
