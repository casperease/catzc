<#
.SYNOPSIS
    Generates docs/adr/index.md — the ADR code -> rule-citation registry — from adrs.yml, the single source
    of truth for the ADR domain structure.
.DESCRIPTION
    index.md is a derived projection of automation/Catzc.Base.Docs/configs/adrs.yml: authored preamble and
    authoring-convention prose wrapped around one code-registry table per domain (in declared order). Every
    ADR row is `| ``<external>`` | [<slug>](<path>) |` — the format Get-CatsAdrIndex parses and the citation
    grammar Show-Cats presents. Each link path is resolved to the real docs/adr/<domain>/**/<slug>.md file.

    The index is gitignored and reproduced on every import (before Build-Readme, whose docs/adr/README.md link
    points at it), so adrs.yml is the ONLY place the registry is edited — a hand-edit to index.md is overwritten
    on the next load. See docs/adr/repository/generated-readmes.md for the generated-file pattern.

    Idempotent and fast: the write goes through Write-FileIfChanged (canonical output, EOL-insensitive compare,
    write only on drift), so a clean tree costs one file read.
.PARAMETER DryRun
    Report whether index.md would change without writing it. See
    docs/adr/automation/powershell/prefer-dryrun-over-shouldprocess.md.
.PARAMETER Silent
    The wrote / would-write status line is verbose-level — -Silent suppresses it (used by the importer tail).
.PARAMETER PassThru
    Return a result object ({ Path; Changed; DryRun }) instead of the repo-relative path.
.OUTPUTS
    [string] The repo-relative path of the generated index (with -PassThru, the result object instead).
.EXAMPLE
    Build-AdrIndex
    Regenerates docs/adr/index.md from adrs.yml.
.EXAMPLE
    Build-AdrIndex -DryRun -PassThru
    Reports whether the on-disk index is stale without writing it.
