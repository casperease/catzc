<#
.SYNOPSIS
    Generates [index](/docs/adr/index.md) — the ADR code -> rule-citation registry — from adrs.yml, the single source
    of truth for the ADR domain structure.
.DESCRIPTION
    index.md is a derived projection of automation/Catzc.Base.Docs/configs/adrs.yml: authored preamble and
    authoring-convention prose wrapped around one code-registry table per domain (in declared order). Every
    ADR row is `| ``<external>`` | [<slug>](<path>) |` — the format Get-CatsAdrIndex parses and the citation
    grammar Show-Cats presents. Each link path is resolved to the real docs/adr/<domain>/**/<slug>.md file.

    The index is committed — so GitHub has it, and every ADR citation's link resolves there — marked
    linguist-generated so its diff collapses, and reproduced on every import (before Build-Readme, which generates
    the docs/adr README from it), so adrs.yml is the ONLY place the registry is edited — a hand-edit to index.md is overwritten
    on the next load. See [ADR-REPO-README](/docs/adr/repository/generated-readmes.md) for the generated-file pattern.

    Idempotent and fast: the write goes through Write-FileIfChanged (canonical output, EOL-insensitive compare,
    write only on drift), so a clean tree costs one file read.
.PARAMETER DryRun
    Report whether index.md would change without writing it. See
    [ADR-AUTO-DRYRUN](/docs/adr/automation/dry-run.md).
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
declared in `automation/Catzc.Base.Docs/configs/adrs.yml`, from which this file is generated. The ADRs define the
design principles this codebase must follow. **Read this index at the start of every session**, then read in full the
ADRs that govern the files a task touches, and cite their rules by code.

## Citing a rule

Every ADR carries a numbered rule registry as its first content section: `## Rules: <code>`, followed by
`### Rule <code>:<n>` entries (each a normative summary plus internal links to the prose that justifies it).

- Every `<code>` has the form `ADR-<NAME>` — a literal `ADR-` prefix plus one or more uppercase segments — so
  `ADR-` is the single searchable marker for a rule reference anywhere in the repository.
- **Cite a rule** as `<code>#<n>` — e.g. `ADR-PWSH-ERROR#3`, `ADR-AUTO-CACHE#5`, `ADR-AZ-NAMING#7`.
- That resolves to the anchor `#rule-<code><n>` with the code lowercased and the `:` dropped — e.g.
  `pwsh/error-handling.md#rule-adr-pwsh-error3` (so it is `rule-adr-pwsh-error3`, not
  `rule-adr-pwsh-error-3`).
