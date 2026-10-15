<#
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/Build-TerminologyDictionary.ps1
    kind: function
    module: Catzc.Base.QualityGates
    visibility: public
---
#>

<#
.SYNOPSIS
    Generates the per-category spell-checker dictionaries from the terminology registry — the writer half of
    Test-Terminology.
.DESCRIPTION
    The lists are gitignored and regenerated at import, so the registry stays the only copy of the vocabulary.
    [ADR-AUTO-SPELL](/docs/adr/automation/spell-out-names.md),
    [ADR-AUTO-SPELL#5](/docs/adr/automation/spell-out-names.md#rule-adr-auto-spell5),
    [ADR-AUTO-SPELL#6](/docs/adr/automation/spell-out-names.md#rule-adr-auto-spell6),
    [ADR-REPO-OUTDIR#8](/docs/adr/repository/dedicated-output-directory.md#rule-adr-repo-outdir8)
    [comment:1](/docs/references/automation/catzc-base-qualitygates/Build-TerminologyDictionary.ps1.md#comment1)
.PARAMETER DryRun
    The returned content is the same in either mode; -DryRun only skips the write.
    [ADR-AUTO-DRYRUN](/docs/adr/automation/dry-run.md)
    [comment:2](/docs/references/automation/catzc-base-qualitygates/Build-TerminologyDictionary.ps1.md#comment2)
.PARAMETER Silent
    Wins over -Verbose, so the importer tail stays quiet even in a session that has -Verbose on.
    [comment:3](/docs/references/automation/catzc-base-qualitygates/Build-TerminologyDictionary.ps1.md#comment3)
.PARAMETER PassThru
    Changed tells which lists differ from disk, which makes this the way to read a -DryRun outcome.
    [comment:4](/docs/references/automation/catzc-base-qualitygates/Build-TerminologyDictionary.ps1.md#comment4)
.OUTPUTS
    [string[]] The paths to the generated dictionaries (with -PassThru, one result object per category
    instead).
.EXAMPLE
    Build-TerminologyDictionary
    Regenerates the per-category dictionaries from the registry.
.EXAMPLE
    Build-TerminologyDictionary -DryRun -PassThru
    Reports whether any checked-in list is stale without writing it.
#>
function Build-TerminologyDictionary {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [switch] $DryRun,

        [switch] $Silent,

        [switch] $PassThru
    )

    $config = Get-Config -Config terminology

    # Every category always gets its file, even with no terms, so the generated file set and cspell.yml stay stable.
    # [ADR-AUTO-SPELL#6](/docs/adr/automation/spell-out-names.md#rule-adr-auto-spell6)
    # [comment:5](/docs/references/automation/catzc-base-qualitygates/Build-TerminologyDictionary.ps1.md#comment5)
    $categories = @($config.categories)

    # The per-file status lines are verbose-level detail — shown only when this function is run with -Verbose.
    $emitVerbose = $VerbosePreference -ne [System.Management.Automation.ActionPreference]::SilentlyContinue

    # The folder is gitignored, so a fresh clone lacks it and WriteAllText would not create it: self-heal first.
    # [comment:6](/docs/references/automation/catzc-base-qualitygates/Build-TerminologyDictionary.ps1.md#comment6)
    $cspellDir = Join-Path (Get-RepositoryRoot) '.cspell'
    if (-not $DryRun) {
        [void][System.IO.Directory]::CreateDirectory($cspellDir)
    }

    $ret = foreach ($category in $categories) {
        # An abbreviation's expansion is a real word cspell knows, so only the terms themselves are registered.
        # [comment:7](/docs/references/automation/catzc-base-qualitygates/Build-TerminologyDictionary.ps1.md#comment7)
        $words = [string[]] @(
            $config.terms |
                Where-Object { $_.category -eq $category } |
                ForEach-Object { $_.term.ToLowerInvariant() } |
                Select-Object -Unique
        )
        [System.Array]::Sort($words, [System.StringComparer]::Ordinal)

        # The header is part of the content, so the drift comparison covers it as well.
        # [comment:8](/docs/references/automation/catzc-base-qualitygates/Build-TerminologyDictionary.ps1.md#comment8)
        $header = @(
            "# GENERATED cspell dictionary for the '$category' vocabulary category — do not edit."
            '# Single source of truth: automation/Catzc.Base.QualityGates/configs/terminology.yml'
            '# Regenerated on import by Build-TerminologyDictionary; gitignored. See .cspell/README.md.'
            ''
        )
        $content = (($header + $words) -join "`n") + "`n"

        # The path is fixed because cspell.yml references it, so there is no committed second copy.
        # [ADR-REPO-OUTDIR#8](/docs/adr/repository/dedicated-output-directory.md#rule-adr-repo-outdir8)
        # [comment:9](/docs/references/automation/catzc-base-qualitygates/Build-TerminologyDictionary.ps1.md#comment9)
        $dictPath = Join-Path $cspellDir "$category.txt"

        $existing = if (Test-Path $dictPath) {
            [System.IO.File]::ReadAllText($dictPath)
        }
        else {
            $null
        }
        $changed = $content -cne $existing

        if (-not $DryRun -and $changed) {
            $utf8NoBom = [System.Text.UTF8Encoding]::new($false)
            [System.IO.File]::WriteAllText($dictPath, $content, $utf8NoBom)
        }

        $verb = if ($DryRun) {
            if ($changed) {
                'would regenerate'
            }
            else {
                'already current'
            }
        }
        else {
            if ($changed) {
                'regenerated'
            }
            else {
                'unchanged'
            }
        }
        if (-not $Silent) {
            Write-Message ".cspell/$category.txt $verb — $($words.Count) term(s)." -Verbose:$emitVerbose
        }

        [pscustomobject]@{
            Category  = $category
            Path      = $dictPath
            WordCount = $words.Count
            Changed   = [bool] $changed
            DryRun    = [bool] $DryRun
        }
    }
    $ret = @($ret)

    if ($PassThru) {
        return $ret
    }

    [string[]] @($ret.Path)
}
