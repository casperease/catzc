---
plan:
  status: active
  value: high
  reviewed: 2026-10-18
  targets:
    [
      docs/adr/repository/file-meta.md,
      docs/adr/repository/code-file-meta.md,
      automation/Catzc.Base.QualityGates,
      automation/Catzc.Base.QualityGates/configs/file-meta.yml,
      automation/Catzc.Base.Slides/private/Read-SlideFile.ps1,
    ]
catzc:
  immutable:
    repo_status: clean
    path: ".claude/plans/plan-file-meta-head-policy.md"
    folder: plans
    name: plan-file-meta-head-policy
    filetype: md
    kind: other
    language: markdown
    track: ".claude"
    tracktype: vendor-settings
    vendor: claude
    module: ".claude"
    moduletype: settings
  edges:
    cites:
      - ADR-AUTO-DEFAULT#6
      - ADR-REPO-COMMENTS#2
      - ADR-REPO-FILEMETA#{1,4}
      - ADR-REPO-PLANS#9
    links:
      - ".claude/plans/plan-file-head-immutable-edges-classes.md"
      - docs/adr/automation/sensible-defaults.md#rule-adr-auto-default6
      - docs/adr/repository/code-file-meta.md
      - docs/adr/repository/comments-in-docs.md
      - docs/adr/repository/file-meta.md
---

# File meta head policy: facts never read from a head, a head only where configured, Sync-FileMeta for one file

Every fact about a file (place facts, edges, comments) is verifiable from the registries, git, the disk and the file's body, so no command
reads an imprinted fact back and every command works whether a file has a head or not. Whether a file carries a head is a configured policy
with sensible defaults. One command, `Sync-FileMeta`, brings one file up to the head its policy says it has.

Context: the explanation article `docs/explanation/file-meta.md` describes the state and this direction; it is not yet tracked.

## Why its value is high

About 3,900 of 5,172 tracked files carry a block today, authored and generated alike, and five readers take facts or authored values back
out of heads. Each head is a second statement of a derivable fact that can drift, and a reader that trusts it gives a verdict that depends
on whether a file was imprinted. The policy removes heads from authored source and makes every verdict head-independent.

## Decided (2026-10-18)

