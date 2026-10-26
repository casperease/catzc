---
plan:
  status: active
  value: high
  reviewed: 2026-10-26
  class: feature
  targets: [docs/references, pwsh/Base.CodeMeta, pwsh/Base.Docs]
---

# Reference normal form: every reference page sits at a path derived from its source, and no file links to its page

A reference page's path is derived from its source file, so no code head carries a `docs:` link and no page carries a link back:
`docs/references/<language>/<module>/<aspect>/<file>.md`, every part in the normal form, catzc inferred and never spelled. Example:
`pwsh/Base.QualityGates/tests/ManualTestPlan-Coverage.Tests.ps1` has its page at
`docs/references/pwsh/base-quality-gates/tests/manual-test-plan-coverage.md`.

## Decided (the user, 2026-10-26)

- Four parts below `docs/references`, catzc inferred as the root (part 0): 1. the language (the track folder), 2. the module (its folder in
  the normal form, no namespace), 3. the non-live aspect (`tests`, `private`, `types`, `configs`, `assets`, …; none for a module's public
  root files), 4. the file name in the normal form, its extensions dropped, folding into the module's namespace.
- The aspect may be a path (2026-10-26): every folder between the module and the file, each in the normal form, so `tests/types/X.Tests.ps1`
  has a five-part page.
- Only the trailing language extension and the `.Tests` role are dropped; an inner part of the name (`Get-OutputRoot.OutputOnlyByAddress`)
  is kept, normal-formed and joined with `-` (the orchestrator, 2026-10-26).
- The path is a projection both ways: source to page and page to source, one resolver, so code heads drop their `docs:` key and pages drop
  their link back (catzc is a namespace, not a path; configure, don't program).
- Two phases, as the module move: a user-run git mv script, then the repair with the repo's tools.

## Decided (the orchestrator, 2026-10-26)

- A module's reference article is `docs/references/<language>/<module>/index.md`, so a module is one shallow folder.
- A collision (two files of one module and aspect with the same normal form) is a finding of the gate below, never resolved silently.
- Pages with no source: authored articles go in a declared `articles:` list in comment-pages.yml; the six internal module articles merge
  into their `.psm1` pages; the python map becomes `python/*` (`python/diagrams/index.md`); stale config pages re-point or go; the obj/
  build-artifact page goes.
- Steps 1 and 2 are staged in the building session's scratchpad (out/ is cleared by hand) and swap together with step 4, after the user's
  run of step 3's script; that script reads the map csv, which is refreshed from the committed tree before the run.
- The staging (catzc-2b, 2026-10-26, from catzc-98), mirroring the repository with a `.burst-base` beside each changed file:
  `C:/Users/caspe/AppData/Local/Temp/claude/C--projects-catzc/b95cbc16-8786-4de2-b7fa-4d16798453a7/scratchpad/refnf-staged`, holding
  Base.CodeMeta's CommentPageMap.cs, CommentPagesConfig.cs, comment-pages.yml, Get-CommentPage.ps1 and their two tests; Base.QualityGates'
  new Test-ReferencePages.ps1 and test, file-meta.yml and five file-meta test fixtures; Base.Docs' DocPattern.cs, Get-ReadmeMappings.ps1,
  readme.yml and three tests; and Base.ModuleSystem's dependencies.yml (Docs gains CodeMeta).

## Open steps

1. [ ] The resolver: `Get-CommentPage` (and its CommentPagesConfig rule) maps a source file to its derived page and a page back to its file,
       through the track (`FolderNameOf`) and `ConvertTo-NormalName`; tests both ways and the collision case. Check: `Invoke-TestFile` on
       the Get-CommentPage and CommentPagesConfig tests.
2. [ ] The gate: every reference page maps back to exactly one source file, and no two sources share a page. Check: its L1 real-tree test
       at 0.
3. [ ] After step 1's resolver, `out/ns5/Rename-ReferencePages.ps1` and its map generator: the generator derives a csv (old, new, source) of
       every tracked page and module article from the resolver; the script reads that csv, refuses before moving anything when a page or a
       target is listed twice, a page is missing or a target exists, moves a case-only rename through a `.tmp` name, runs one git mv per
       page, stops on the first git error, edits no content, and lists each move under `-WhatIf`; the user runs it
       (task-user-runs-and-commits step 28). Check: the `-WhatIf` lists each page once and no target exists.
4. [ ] The repair: every code head's `docs:` key and every page's link back removed (Format-FileMeta, Sync-FileMeta), the readers
       (Build-CommentView, Export-Comments, Test-Comments, Get-ReadmeMappings) resolving through step 1, and every inbound link to a
       reference page re-pointed from the csv. Check: `Test-Comments`, `Test-FileMeta`, `Test-Links` and `Test-GeneratedFiles` at 0.
5. [ ] The rule text: the derived path (language, module, aspect path, file) and the no-link rule in the comments ADR
       (`docs/drs/repository/comments-in-docs.md`) and the file-meta head policy. Check: `Test-DrsRegistry` and `Test-Links` on both pages.
