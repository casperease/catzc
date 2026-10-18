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
---

# File meta head policy: facts never read from a head, a head only where configured, Sync-FileMeta for one file

Every fact about a file (place facts, edges, comments) is verifiable from the registries, git, the disk and the file's body, so no command
reads an imprinted fact back and every command works whether a file has a head or not. Whether a file carries a head is a configured
policy with sensible defaults. One command, `Sync-FileMeta`, brings one file up to the head its policy says it has.

Context: the explanation article `docs/explanation/file-meta.md` describes the state and this direction; it is not yet tracked.

## Why its value is high

About 3,900 of 5,172 tracked files carry a block today, authored and generated alike, and five readers take facts or authored values back
out of heads. Each head is a second statement of a derivable fact that can drift, and a reader that trusts it gives a verdict that depends
on whether a file was imprinted. The policy removes heads from authored source and makes every verdict head-independent.

## Decided (2026-10-18)

- **No read-back.** No command reads `immutable` or `edges` back; stripping every head changes no verdict. Becomes a new ADR-REPO-FILEMETA
  rule (ADR-REPO-PLANS#9).
- **Head policy.** ADR-REPO-FILEMETA#1 is restated: a file carries a block exactly as its head policy says, `required`, `optional` or
  `forbidden`, defaults declared once on the policy's type (ADR-AUTO-DEFAULT#6). Proposed defaults: tracked and generated `required`;
  agent and capability definitions `required`; authored source (code, config, docs) `forbidden`; untracked output under `out/` `optional`.
- **Function help moves to the comment page.** An authored code file carries no head, so its synopsis, description, parameters, outputs
  and examples live on the page `comments.yml` resolves for the path (`PageFor`).
- **`Sync-FileMeta -Path <file>`** is the single-file command: resolve facts without reading the head, resolve the policy, write, replace
  or strip the head (keeping foreign keys), run the file's formatter and title normalisation, report what changed (`-DryRun`). It is a
  one-shot, never a tight-loop primitive; loops use `Assert-` and `Test-` guards. It reuses `Invoke-FileMetaEngine` with one entry
  (ADR-PRIN-ONELIVE) and takes an untracked path as given.

## Open steps

### Open question (blocks the help move)

- [ ] Ask the user how a comment page holds authored help, then record the answer here: the page is a locked, generated file today
      (`comment-page` under `locked_classes` in `file-meta.yml`, with `with_body_sha` and a `generator` naming `Export-Comments.ps1`). Either
      the page gets an authored part `Export-Comments` keeps, or the class leaves `locked_classes`. (check: the answer is recorded under
      Decided)

### Phase 1: the rules

- [ ] `docs/adr/repository/file-meta.md`: restate rule 1 to the head policy and add the no-read-back rule, with Context and Decision
      sections for both. (check: `Test-AdrRegistry`, `Test-Links -Path docs/adr/repository/file-meta.md`)
- [ ] `docs/adr/repository/code-file-meta.md`: say help lives on the comment page, not in the head's `config` part, once the open question is
      answered. (check: `Test-Links -Path docs/adr/repository/code-file-meta.md`)

### Phase 2: remove the read-backs, one file at a time

- [ ] `automation/Catzc.Base.QualityGates/private/Get-AdrCodesFileMetaFact.ps1`: drop the `held_classes` merge of the head's `cites` edge,
      so codes come from the body and the comment page only; drop `held_classes` from the `adr-codes` comment in `file-meta.yml`. (check:
      `tests/Get-AdrCodesFileMetaFact.Tests.ps1`)
- [ ] `automation/Catzc.Base.QualityGates/private/Get-AdrUsageRow.ps1`: compute `cites` and `links` from the body (the same processors
      the imprint calls) instead of `EdgeLists`. (check: its Pester file, and `Get-AdrUsage` gives the same rows on a stripped copy)
- [ ] The generated-or-authored decision: tell a generated file by the writer registry (`configs/generated-files.yml`) and the
      `linguist-generated` attribute, not by the `generator` key; name the one reader that decides it today before editing. (check: that
      reader's Pester file)
- [ ] `automation/Catzc.Base.Slides/private/Read-SlideFile.ps1`: decide with the user whether slide config is authored front matter the
      policy allows for the slide class, or moves out. (check: `Build-SlideDeck` tests)

### Phase 3: the policy

- [ ] A head-policy config type in `automation/Catzc.Base.QualityGates/types/` with the three values and the defaults above declared on the
      type; the policy entries keyed by class in `file-meta.yml`. (check: an L0 types test of the defaults and the resolution order)
- [ ] `automation/Catzc.Base.QualityGates/private/Invoke-FileMetaEngine.ps1`: a finding for a head absent where `required` or present
      where `forbidden`; `Save-FileMetaResult` strips a forbidden head. (check: `tests/Invoke-FileMetaEngine.Tests.ps1`)

### Phase 4: the single-file command

- [ ] `automation/Catzc.Base.QualityGates/Sync-FileMeta.ps1` with its Pester file `tests/Sync-FileMeta.Tests.ps1`: one mandatory path,
      `-DryRun`, `-PassThru`; required, optional and forbidden cases on a temp repo, an untracked path, a kept foreign key, and a second run
      that changes nothing. (check: `tests/Sync-FileMeta.Tests.ps1`)

### Phase 5: help on the comment page (after the open question)

- [ ] `automation/Catzc.Base.QualityGates/private/Get-HelpHeadFinding.ps1`: check the help on the comment page instead of the head's
      `config` part, and name every other reader of head help before moving it. (check: `tests/Get-HelpHeadFinding.Tests.ps1`)

## Refs

- [ADR-REPO-FILEMETA](../../docs/adr/repository/file-meta.md), [ADR-REPO-CODEMETA](../../docs/adr/repository/code-file-meta.md),
  [ADR-REPO-COMMENTS](../../docs/adr/repository/comments-in-docs.md),
  [ADR-AUTO-DEFAULT#6](../../docs/adr/automation/sensible-defaults.md#rule-adr-auto-default6).
- Overlaps [plan-file-head-immutable-edges-classes](plan-file-head-immutable-edges-classes.md): that plan settles the head's shape and its
  classes; this one decides which files carry it and that no reader trusts it.
