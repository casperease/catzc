<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/Export-SpellingTriage.ps1
    kind: function
    language: powershell
    filekind: ps1
    track: automation
    module: Catzc.Base.QualityGates
    visibility: public
    relatives:
      page: docs/references/automation/catzc-base-qualitygates/Export-SpellingTriage.ps1.md
      test: automation/Catzc.Base.QualityGates/tests/Export-SpellingTriage.Tests.ps1
    adrs:
      - ADR-AUTO-DRYRUN
      - ADR-AUTO-SPELL#{5-7}
  config:
    synopsis: |-
      Collects the spell-checker's flagged tokens into a triage queue for classification — the on-ramp to the
      terminology registry, never an automatic acceptance.
    description: |-
      Runs the same cspell scan as Test-Spelling with --words-only, collecting every token the gate flags, and
      writes them as UNCATEGORIZED STUBS to a triage queue under out/ (terminology-triage.yml). Nothing here is
      accepted vocabulary: a flagged token joins the dictionary only when a human moves it into the terminology
      registry (configs/terminology.yml) with a real meaning and category, or spells the token out in the code
      ([ADR-AUTO-SPELL#7](/docs/adr/automation/spell-out-names.md#rule-adr-auto-spell7)). The queue is a to-do
      list, not a dictionary — cspell
      never reads it, so a token sitting in the queue is still flagged until promoted. It changes no repository file,
      so it is an export, not a formatter. The accepted-word list is generated from the registry
      (Build-TerminologyDictionary) and is never appended to by a tool
      ([ADR-AUTO-SPELL#5](/docs/adr/automation/spell-out-names.md#rule-adr-auto-spell5)).

      Tokens already in the registry are skipped (cspell accepts them, so they are not flagged in the first
      place); only genuinely new, unaccepted tokens reach the queue.

      cspell must be on PATH — install it once with Install-Cspell (or: npm install -g cspell).
    parameters:
      Path: |-
        Repository-relative paths or globs to scan (cspell expands a glob). Defaults to the repository's known text file
        types — the same scope Test-Spelling checks. cspell still applies the ignorePaths from cspell.yml.
      Exclude: |-
        Globs to skip, passed to cspell as --exclude. Defaults to the authored/generated trees that are out of
        scope to spell-check, matching Test-Spelling so the tokens queued are exactly the tokens the gate flags.
        Mirror Test-Spelling's content-scope exclusions, so the tokens queued are exactly the tokens the
        gate flags. Third-party noise lives in cspell.yml ignorePaths, not here.
      DryRun: |-
        Report which tokens would be queued without writing the triage file. The returned list is the same in
        either mode; -DryRun simply skips the write. See
        [ADR-AUTO-DRYRUN](/docs/adr/automation/dry-run.md).
    outputs: '[string[]] The flagged tokens queued for triage (or, under -DryRun, that would be queued), ordinal-sorted.'
    examples:
      - |-
        Export-SpellingTriage
        Writes every currently-flagged token to the triage queue for classification.
      - |-
        Export-SpellingTriage -DryRun
        Returns which tokens would be queued without writing the file.
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
