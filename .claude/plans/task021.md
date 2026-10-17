---
task:
  id: "021"
  status: open
  plans: [plan-file-head-immutable-edges-classes]
  value: medium-high
  blocked_on: task007 first (it edits file-meta.yml too; one owner at a time)
  targets:
    [
      automation/Catzc.Base.QualityGates/configs/file-meta.yml,
      automation/Catzc.Base.QualityGates/types,
      automation/Catzc.Base.Globs,
      contracts/catzc/0.0.0,
      docs/adr/repository/file-meta.md,
    ]
catzc:
  immutable:
    with_body_sha: "0439e6f8b2ae"
    repo_status: clean
    path: ".claude/plans/task021.md"
    folder: plans
    name: task021
    filetype: md
    kind: other
    language: markdown
    track: ".claude"
    tracktype: vendor-settings
    vendor: claude
    module: ".claude"
    moduletype: settings
---

# task021: class selectors in file-meta.yml, the reachability test, the head schema

Decided Q50: class selectors go now, one kind at a time. The model (carried class-selectors draft): globs are spelled once, in
`file-kinds.yml`; every other front-matter kind selects by `classes` or `languages`, never by its own `files` globs; `files` leaves when no
kind uses it (ADR-PRIN-ONELIVE). Proof: a whole-repo `Format-FileMeta -DryRun` before and after shows zero head changes. Q41: the intended
kind overlaps are written down and FileKindReachability fails on a shadowed kind. Q39: the contract schema stays hand-written.

## Steps

1. Proof baseline: `Format-FileMeta -DryRun` over the tree in the background; save the report under out/. Check: the report exists, zero
   changes (if not, stop: the tree is not clean for this work).
2. `FileMetaKind` type (`automation/Catzc.Base.QualityGates/types`): `classes` and `languages` with defaults; `files` together with `classes`
   is rejected at construction naming the kind. L0 tests, widget/gadget. Fresh pwsh. Check: the type's tests pass.
3. `Invoke-FileMetaEngine` and `Get-FileMetaFact`: the file's class is computed once per file (file-kind already does) and kinds are selected
   by it. Check: their tests pass; `Test-FileMetaProcessors` counts unchanged.
4. `file-meta.yml`, one kind per step: rewrite its `select:` to classes or languages; after each, `Format-FileMeta -DryRun` shows zero changes.
   Check: that kind's processor test; the dry run.
5. `Get-AdrCodesFileMetaFact` reads `domain_classes` and `held_classes` against the file's class; the `relatives` processor selects by
   `classes`. Check: both tests pass.
6. Remove `files` from the type and config when no kind uses it. Check: the type tests; Test-FileMeta clean.
7. `docs/adr/repository/file-meta.md` rule 2 and `docs/adr/repository/code-meta.md` rule 3: a kind selects by class; file-kind is the one glob
   list. Present tense. Also clear the Test-Markdownlint findings in file-meta.md. Check: Test-AdrRegistry, Test-Links, Test-Markdownlint clean.
8. Q41: `automation/Catzc.Base.Globs/configs/file-kinds.yml` gains an `overlaps:` list (declared once on the config type) naming each intended
   pair; `FileKindReachability.Tests.ps1` fails when a kind is mostly shadowed by an earlier one and the pair is not listed (how drawio-kit
   hid). Check: a fixture with a shadowed kind fails; the real registry passes.
9. `contracts/catzc/0.0.0` `head.schema.json` and `head.sample.yml`: `tracktype` and `vendor` added by hand (Q39). Check:
   `Format-FileMeta.Contract.Tests` passes; Test-Contracts clean.
10. Tick the class-selector, reachability and schema steps in `plan-file-head-immutable-edges-classes.md`. Check: grep `- [ ]` counts the
    task022 leftovers only.

## Report

As report-fixed, with the two dry-run reports named.
