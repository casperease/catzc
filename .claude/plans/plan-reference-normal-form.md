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

## Open steps

1. [ ] The rule text: the derived path (language, module, aspect path, file) and the no-link rule in the comments ADR
       (`docs/drs/repository/comments-in-docs.md`) and the file-meta head policy. Check: `Test-DrsRegistry` and `Test-Links` on both pages.
2. [ ] Split the Importer article (`docs/references/pwsh/internal/catzc-internal-importer.md`, 473 lines after the step 4a merge) into a
       folder of linked pages, then drop its file-limits.yml exception. Check: `Test-FileLimits` on the page passes without the exception.
