---
plan:
  status: blocked
  value: low-medium
  reviewed: 2026-10-16
  blocked_on: verify whether the imprint step loop has landed since 2026-10-15
  targets:
    [
      automation/Catzc.Base.QualityGates,
      automation/Catzc.Base.Languages/configs/languages.yml,
      automation/Catzc.Base.Docs/configs/comments.yml,
    ]
---

# The format command moves long comments to their pages

Origin: a long rule header in automation/.scriptanalyzer stays in its file because comments.yml pages has automation/* which never matches a
dot-folder, and nothing in Format-Code runs the move. Export-Comments is the only mover.

## Why its value is low-medium

Small and local. Its value is that a long comment can no longer survive a format run. Whether the step loop exists now decides whether this
is one entry or a build.

## Needed docs

- One ADR sentence: an imprint step may write the page as a second file (recommended over a separate category).
- comments.yml page entries for automation/.scriptanalyzer and automation/.internal, each with its reason; .vendor excluded.

## Needed tests

- Format-Code runs the comments step and the header lands on its page; Test-Comments clean on the dot-folders.

## Open steps

- [ ] Read languages.yml and Format-Code: does the step loop exist (check: a grep for imprint).
- [ ] Add the comments step or build the loop (check: Format-Code tests; Test-Comments clean).

## Refs

- the full draft is carried below (formerly out/plan-comments-format-step.md)
- docs/adr/repository/comments-in-docs.md

## Carried: out/plan-comments-format-step.md (verbatim, absorbed 2026-10-16; headings below are the draft's own)

# Plan: the format command moves long comments to their pages

Status 2026-10-15. Nothing is changed yet. Origin: a long rule header in `automation/.scriptanalyzer/AnnounceStateChange.psm1` stays in the
file because `.scriptanalyzer` has no comment page, and nothing in `Format-Code` runs the move.

## Findings

- `comments.yml` `pages:` has `automation/*`, which never matches a dot-prefixed folder, so `automation/.scriptanalyzer`, `.internal` and
  `.vendor` are out of scope. `Format-Comments` reported 0 files and `Test-Comments` passed on the header.
- `Export-Comments` is the only mover. `Format-Comments` fixes residues only (`ADR-REPO-COMMENTS#5`).
- `Format-Code` (`ADR-REPO-FORMAT#8`) runs one formatter engine per language and then imprint steps. The closed step list is
  `LanguagesConfig.cs` `StepNames = { "file-meta", "csharp-namespace" }`. In the working copy `languages.yml` lists no `imprint:`,
  `Format-Code` has no step loop, and nothing calls a step. Another session is replacing the Markdown-meta code and is likely landing this.
- A step is defined as writing a derived fact into the same file. A comment move also writes a second file, the page.

## Decisions (the user's)

1. Order: wait for the other session's step wiring, then add `comments` on top (recommended), or build the step loop here.
2. A step that writes a second file: allowed as an imprint step with the ADR sentence (recommended), or a separate category.
3. Scope of the dot-folders, one reason each (proposal):
   - `automation/.scriptanalyzer`: page entry (our rules, longest headers).
   - `automation/.internal`: page entry (our loader and importer).
   - `automation/.vendor`: exclude, reason "third-party code we do not edit".

## Steps (one file at a time, each verified before the next)

1. Coordinate: check `git status` for `Format-Code.ps1`, `languages.yml`, `LanguagesConfig.cs`, `FileLanguage.cs` and message the other
   session before touching a dirty one (`parallel-sessions-and-out-dir` memory).
2. Scope, config only: `comments.yml` `pages:` gets the `.scriptanalyzer` and `.internal` entries, `exclude:` gets `.vendor` with its reason
   (`ADR-PRIN-CONFIG#1`; defaults stay on `CommentsConfig`). Check the page-folder rule in the config type accepts a dot-prefixed source.
3. Step name: add `comments` to `StepNames` in `LanguagesConfig.cs` (fresh `pwsh` to recompile) with a type test that it is a known step and
   that listing it twice is refused.
4. Adapter: the `Format-Code` step runs `Export-Comments` over the files the engine just formatted. It calls the existing engine
   (`CommentEngine.Export`) and does not copy it (`ADR-PRIN-ONELIVE`). `-DryRun` reports without writing either file.
5. Register: `languages.yml` top-level `imprint:` lists `comments` (global, every language in `comments.yml` `languages:` only).
6. Cache: a step that changes a page must not poison the format cache. Add the comment config and page set to the step's stamp
   (`ADR-AUTO-CACHE#10`) and test that a page edit and a `comments.yml` edit each invalidate it.
7. `Test-Formatting` checks the same steps (`ADR-REPO-FORMAT#8`): it must report a file whose long comment is not yet moved. Test it.
8. ADRs: one sentence each in `ADR-REPO-FORMAT#8` (a step may write the file's companion page) and `ADR-REPO-COMMENTS#5` (the format command
   runs the move). Run `Update-AdrCitation` and the doc gates.
9. Migrate: `Export-Comments -DryRun -PassThru` over the two new folders, review the count, then run it. Then the `condense-comments` agent
   rewrites the provisional insight lines, file by file.

## Verification

- Per file: its Pester file, `Test-ScriptAnalyzer`, `Format-Code -DryRun` leaves nothing to change on a second run.
- Gates: `Test-Comments`, `Test-Links`, `Test-Spelling`, `Test-Formatting`, then one full `Test-Automation` (background, 360 s cap).
- Idempotent: the second `Format-Code` run changes nothing (`ADR-REPO-COMMENTS#4`).

## Risks

- The step loop is in flight in another session: building it twice breaks `ADR-PRIN-ONELIVE`. Step 1 comes first.
- Moving `.internal` comments touches the loader and importer, which load before the module system. Their `Import` order and the published
  bundle (`ADR-AUTO-BUNDLE`) must still work: run the build tests after step 9.
- A format run that writes a page can fight a hand edit of that page; sections a person edited stay as edited (`ADR-REPO-COMMENTS#2`).
