<#
.SYNOPSIS
    Generates the per-category spell-checker dictionaries from the terminology registry — the writer half of
    the terminology gate.
.DESCRIPTION
    Reads the approved-vocabulary registry (configs/terminology.yml, via Get-Config -Config terminology)
    and writes one plain cspell word list per category (ADR-AUTO-SPELL:6) to the repository root's .cspell/<category>.txt
    — one file per category defined in the registry (see .cspell/README.md) — the lists cspell.yml references
    as separate dictionaries. Each carries a generated-file header comment (cspell treats
    '#' lines as comments) naming its source. Each list is lower-cased, de-duplicated, and ordinal-sorted, so the
    output is deterministic — the same registry always produces byte-identical bytes. The category set is the
    registry's own `categories` map, and every category's file is always emitted, so the generated file set —
    and cspell.yml — stay stable.

    terminology.yml is the single source of truth; these lists are generated, never hand-edited. Like the
    .psd1 manifests they are gitignored and regenerated at the importer tail (see importer.ps1), so cspell
    resolves them at fixed paths without a committed second copy of the vocabulary (ADR-REPO-OUTDIR:8).

    See docs/adr/automation/spell-out-names.md (ADR-AUTO-SPELL:5, ADR-AUTO-SPELL:6) and
    docs/adr/repository/dedicated-output-directory.md (ADR-REPO-OUTDIR:8).
.PARAMETER DryRun
    Report whether any generated list would change without writing the files. The returned content is the
    same in either mode; -DryRun simply skips the write. See
    docs/adr/automation/prefer-dryrun-over-shouldprocess.md.
.PARAMETER Silent
    The per-category status lines are verbose-level — shown only when this function is run with -Verbose.
    -Silent suppresses them entirely, even under -Verbose (used by the importer tail so a session with
    -Verbose on does not chatter during import).
.PARAMETER PassThru
    Return one result object per category ({ Category, Path, WordCount, Changed, DryRun }) instead of the
    path strings.
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

    # One dictionary per category (ADR-AUTO-SPELL:6): each category's terms generate their own cspell word list, so
    # cspell.yml can reference — and scope — them independently. The category set is the registry's own
    # 'categories' map (the single source, validated by TerminologyConfig); every category's file is always
    # emitted (even when it has no terms) so the generated file set stays stable.
    $categories = @($config.categories)

    # The per-file status lines are verbose-level detail — shown only when this function is run with -Verbose.
    $emitVerbose = $VerbosePreference -ne [System.Management.Automation.ActionPreference]::SilentlyContinue

    # The generated dictionaries live at the repository root's .cspell/<category>.txt (see .cspell/README.md).
    # They are gitignored, so a fresh clone or a deleted .cspell/ has none; [System.IO.File]::WriteAllText does
    # not create the directory, so self-heal it before writing.
    $cspellDir = Join-Path (Get-RepositoryRoot) '.cspell'
    if (-not $DryRun) {
        [void][System.IO.Directory]::CreateDirectory($cspellDir)
    }

    $ret = foreach ($category in $categories) {
        # The accepted tokens are the terms themselves (an abbreviation's expansion is a real word cspell
        # already knows, so it is not registered). Lower-case, de-duplicate, and ordinal-sort per category
        # for a deterministic list.
        $words = [string[]] @(
            $config.terms |
                Where-Object { $_.category -eq $category } |
                ForEach-Object { $_.term.ToLowerInvariant() } |
                Select-Object -Unique
        )
        [System.Array]::Sort($words, [System.StringComparer]::Ordinal)

        # A generated-file header (cspell treats '#' lines as comments) names the single source and how the
        # file exists — mirrored by .cspell/README.md. It is part of the content, so it is drift-compared too.
        $header = @(
            "# GENERATED cspell dictionary for the '$category' vocabulary category — do not edit."
            '# Single source of truth: automation/Catzc.Base.QualityGates/configs/terminology.yml'
            '# Regenerated on import by Build-TerminologyDictionary; gitignored. See .cspell/README.md.'
            ''
        )
        $content = (($header + $words) -join "`n") + "`n"

        # Gitignored, generated artifact at the repository root's .cspell/ (ADR-REPO-OUTDIR:8), at the fixed path
        # cspell.yml references.
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
