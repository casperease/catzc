<#
.SYNOPSIS
    Gates the terminology registry: no drift, no orphans, no unjustified entries. Writes a report under out/.
.DESCRIPTION
    The read-only verifier over configs/terminology.yml and its generated dictionary — the counterpart to
    Build-TerminologyDictionary. It enforces the three things code review cannot mechanically catch
    (docs/adr/automation/spell-out-names.md, ADR-SPELL:5-ADR-SPELL:8):

      1. No drift — the generated per-category dictionaries (.cspell/<category>.txt) match what
         Build-TerminologyDictionary would produce from the registry (ADR-SPELL:5). They are gitignored and
         regenerated on import, so this catches a hand-edited word list.
      2. No orphans — every registry entry is referenced somewhere in the spell-scanned tree; an entry no
         code uses is dead vocabulary and must be removed (ADR-SPELL:8).
      3. No unjustified entry — every entry declares a category and a meaning, and every abbreviation carries
         its expansion (ADR-SPELL:6). This is enforced by the TerminologyConfig type at load, so a malformed
         registry fails to load and is reported here.

    Mirrors Test-Spelling's reporting: each run writes a timestamped folder under out/test-terminology/
    (terminology.md), updates latest.txt, and prints the report path. Throws when issues are found (so it can
    gate CI); -PassThru returns a result object instead.
.PARAMETER OutputFolder
    Base directory for the run report. Each run writes a timestamped subfolder
    (<OutputFolder>/yyyyMMdd-HHmmss/). Defaults to <out>/test-terminology.
.PARAMETER PassThru
    Return a result object ({ IssueCount, TermCount, Issues, ReportPath }) instead of throwing.
.OUTPUTS
    Throws on any issue; with -PassThru, returns the result object.
.EXAMPLE
    Test-Terminology
.EXAMPLE
    $result = Test-Terminology -PassThru; $result.IssueCount
#>
function Test-Terminology {
    [CmdletBinding()]
    param(
        [string] $OutputFolder,

        [switch] $PassThru
    )

    $root = Get-RepositoryRoot
    $registryPath = Join-Path $PSScriptRoot 'configs/terminology.yml'
    $issues = [System.Collections.Generic.List[string]]::new()

    # ---- Gate 3 (justification / no-coinage): loading validates every entry via TerminologyConfig ----
    # A missing category/meaning, an abbreviation without an expansion, or an unknown category throws here.
    $config = $null
    try {
        $config = Get-Config -Config terminology
    }
    catch {
        $issues.Add("registry does not validate (ADR-SPELL:6): $($_.Exception.Message)")
    }

    if ($config) {
        # ---- Gate 1 (no drift): every generated dictionary must match the registry (ADR-SPELL:5) ----
        $generated = Build-TerminologyDictionary -DryRun -PassThru
        foreach ($stale in @($generated | Where-Object Changed)) {
            $issues.Add(
                "dictionary drift (ADR-SPELL:5): .cspell/$($stale.Category).txt is out of date — " +
                'regenerate it with Build-TerminologyDictionary (or re-run the importer).'
            )
        }

        # ---- Gate 2 (no orphans): every term must be referenced somewhere else in the tree (ADR-SPELL:8) ----
        # One bulk scan of the spell-checked corpus (minus the registry and its generated lists, where every
        # term trivially appears), then look each term up against it — not one grep per term. The generated
        # per-category dictionaries live at the repository root's .cspell/ (see .cspell/README.md).
        $cspellDir = Join-Path $root '.cspell'
        $dictPaths = @($config.categories | ForEach-Object { Join-Path $cspellDir "$_.txt" })
        $corpus = Get-TerminologyCorpus -Root $root -Exclude (@($registryPath) + $dictPaths)
        foreach ($term in $config.terms) {
            if (-not $corpus.Contains($term.term.ToLowerInvariant())) {
                $issues.Add(
                    "orphan (ADR-SPELL:8): '$($term.term)' is not referenced anywhere in the tree — remove it " +
                    'from terminology.yml.'
                )
            }
        }
    }

    $termCount = if ($config) {
        $config.terms.Count
    }
    else {
        0
    }

    # ---- report (mirrors Test-Spelling): timestamped folder under out/test-terminology/ ----
    if (-not $OutputFolder) {
        $OutputFolder = Join-Path (Get-OutputRoot -EnsureExists) 'test-terminology'
    }
    $stamp = Get-Date -Format 'yyyyMMdd-HHmmss'
    $runDir = Join-Path $OutputFolder $stamp
    $i = 2
    while (Test-Path $runDir) {
        $runDir = Join-Path $OutputFolder "$stamp-$i"
        $i++
    }
    New-Item -ItemType Directory -Path $runDir -Force | Out-Null

    $lines = [System.Collections.Generic.List[string]]::new()
    $lines.Add('# Terminology report')
    $lines.Add('')
    $lines.Add("- Generated: $stamp")
    $lines.Add("- Terms: $termCount")
    if ($issues.Count -eq 0) {
        $lines.Add('- Result: no terminology issues')
    }
    else {
        $lines.Add("- Issues: $($issues.Count)")
        $lines.Add('')
        $lines.Add('## Issues')
        $lines.Add('')
        foreach ($issue in $issues) {
            $lines.Add("- $issue")
        }
    }
    Set-Content -Path (Join-Path $runDir 'terminology.md') -Value $lines -Encoding utf8
    Set-Content -Path (Join-Path $OutputFolder 'latest.txt') -Value (Split-Path $runDir -Leaf) -Encoding utf8

    if ($issues.Count -eq 0) {
        Write-Message "No terminology issues found across $termCount term(s)."
    }
    else {
        foreach ($issue in $issues) {
            Write-Message $issue -NoHeader
        }
        Write-Message "$($issues.Count) terminology issue(s)."
    }
    Write-Message "Terminology report: $runDir" -ForegroundColor Cyan -NoHeader

    if ($PassThru) {
        return [pscustomobject]@{
            IssueCount = $issues.Count
            TermCount  = $termCount
            Issues     = $issues.ToArray()
            ReportPath = $runDir
        }
    }

    if ($issues.Count -gt 0) {
        throw "Test-Terminology failed: $($issues.Count) issue(s) found — see $runDir"
    }
}