- **No read-back.** No command reads `immutable` or `edges` back; stripping every head changes no verdict. Becomes a new ADR-REPO-FILEMETA
  rule (ADR-REPO-PLANS#9).
- **Head policy.** ADR-REPO-FILEMETA#1 is restated: a file carries a block exactly as its head policy says, `required`, `optional` or
  `forbidden`, defaults declared once on the policy's type (ADR-AUTO-DEFAULT#6). Proposed defaults: tracked and generated `required`; agent
  and capability definitions `required`; authored source (code, config, docs) `forbidden`; untracked output under `out/` `optional`.
- **Function help moves to the comment page.** An authored code file carries no head, so its synopsis, description, parameters, outputs and
  examples live on the page `comments.yml` resolves for the path (`PageFor`).
- **`Sync-FileMeta -Path <file>`** is the single-file command: resolve facts without reading the head, resolve the policy, write, replace or
  strip the head (keeping foreign keys), run the file's formatter and title normalisation, report what changed (`-DryRun`). It is a
  one-shot, never a tight-loop primitive; loops use `Assert-` and `Test-` guards. It reuses `Invoke-FileMetaEngine` with one entry
  (ADR-PRIN-ONELIVE) and takes an untracked path as given.

- **A comment page is an authored file, and help is its `## help` section** (decided 2026-10-18 at the user's request). The page is already
  where a code file's prose lives: `Export-Comments` only appends new `## comment:<n>` sections and a section a person edits stays as edited
  (ADR-REPO-COMMENTS#2), so `locked`, `with_body_sha` and `generator` misdescribe it. The page leaves `locked_classes`, carries no body hash
  and no `generator`, and under the head policy is authored docs, so it carries no head; its kind comes from the file-kinds glob and the way
  from code to page is `comments.yml` (`PageFor`), never a head edge. Help is one section, `## help`, first after the intro line, in a fixed
  shape: `### synopsis` (one line), `### description`, `### parameter <Name>` (one per parameter, in the `param()` order), `### outputs`,
  `### example <n>` (a fenced `powershell` block each). `Export-Comments` never writes or reorders it, and the name cannot collide with
  `comment:<n>`. A function file without a page is a help finding the author fixes by writing the page. Moving today's help out of the heads
  is one tested tool step of `Export-Comments`, as the comment move is, never an ad-hoc sweep.

## Open steps

### Phase 1: the rules

- [x] `docs/adr/repository/file-meta.md`: restate rule 1 to the head policy and add the no-read-back rule, with Context and Decision
      sections for both. (check: `Test-AdrRegistry`, `Test-Links -Path docs/adr/repository/file-meta.md`) — 2026-10-18: rule 1 restated,
      rule 14 added with "A head shows the facts, never holds them" and "Head policy", rule 7 tells generated files by the writer registry
      and `linguist-generated`; Test-AdrRegistry, Test-Links, Test-FileMeta, Test-Markdownlint, Test-Spelling, Test-Glossary all pass.
- [x] `docs/adr/repository/code-file-meta.md`: say help lives in the `## help` section of the comment page, not in the head's `config` part.
      (check: `Test-Links -Path docs/adr/repository/code-file-meta.md`) — 2026-10-18: rule 1 and 3 follow the head policy, rule 2 derives
      `cites` without reading the head and gives a code head no `config` part, the example drops its `.SYNOPSIS` block; Test-Links,
      Test-AdrRegistry, Test-FileMeta, Test-Markdownlint, Test-Spelling pass.
- [x] `docs/adr/repository/function-help.md`: ADR-REPO-HELP restated: help is the comment page's `## help` section in the fixed shape (rules
      1 to 5, Context and Decision). (check: `Test-AdrRegistry`, `Test-Links -Path docs/adr/repository/function-help.md`) — 2026-10-18: both
      pass, with Test-FileMeta, Test-Markdownlint, Test-Spelling.
- [x] `docs/adr/repository/comments-in-docs.md`: rule 1 finds the page through `comments.yml`, not a head edge; a new rule makes the page an
      authored file whose `## help` section holds the help in the fixed shape, which `Export-Comments` never writes; rule 5 drops the page's
      `kind` from its meta block. (check: `Test-AdrRegistry`, `Test-Links -Path docs/adr/repository/comments-in-docs.md`) — 2026-10-18: rule
      6 added with "An authored page"; both pass, with Test-FileMeta, Test-Markdownlint, Test-Spelling.
- [ ] `automation/Catzc.Base.QualityGates/configs/file-meta.yml`: remove `comment-page` from `locked_classes`, from the `body-sha` selection
      and from the `generator` kind (which then selects nothing and goes, with `Get-GeneratorFileMetaFact.ps1` and its test, per
      ADR-REPO-FILEMETA#4); in the same change, `docs/adr/repository/file-meta.md` drops the comment page as the one generated page the
      engine imprints (rules 3, 7 and 13). (check: `Test-FileMetaProcessors`, `tests/Get-RepoStatusFileMetaFact.Tests.ps1`,
      `Test-AdrRegistry`)

### Phase 2: remove the read-backs, one file at a time

- [ ] Decide each of the 113 held codes that no text spells out (`out/held-nowhere.txt`, such as `ADR-AUTO-TYPES#8` in
      `ContractCommand.cs`): an author either writes the real link into the file's help or comment page, or the code goes, recorded on a
      page first (never dropped silently). Decided 2026-10-18 by the user: a file's citations are the real links inferred from its own text
      and its page. Measured over the 448 files dropping the merge rewrites: 942 held codes, 226 already in the body or the page, 603 only
      in the help text inside the head (mostly links, such as `[ADR-AZ-CLI#1](...)` in `Assert-AzCliBicep.ps1`, which the kind does not scan
      because it reads the text below the head), 113 nowhere. The help move (Phase 5) brings the 603 onto the page, where the kind reads
      them. (check: `out/held-nowhere.txt` is empty after a fresh measurement)
- [ ] `automation/Catzc.Base.QualityGates/private/Get-AdrCodesFileMetaFact.ps1`: drop the `held_classes` merge of the head's `cites` edge,
      so codes come from the body and the comment page only; drop `held_classes` from the `adr-codes` comment in `file-meta.yml`; lands in
      the one tree-wide pass, after the help move and the 113 decisions. (check: `tests/Get-AdrCodesFileMetaFact.Tests.ps1`, and a dry run
      loses no code)
- [ ] `automation/Catzc.Base.QualityGates/private/Get-AdrUsageRow.ps1`: compute `cites` and `links` from the body (the same processors the
      imprint calls) instead of `EdgeLists`. (check: its Pester file, and `Get-AdrUsage` gives the same rows on a stripped copy)
- [ ] The generated-or-authored decision: tell a generated file by the writer registry (`configs/generated-files.yml`) and the
      `linguist-generated` attribute, not by the `generator` key; name the one reader that decides it today before editing. (check: that
      reader's Pester file)
- [x] `automation/Catzc.Base.Slides/private/Read-SlideFile.ps1`: decide with the user whether slide config is authored front matter the
      policy allows for the slide class, or moves out. (check: `Build-SlideDeck` tests) — 2026-10-18: the user decided slides stay
      `required` (already in `file-meta.yml`); their `config` part is authored data the slide tooling alone reads, so no code changes.

### Phase 3: the policy

- [x] A head-policy config type in `automation/Catzc.Base.QualityGates/types/` with the three values and the defaults above declared on the
      type; the policy entries keyed by class in `file-meta.yml`. (check: an L0 types test of the defaults and the resolution order) —
      2026-10-18: `HeadPolicy.cs`, `FileHeadPolicy.cs` (default `forbidden`, first matching class wins), `FileMetaConfig.head_policy` and
      `PolicyFor`; `file-meta.yml` sets `default: required` plus `agent`, `capability`, `slide`, `index`, `glossary` as `required`;
      `tests/types/FileHeadPolicy.Tests.ps1` passes.
- [x] `automation/Catzc.Base.QualityGates/private/Invoke-FileMetaEngine.ps1`: a finding for a head absent where `required` or present where
      `forbidden`; `Save-FileMetaResult` strips a forbidden head. (check: `tests/Invoke-FileMetaEngine.Tests.ps1`) — 2026-10-18: forbidden
      strips the block (renders with no facts; an empty Markdown front matter goes whole, with its separator line, in `MarkdownDocument`), a
      forbidden block with a `config` part is a `ForbiddenConfig` finding left unchanged, optional writes no new block; Format-FileMeta and
      Test-FileMeta word the new finding. 124 tests over the engine, Format-FileMeta, Invoke-ImprintStep, FileMetaConfig, FileHeadPolicy and
      MarkdownMeta pass; a tree-wide `Format-FileMeta -DryRun` changes no file because of the policy (4 of 4,079 drift, all peer work).

### The one tree-wide pass (after Phases 2, 4 and 5)

- [ ] `automation/Catzc.Base.QualityGates/configs/file-meta.yml`: delete `default: required` and its comment line, so the type's `forbidden`
      holds, after the help has moved to the comment pages (Phase 5), so no code head is left with a `config` part; then run
      `Format-FileMeta` once over the tree. (check: `Test-FileMeta` reports no finding, and no `ForbiddenConfig`)

### Phase 4: the single-file command

- [ ] `automation/Catzc.Base.QualityGates/Sync-FileMeta.ps1` with its Pester file `tests/Sync-FileMeta.Tests.ps1`: one mandatory path,
      `-DryRun`, `-PassThru`; required, optional and forbidden cases on a temp repo, an untracked path, a kept foreign key, and a second run
      that changes nothing. (check: `tests/Sync-FileMeta.Tests.ps1`)

### Phase 5: help on the comment page

- [ ] `automation/Catzc.Base.QualityGates/private/Get-HelpHeadFinding.ps1`: check the `## help` section of the comment page (synopsis
      present, one `### parameter` per `param()` entry in order) instead of the head's `config` part, and name every other reader of head
      help before the move. (check: `tests/Get-HelpHeadFinding.Tests.ps1`)
- [ ] `automation/Catzc.Base.QualityGates/Export-Comments.ps1`: a help step that moves a head's help keys into the page's `## help` section
      in the fixed shape and leaves an existing section alone; run once over the tree, then per-file `Test-Comments`. (check:
      `tests/Export-Comments.Tests.ps1`, a second run changes nothing)

## Refs

- [ADR-REPO-FILEMETA](../../docs/adr/repository/file-meta.md), [ADR-REPO-CODEMETA](../../docs/adr/repository/code-file-meta.md),
  [ADR-REPO-COMMENTS](../../docs/adr/repository/comments-in-docs.md),
  [ADR-AUTO-DEFAULT#6](../../docs/adr/automation/sensible-defaults.md#rule-adr-auto-default6).
- Overlaps [plan-file-head-immutable-edges-classes](plan-file-head-immutable-edges-classes.md): that plan settles the head's shape and its
  classes; this one decides which files carry it and that no reader trusts it.