#>
function Build-AdrIndex {
    [CmdletBinding()]
    [OutputType([string])]
    param(
        [switch] $DryRun,

        [switch] $Silent,

        [switch] $PassThru
    )

    $preamble = @'
# ADR index and rule-citation registry

Architecture Decision Records live under `docs/adr/`, grouped by domain — the sections below mirror the domains
declared in `automation/Catzc.Base.Docs/configs/adrs.yml`, from which this file is generated. **Read all ADRs at
the start of every session** — they define the design principles this codebase must follow.

## Citing a rule

Every ADR carries a numbered rule registry as its first content section: `## Rules: <code>`, followed by
`### Rule <code>:<n>` entries (each a normative summary plus internal links to the prose that justifies it).

- Every `<code>` has the form `ADR-<NAME>` — a literal `ADR-` prefix plus one or more uppercase segments — so
  `ADR-` is the single searchable marker for a rule reference anywhere in the repository.
- **Cite a rule** as `<code>#<n>` — e.g. `ADR-AUTO-ERROR#3`, `ADR-AUTO-CACHE#5`, `ADR-AZ-NAMING#7`.
- That resolves to the anchor `#rule-<code><n>` with the code lowercased and the `:` dropped — e.g.
  `automation/powershell/error-handling.md#rule-adr-auto-error3` (so it is `rule-adr-auto-error3`, not
  `rule-adr-auto-error-3`).
- The `<code>` is unique per ADR; the tables below are the authoritative code ↔ ADR mapping.

## Codes
'@

    $conventions = @'
## Authoring conventions

These apply when writing or editing any ADR (and largely any doc under `docs/`):

- **Decision and rationale, not config values.** An ADR owns the decision and the _why_; the root config files own the concrete rule values
  (`.editorconfig`, `PSScriptAnalyzerSettings.psd1`, `.markdownlint.yml`, `.gitattributes`, `automation/.scriptanalyzer/*.psm1`). Name the
  enforcing file as a pointer, but do not reproduce value tables, pasted `@{ }` rule blocks, or per-rule on/off lists — that duplication
  drifts. Naming a value in order to justify it (for example, "UTF-8, because a BOM breaks `git diff`") is fine; a bare value list with no
  rationale is not.

- **References point one way: code to ADR.** Code, function help, sample headers, and READMEs cite the relevant ADR; an ADR never links back
  to sample or example code, because that couples durable rationale to code churn. The "How this is enforced" sections that _name_ an
  enforcing function are the established exception.

- **Link granularity is per-context.** Cite a specific rule anchor (`file.md#rule-<code><n>`, e.g.
  `azure-data-model.md#rule-adr-az-datamod2`) when the citing sentence, comment, or throw-message invokes one concrete rule. Link the ADR
  document when the context is general — an index list, a "see ADR X for the full rationale" pointer, or a citation that invokes the ADR's
  whole thesis. Over-narrowing a general pointer to one rule is worse than leaving it doc-level.

- **Plain language.** Write in plain English; avoid terse logic or math jargon. Never use "iff" — spell out both directions ("required when
  Y; an error otherwise", or "present exactly when Y"). Prefer "when" / "only when" / "exactly when".

- **Present tense, not a changelog.** An ADR describes the _current_ design as if it had always been that way. It never records what the
  code used to do, what was removed/renamed/migrated, that a decision is recent, or which past incident motivated a rule — that history
  lives in git, not here. Drop change/time markers ("now", "no longer", "previously", "originally", "we used to", "this ADR replaces/moves",
  "still", "today", "already") and war-stories ("we learned this the hard way", "has cost us a red suite"). Argue against a rejected
  alternative in the present ("a global `Set-Location` is unsafe"), not as a journey ("what we tried"); state a rule and its present-tense
  rationale, never the path that led to it.

- **Blank-line padding.** Pad every section: a blank line immediately after each `##`/`###` heading, and a blank line before the next
  heading. This applies to the `## Rules: <code>` registries and the `### Rule <code>:<n>` entries as well.

- **`dora-explains.md` collects each domain's DORA rationale.** An individual ADR carries no `## Dora explains` section; instead every
  domain folder keeps a `dora-explains.md` that consolidates, one entry per ADR, the short present-tense paragraph tying that ADR's topic to
  [DORA](https://dora.dev/research/) research and its 2–4 domain-relevant capability links (each `[Capability](https://dora.dev/capabilities/<slug>/) — why it is relevant`,
  plus the research-overview link). DORA is the repository's cross-cutting authoritative source on delivery performance; link only the
  capabilities that genuinely bear on an ADR's domain, never the whole catalog. The `research/` domain is the exception — its ADRs are the
  DORA capability records themselves, so it has no `dora-explains.md`.
'@

    $adrs = Get-Config -Config adrs
    $adrDocsRoot = Resolve-RepoPath 'docs/adr'
    Assert-PathExist $adrDocsRoot

    # Map "<domainFolder>/<slug>" -> the ADR file path relative to docs/adr (forward-slashed), so a ruleset
    # in a subfolder (automation/powershell/, automation/BCL/) still resolves to its real link target. The
    # generated index.md and every folder README are skipped — they are not ADRs.
    $pathBySlugKey = @{}
    foreach ($file in [System.IO.Directory]::EnumerateFiles($adrDocsRoot, '*.md', [System.IO.SearchOption]::AllDirectories)) {
        $relative = ($file.Substring($adrDocsRoot.Length).TrimStart('\', '/')) -replace '\\', '/'
        $slug = [System.IO.Path]::GetFileNameWithoutExtension($file)
        if ($slug -in 'index', 'README') {
            continue
        }
        $topFolder = ($relative -split '/')[0]
        $pathBySlugKey["$topFolder/$slug"] = $relative
    }

    # One aligned code-registry table per domain, in declared order. Rows carry the backtick-wrapped external
    # code and the slug link in the exact shape Get-CatsAdrIndex parses.
    $sections = foreach ($domain in $adrs.Domains) {
        $rows = foreach ($ruleSet in $domain.RuleSets) {
            $key = "$($domain.Name)/$($ruleSet.Slug)"
            $path = $pathBySlugKey[$key]
            if (-not $path) {
                throw "Build-AdrIndex: no ADR file docs/adr/$($domain.Name)/**/$($ruleSet.Slug).md for $($ruleSet.External)"
            }
            [pscustomobject]@{
                Code = '`' + $ruleSet.External + '`'
                Adr  = "[$($ruleSet.Slug)]($path)"
            }
        }

        $codeWidth = [System.Math]::Max(4, (@($rows.Code) | Measure-Object -Property Length -Maximum).Maximum)
        $adrWidth = [System.Math]::Max(3, (@($rows.Adr) | Measure-Object -Property Length -Maximum).Maximum)

        $lines = [System.Collections.Generic.List[string]]::new()
        $lines.Add("### $($domain.Name)/")
        $lines.Add('')
        $lines.Add("| $('Code'.PadRight($codeWidth)) | $('ADR'.PadRight($adrWidth)) |")
        $lines.Add("| $('-' * $codeWidth) | $('-' * $adrWidth) |")
        foreach ($row in $rows) {
            $lines.Add("| $($row.Code.PadRight($codeWidth)) | $($row.Adr.PadRight($adrWidth)) |")
        }
        $lines -join "`n"
    }

    $content = $preamble.TrimEnd() + "`n`n" + ($sections -join "`n`n") + "`n`n" + $conventions.TrimEnd() + "`n"

    $target = Resolve-RepoPath 'docs/adr/index.md'
    $changed = Write-FileIfChanged $target $content -DryRun:$DryRun

    $relativeTarget = ConvertTo-RepoRelativePath $target
    if ($changed -and -not $Silent) {
        $verb = if ($DryRun) {
            'would write'
        }
        else {
            'wrote'
        }
        Write-Message "$verb $relativeTarget"
    }

    if ($PassThru) {
        [pscustomobject]@{ Path = $relativeTarget; Changed = $changed; DryRun = [bool]$DryRun }
    }
    else {
        $relativeTarget
    }
}
