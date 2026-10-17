<#
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.QualityGates/Build-TerminologyDictionary.ps1
    name: build-terminology-dictionary
    filetype: ps1
    kind: function
    subkind: writer
    language: powershell
    track: automation
    tracktype: modules
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
    visibility: public
  edges:
    page: docs/references/automation/catzc-base-qualitygates/Build-TerminologyDictionary.ps1.md
    test: automation/Catzc.Base.QualityGates/tests/Build-TerminologyDictionary.Tests.ps1
    cites:
      - ADR-AUTO-DRYRUN
      - ADR-AUTO-SPELL
      - ADR-REPO-OUTDIR#8
  config:
    synopsis: |-
      Generates the per-category spell-checker dictionaries from the terminology registry — the writer half of
      Test-Terminology.
    description: |-
      Reads the approved-vocabulary registry (configs/terminology.yml, via Get-Config -Config terminology)
      and writes one plain cspell word list per category
      ([ADR-AUTO-SPELL#6](/docs/adr/automation/spell-out-names.md#rule-adr-auto-spell6)) to the repository
      root's .cspell/<category>.txt
      — one file per category defined in the registry (see .cspell/README.md) — the lists cspell.yml references
      as separate dictionaries. Each carries the generated-file head as a comment (cspell treats
      '#' lines as comments) naming its generator and source. Each list is lower-cased, de-duplicated, and ordinal-sorted, so the
      output is deterministic — the same registry always produces byte-identical bytes. The category set is the
      registry's own `categories` map, and every category's file is always emitted, so the generated file set —
      and cspell.yml — stay stable.

      terminology.yml is the single source of truth; these lists are generated, never hand-edited. Like the
      .psd1 manifests they are gitignored and regenerated at the importer tail (see importer.ps1), so cspell
      resolves them at fixed paths without a committed second copy of the vocabulary
      ([ADR-REPO-OUTDIR#8](/docs/adr/repository/dedicated-output-directory.md#rule-adr-repo-outdir8)).

      See [ADR-AUTO-SPELL](/docs/adr/automation/spell-out-names.md)
      ([ADR-AUTO-SPELL#5](/docs/adr/automation/spell-out-names.md#rule-adr-auto-spell5),
      [ADR-AUTO-SPELL#6](/docs/adr/automation/spell-out-names.md#rule-adr-auto-spell6)) and
      [ADR-REPO-OUTDIR#8](/docs/adr/repository/dedicated-output-directory.md#rule-adr-repo-outdir8).
    parameters:
      DryRun: |-
        Report whether any generated list would change without writing the files. The returned content is the
        same in either mode; -DryRun simply skips the write. See
        [ADR-AUTO-DRYRUN](/docs/adr/automation/dry-run.md).
      Silent: |-
        The per-category status lines are verbose-level — shown only when this function is run with -Verbose.
        -Silent suppresses them entirely, even under -Verbose (used by the importer tail so a session with
        -Verbose on does not chatter during import).
      PassThru: |-
        Return one result object per category ({ Category, Path, WordCount, Changed, DryRun }) instead of the
        path strings.
    outputs: |-
      [string[]] The paths to the generated dictionaries (with -PassThru, one result object per category
      instead).
    examples:
      - |-
        Build-TerminologyDictionary
        Regenerates the per-category dictionaries from the registry.
      - |-
        Build-TerminologyDictionary -DryRun -PassThru
        Reports whether any checked-in list is stale without writing it.
---
#>

function Build-TerminologyDictionary {
    [CmdletBinding()]
    [OutputType([string[]])]
    param(
        [switch] $DryRun,

        [switch] $Silent,

        [switch] $PassThru
    )

    $cspellDir = Join-Path (Get-RepositoryRoot) '.cspell'

    # The registry and this file are the whole input: when every list already carries their stamp, nothing is parsed or written.
    $inputsSha = Get-InputStamp -Path (
        (Resolve-RepoPath 'automation/Catzc.Base.QualityGates/configs/terminology.yml'),
        (Resolve-RepoPath 'automation/Catzc.Base.QualityGates/Build-TerminologyDictionary.ps1')
    )
    if (-not $PassThru -and (Test-Path -LiteralPath $cspellDir)) {
        $lists = @(Get-ChildPath $cspellDir -Depth 1 -File -Filter '*.txt')
        if ($lists.Count -gt 0 -and -not @($lists | Where-Object { -not (Test-GeneratedFileCurrent -Path $_ -InputsSha $inputsSha) })) {
            return [string[]] $lists
        }
    }

    $config = Get-Config -Config terminology

    $categories = @($config.categories)

    # The per-file status lines are verbose-level detail — shown only when this function is run with -Verbose.
    $emitVerbose = $VerbosePreference -ne [System.Management.Automation.ActionPreference]::SilentlyContinue

    if (-not $DryRun) {
        [void][System.IO.Directory]::CreateDirectory($cspellDir)
    }

    $ret = foreach ($category in $categories) {
        $words = [string[]] @(
            $config.terms |
                Where-Object { $_.category -eq $category } |
                ForEach-Object { $_.term.ToLowerInvariant() } |
                Select-Object -Unique
        )
        [System.Array]::Sort($words, [System.StringComparer]::Ordinal)

        $text = if ($words.Count -gt 0) {
            ($words -join "`n") + "`n"
        }
        else {
            ''
        }
        $content = Format-GeneratedFileHead -Text $text -Path ".cspell/$category.txt" -Carrier word-list -Generator Build-TerminologyDictionary -Source 'automation/Catzc.Base.QualityGates/configs/terminology.yml' -FileKind (Get-FileKind ".cspell/$category.txt") -InputsSha $inputsSha

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
