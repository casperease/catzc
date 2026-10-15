# out/plan-strip-comments.md

`Plan: strip comments — two one-way converters that move long comments into docs and leave one useful line behind`

## Goal

Every `.ps1`, `.yml`, `.yaml`, `.cs`, `.bicep`, `.py` and shell file in scope carries, per comment, **one line that gives algorithmic
insight plus a link**; every longer explanation lives, verbatim and one-to-one, in a Markdown page under source control. A gitignored,
generated view re-inlines the pages so a reader (or an agent) can still read the "fat" file. No information is dropped anywhere: the
conversion is a move, and a round-trip test proves it.

Measured today (non-test function files under `automation/`, vendored excluded): 676 files, 50,422 lines, 18,119 comment lines (36 %). Top
offenders: `Test-Automation.ps1` (67 % comment), `Invoke-Executable.ps1` (57 %), `Write-Message.ps1` (49 %). The same shape recurs in config
headers (`links.yml`, `languages.yml`: 20–30 comment lines before the first key).

## Decisions the user takes first

| #   | Decision                                                                                                            | Recommendation                                                                                                                                                                                                                                                                                                                                              |
| --- | ------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| D1  | A comment may link to its own docs page. Today `ADR-REPO-LINK#4` says a comment never links to a reference article. | Amend `ADR-REPO-LINK` with a third link kind, the **docs link**: from a file to the one page that holds its moved comments, nowhere else. Still one-way (code → docs). `Format-Links` aligns it, `Test-Links` checks it.                                                                                                                                    |
| D2  | Where the pages live.                                                                                               | One page per source file, beside the module article: `docs/references/automation/<module-kebab>/<Stem>.<ext>.md` (e.g. `catzc-base-qualitygates/Format-Code.ps1.md`, `catzc-base-qualitygates/configs/links.yml.md`). Other areas map by folder (`pipelines/`, `infrastructure/`, `.claude/hooks/`) in `comments.yml`. Unambiguous, grep-able, small diffs. |
| D3  | Function names. `Strip` is not an approved PowerShell verb (`ADR-PWSH-VERBS`).                                      | `Export-Comments` (the strip: move out, one-way) and `Format-Comments` (the one-liner shape), plus `Build-CommentView` (the gitignored view) and `Test-Comments` (the gate). Same family and parameter shape as `Format-Links`.                                                                                                                             |
| D4  | What stays in the file.                                                                                             | `.SYNOPSIS` (one line), `.PARAMETER` first line, `.EXAMPLE`, `.OUTPUTS`, `#Requires`, suppressions, region markers, every ADR citation. Everything else longer than one line moves. The keep-list is config, not code.                                                                                                                                      |
| D5  | Who writes the insight one-liner.                                                                                   | The deterministic tool writes a provisional residue (the block's first sentence, citations appended). A **sonnet** sub-agent rewrites it into the insight line; a **haiku** run authors that agent's prompt (Phase 5).                                                                                                                                      |

## Design

### The move is a bijection

A source file `F` with comment blocks `b1..bn` (each ≥ 2 lines of prose after the keep-list) becomes:

- `F'`: each `bi` replaced by one **residue line** in the file's comment syntax:
  `# <one-liner> [comment:i](/docs/references/automation/<module>/<Stem>.<ext>.md#commenti)` — plus every ADR citation `bi` carried, so
  `Test-AnalyzerAdrMap`, rule tags and `Format-Links` keep working on the file.
- `P`: the page, opened by the H1 `Format-MarkdownTitle` writes (`ADR-REPO-FORMAT#6`), the source path in backticks, then one
  `### comment:i` section per block holding the prose **verbatim** (same wrapping, same words), preceded by one generated context line
  naming what it annotated (the help keyword, the config key, or the enclosing line). The anchor is `commenti`, never the one-liner, so the
  line may change without touching the link (`ADR-REPO-FORMAT#7`).

The one-liner has exactly one living copy, in the file (`ADR-PRIN-ONELIVE#1`); the prose has exactly one, in the page. The view
`Build-CommentView` writes `out/annotated/<repo path>` by substituting each section back where its residue line stands — the inverse map.
The L0 round-trip test is the proof: `view(export(F)) == F` for every fixture, and `export(export(F)) == export(F)` (idempotent,
`ADR-AUTO-IDEM`).

### Deterministic by construction

- Blocks are numbered in file order at first export; afterwards the number in the residue line is the key, so re-exporting a file with a new
  long comment appends `comment:n+1` and never renumbers. Same rule as `responsibility:N` and managed GUIDs (`ADR-AUTO-GUIDS`).
- Output goes through `Write-FileIfChanged` (UTF-8 no BOM, LF, trailing newline) so a second run is a byte-identical no-op.
- Comment syntax per language is **configured** in `languages.yml` (`comment: { line: '#', block: ['<#', '#>'] }`, `ADR-PRIN-CONFIG#1`); the
  engine knows one mechanism per kind. Help keywords and the keep-list live in `comments.yml`.
- The engine is compiled C# (`Catzc.Base.QualityGates.CommentEngine`, next to `LinkEngine`), runs files in parallel, and is the one place
  that parses comments. PowerShell functions are the command surface.

### Scope

In: every tracked file of a language with a `comment:` entry, minus `linguist-vendored`, `linguist-generated`, `catzc-fixture`,
`catzc-contract` (`Get-ContentExemptPath`), and minus `tests/` (a test's prose is its own subject). Out for now: Markdown, the
`dotnet-install.*` scripts (vendored), `importer.ps1` (generated).

### What the reader loses, and the answer

`Get-Help Format-Code` shows a one-line DESCRIPTION plus a link instead of four paragraphs. The answer is the view: `Build-CommentView` runs
on import like `Build-Readme` (`ADR-REPO-README#5`), and `out/annotated/` is where an agent reads a fat file. If that proves not enough,
external help can be generated from the pages later; it is not in this plan.

## Phases

Each phase is one `catzc-worker` brief; each file is edited and verified before the next (project editing rule). Nothing in Phase 4 runs
before Phases 1–3 are green.

### Phase 1 — config and types

1. `languages.yml`: add `comment:` to powershell, yaml, pipeline-yaml, csharp, bicep, python, bash. Default none = language out of scope.
   `LanguagesConfig` gets the field with its default declared once (`ADR-AUTO-DEFAULT#6`); its L0 tests cover a missing and a malformed
   entry.
2. New `automation/Catzc.Base.QualityGates/configs/comments.yml` + `CommentsConfig` type:
   - `min_lines: 2` — a block shorter than this stays.
   - `keep:` per language, the comment heads that never move (`.SYNOPSIS`, `.PARAMETER` first line, `.EXAMPLE`, `.OUTPUTS`, `#Requires`,
     `[Diagnostics.CodeAnalysis.SuppressMessage`, `#region`, `#endregion`, shebang).
   - `pages:` ordered glob → docs folder map, like `readme.yml`: `automation/*/**` → `docs/references/automation/<module-kebab>/`,
     `pipelines/**` → `docs/references/pipelines/`, `infrastructure/**` → `docs/references/infrastructure/`, `.claude/hooks/**` →
     `docs/references/automation/claude-hooks/`.
   - `residue:` the marker shape (`[comment:N](<link>)`), `obvious_phrases:` a list `Format-Comments` refuses as a whole line ("This
     function", "Helper that", "Returns the result", the file's own name). Deterministic lint, not judgement.
   - `view: out/annotated`.
3. Verify: the two config L0 tests, `Test-ConfigIdentityHygiene`, `Test-ShippedConfigs`.

### Phase 2 — the engine and the four commands

**Status 2026-10-15:** done except `Format-Comments`, which session catzc-c2 owns (`Format-Comments.ps1`, its test, and the
types `CommentFinding`, `CommentFindingKind`, `CommentFormatter`). Done and verified: `CommentEngine` (+ `CommentBlock`,
`CommentBlockKind`, `CommentResidue`, `CommentFileResult`, public `SectionLines` for catzc-c2), `private/Get-CommentScope`,
`Export-Comments`, `Build-CommentView`, `Test-Comments`, each with L0 tests; spelling, analyzer, links, formatter clean. A real
dry run over Catzc.Base.Files and Catzc.Base.QualityGates (225 files, 540 comments) round-trips byte-exact. Deviations: pages hold
each comment in a fenced `text` block (prettier `proseWrap: always` would reflow prose); the residue is two lines (insight, then
citations + link) so the insight carries no links. Deferred to Phase 4: registering `Test-Comments` in `languages.yml` `checks:`
(it fails until the migration runs) and `Build-CommentView` in the importer tail. Phase 3 note: code links inside a page's fence
are not clickable; decide whether the page adds a rendered "Cites" line per section.

1. `types/CommentEngine.cs`: parse (blocks per language syntax, help-keyword aware), plan (keep-list, min_lines), render residue, render
   page, render view. Pure functions over strings; no I/O. L0 tests with neutral fixtures (widget/gadget names), one per language.
2. `Export-Comments [-Path] [-DryRun] [-PassThru]`: writes `F'` and `P`; merges into an existing page (keeps sections whose number already
   exists, appends new ones); a page that exists already is never recreated. Source-tree tool (`Assert-SourceTree`). Reports per file the
   blocks moved and lines removed.
3. `Format-Comments [-Path] [-DryRun]`: residue shape — one line, within the line limit (`links.yml` limits reused), link canonical
   (delegates to `Format-Links`), citations present, not in `obvious_phrases`, no long comment left in scope. Fixes what is mechanical,
   lists the rest as unfixable.
4. `Build-CommentView`: the inverse, into `out/annotated/`; runs in the importer tail after `Build-Readme`.
5. `Test-Comments`: the gate — every residue resolves to a section, every section has a residue, no orphan, no long comment in scope, view
   regenerates identically. One report, one throw (`ADR-AUTO-TEST#35`). Registered in `languages.yml` `checks:` for the in-scope languages
   so `Test-Change` runs it on a changed file, and in `Test-GeneratedFiles` is **not** needed (the view lives in `out/`).
6. Verify each file: `Invoke-TestFile`, `Test-ScriptAnalyzer`, `Test-Spelling`, `Test-Links`, timeouts: new entries in `timeouts.yml` for a
   whole-repository run (background, `timeout 360`).

### Phase 3 — the ADR and the link kind

**Status 2026-10-15: done.** `ADR-REPO-COMMENTS` (`docs/adr/repository/comments-in-docs.md`, rules 1–5, registered in `adrs.yml`);
`ADR-REPO-LINK#9` (the docs link, under the `Code` kind, check-only) with `#4` reworded and the kinds table extended; the authoring
conventions in `Build-AdrIndex` name it; `CodeLinkRewriter.CheckDocsLink` reports a docs link to a missing page, a non-rooted path, or the
wrong anchor; Test-Links tests cover all three. Glossary: **docs link**, **comment page**, **residue**. The Phase 1–2 tests carry
`ADR-REPO-COMMENTS#1`–`#5` tags. Reference article updated (responsibility 3 + Division rows + `comments.yml`). Every gate is clean apart
from `Untracked` for the new ADR, which clears on commit. Not done: the fenced-prose question (code links inside a page's fence do not
render) stays open for the user.

1. `docs/adr/repository/markdown-links.md`: new rule `ADR-REPO-LINK#9`, the docs link:
   `[comment:N](/docs/references/.../<file>.md#commentN)` from a file to its own page; `#4` reworded so the article prohibition keeps
   standing for every other target. `LinkEngine` learns the shape (align repository-rooted, check target and anchor);
   `Format-Links`/`Test-Links` tests gain the cases.
2. New ADR `docs/adr/repository/comments-in-docs.md` (`ADR-REPO-COMMENTS`): the decision that a file carries one insight line per comment
   and the prose lives in its page; the page location rule; the residue shape; the round-trip proof; "How this is enforced" naming
   `Export-Comments`, `Format-Comments`, `Test-Comments`, `Build-CommentView`. Registered in `adrs.yml`; `Build-AdrIndex` regenerates the
   index; glossary entries for **residue line** and **comment page** in `configs/glossary.yml`.
3. `docs/references/automation/catzc-base-qualitygates.md`: responsibility 3 (formatting) gains the comment converters; Division table rows.

### Phase 4 — the one-way migration

Module by module, smallest first, each a separate reviewable change:

1. `Export-Comments -Path automation/<Module> -DryRun -PassThru` → read the report.
2. Run for real; then `Format-Links -Path`, `Format-Code -Path` (prettier reflows nothing verbatim: moved prose keeps its own wrapping, 120
   ≤ 140), `Test-Links`, `Test-Spelling`, `Test-Markdownlint`, `Invoke-TestFile` for the module, `Test-Comments`.
3. Config files (`configs/*.yml`) of the module in the same step.
4. Then `pipelines/`, `infrastructure/`, `.claude/hooks/`.

The converter is the sanctioned batch mechanism here: tested, dry-run first, one module per run, every run verified before the next. That is
what the "no script sweeps" editing rule protects against — untested one-off regex passes — not a gated tool.

### Phase 5 — the insight line (sonnet agent, prompt by haiku)

1. A **haiku** run (`Agent` with `model: haiku`, `catzc-worker`) authors `.claude/agents/condense-comments.md` from this brief:
   - **Inputs** per file: the residue lines, each section's prose from the page, the code around the residue.
   - **Output**: only the one-liner text of a residue line changes; the link, the number, the citations, the page, and the code never do.
   - **Criterion**: the line states the non-obvious — the invariant, the order, the edge the code guards, the reason a branch exists — never
     what the code visibly does or what the name already says. Two or three repository examples, before/after, taken from
     `Invoke-Executable.ps1` and `Get-ModuleGlobSet.ps1` by the haiku run itself.
   - **Verification** it must run per file: `Format-Comments -Path <file>` then `Test-Comments -Path <file>`; a denied time-safeguard call
     is reported, not retried.
   - Front matter: `model: sonnet`, tools `Bash, Read, Glob, Grep, Edit`.
2. The user reviews the prompt. `agents.yml` gains the entry (`supported_by: [ADR-REPO-COMMENTS#n, ADR-PRIN-ONELIVE#1]`,
   `checks: [Format-Comments, Test-Comments]`), `.claude/CLAUDE.md` `## Sub-agents` lists it, `Test-AgentDefinitions` passes.
3. The sonnet agent runs per module after Phase 4 for that module, one file per verification.

### Phase 6 — closing

- `Build-Readme`: the module article's Division table gets a page link per function (nice to have, after everything else).
- Memory: none needed; the repo records the mechanism.

## Verification summary

| Proof                        | Where                                     |
| ---------------------------- | ----------------------------------------- |
| Lossless                     | L0 round-trip test `view(export(F)) == F` |
| Deterministic and idempotent | L0: twice-run equals once-run, byte-equal |
| Links valid                  | `Test-Links` (docs link kind)             |
| No prose left, no orphan     | `Test-Comments`                           |
| Citations survive            | `Test-AnalyzerAdrMap`, rule-tag tests     |
| Pages well-formed            | `Test-MarkdownTitle`, `Test-Markdownlint` |

## Open questions

- Comment-based help `.NOTES`: move (recommended) or keep?
- Inline trailing comments (`$x = 1  # why`) are one line by definition and never move; confirm.
- Test files: out of scope now; a later pass can include `Describe` prologues.