- The `<code>` is unique per ADR; the tables below are the authoritative code ↔ ADR mapping.
- `#` is the only citation spelling — in comments, test tags, configuration, and prose. The `:` form exists only in the rule's own
  `### Rule <code>:<n>` heading (ADR-REPO-LINK#5).
- A rule's number is stable: a retired rule's number is never reused, so a registry may skip numbers, and a citation never changes its
  meaning when a neighbouring rule goes.

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

- **Two kinds of link (ADR-REPO-LINK).** A markdown link, in a `.md` file, is relative to its own file
  (`[reduce-variability](../principles/reduce-variability.md)`). A code link, in a comment of any other file, is repository-rooted with the
  citation as its text (`[ADR-AZ-DATAMOD#2](/docs/adr/azure/azure-data-model.md#rule-adr-az-datamod2)`); `Format-Links` writes it from the
  citation, and `Test-Links` checks both kinds.

- **Defined terms live in the glossary.** A defined term means what the one rule that bolds it says
  ([controlled-vocabulary](repository/controlled-vocabulary.md)); [glossary](glossary.md) lists every term with its defining rule, its
  contrasts, and the phrasings to avoid. It is generated from the modules' `configs/glossary.yml` sources — edit a source, never the page.

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

- **Cite DORA through the local reference.** DORA is the repository's core theoretical construct, and `docs/references/dora/` is its
  citable map: the Core Model (`core-model.md`), the delivery metrics (`metrics.md`), the capability catalogue grouped by the site's own
  categories (`capabilities.md`), the AI Capabilities Model (`ai.md`), and every publication (`publications.md`). Each heading there has a
  stable anchor and carries its dora.dev source URL. Link a capability as `capabilities.md#<dora-slug>`, a metric as
  `metrics.md#<metric-name>`, a publication as `publications.md#<year>-<title>`, and the research program as `index.md` — never a deep
  link into dora.dev, which lives only inside `docs/references/dora/` and in the research ADRs' `## References` footnotes.

- **`dora-explains.md` collects each domain's DORA rationale.** An ADR outside `research/` carries no `## Dora explains` section; instead
  every other domain folder keeps a `dora-explains.md` that consolidates, one entry per ADR, the short present-tense paragraph tying that
  ADR's topic to DORA research and its 2–4 domain-relevant capability links (each `[Capability](<relative>/capabilities.md#<dora-slug>) —
  why it is relevant`, plus a link to the reference's `index.md`). Link only the capabilities that genuinely bear on an ADR's domain, never
  the whole catalogue.

- **The research ADRs carry their own `## Dora explains`.** Each `research/<slug>.md` is the record of one DORA capability, so it is the one
  place an ADR ends with a `## Dora explains` section: the capability's site category and Core Model position, the publications its
  evidence comes from, and its related capabilities, all as links into `docs/references/dora/`. `research/` therefore has no
  `dora-explains.md`.
'@

    # The authored prose above is wrapped for reading here, not for the page: reflow every paragraph and list item
    # through Format-MarkdownParagraph (Prettier's fill), so the generated page is formatter-stable
    # ([ADR-REPO-FORMAT#5](/docs/adr/repository/uniform-formatting.md#rule-adr-repo-format5)). A heading and a blank
    # line pass through; a '- ' line opens a list item, and an indented or plain line continues the open block.
    $reflow = {
        param([string] $Markdown)
        $out = [System.Collections.Generic.List[string]]::new()
        $block = $null
        $flush = {
            if ($block) {
                $prefix = if ($block.IsItem) {
                    '- '
                }
                else {
                    ''
                }
                $continuation = if ($block.IsItem) {
                    '  '
                }
                else {
                    ''
                }
                foreach ($wrapped in (Format-MarkdownParagraph -Text $block.Text -FirstPrefix $prefix -ContinuationPrefix $continuation)) {
                    $out.Add($wrapped)
                }
            }
        }
        foreach ($sourceLine in ($Markdown.TrimEnd() -split '\r?\n')) {
            if ($sourceLine -match '^\s*$' -or $sourceLine.StartsWith('#')) {
                . $flush
                $block = $null
                $out.Add($sourceLine.TrimEnd())
            }
            elseif ($sourceLine.StartsWith('- ')) {
                . $flush
                $block = @{ IsItem = $true; Text = $sourceLine.Substring(2) }
            }
            elseif ($block) {
                $block.Text += ' ' + $sourceLine.Trim()
            }
            else {
                $block = @{ IsItem = $false; Text = $sourceLine.Trim() }
            }
        }
        . $flush
        $out -join "`n"
    }

    $adrs = Get-Config -Config adrs
    $adrDocsRoot = Resolve-RepoPath 'docs/adr'
    Assert-PathExist $adrDocsRoot

    # Map "<domainFolder>/<slug>" -> the ADR file path relative to docs/adr (forward-slashed), so a ruleset
    # in a subfolder (automation/BCL/) still resolves to its real link target. The
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

        # The domain's description, filled the way Prettier fills it (formatter-stable, like the authored prose).
        foreach ($line in (Format-MarkdownParagraph -Text $domain.Description)) {
            $lines.Add($line)
        }
        $lines.Add('')

        $dependsOn = if ($domain.DependsOn.Count) {
            (@($domain.DependsOn) | ForEach-Object { "``$_``" }) -join ', '
        }
        else {
            'none'
        }
        $lines.Add("**Role:** ``$($domain.Role)`` — **depends on:** $dependsOn.")
        $lines.Add('')
        $lines.Add("| $('Code'.PadRight($codeWidth)) | $('ADR'.PadRight($adrWidth)) |")
        $lines.Add("| $('-' * $codeWidth) | $('-' * $adrWidth) |")
        foreach ($row in $rows) {
            $lines.Add("| $($row.Code.PadRight($codeWidth)) | $($row.Adr.PadRight($adrWidth)) |")
        }
        $lines -join "`n"
    }

    $content = (& $reflow $preamble) + "`n`n" + ($sections -join "`n`n") + "`n`n" + (& $reflow $conventions) + "`n"

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
