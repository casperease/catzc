---
plan:
  status: active
  value: low
  reviewed: 2026-10-26
  class: debt
  targets: [.claude/skills/catzc-verify/SKILL.md, .claude/skills/catzc-run/SKILL.md]
---

# Debt new-file checklist: what a new type, asset or staged file needs before its gates pass

Three facts cost catzc-5e a rolled-back burst each on 2026-10-26: a new `.cs` fails `Test-FileMeta` until it carries its meta head, a new
`.internal` asset needs its row in `Catzc.Internal.Builder.psm1` and in the `Invoke-ModuleBuild.Tests` fixture, and `Export-Comments` reads
only tracked paths, so a staged copy is exported through `CommentEngine.Export`. A stale types stamp also blocked every import until its
file under `%LOCALAPPDATA%\catzc\types` was deleted.

## Decided (catzc-22, 2026-10-26)

- A new file's needs are written by scaffolding, so `catzc-verify` carries no line for them.
- `Export-Comments` takes `-StagedFolder`.
- The stamp's `form` is fixed at its writer, `Get-CombinedTypeHash.ps1`, and the importer's error text stays.

## Open steps

1. [ ] Scaffolding writes the meta head of a new `.cs`, and the Builder row and `Invoke-ModuleBuild.Tests` fixture row of a new
       `.internal` asset. Check: a new `.cs` and a new `.internal` asset pass `Test-FileMeta` and `Invoke-ModuleBuild.Tests` with no hand
       step.
2. [ ] `Export-Comments -StagedFolder` exports a staged file's long comments into a staged page beside it, guarded by a burst base. Check:
       `Export-Comments.Tests.ps1` passes, and a staged `.cs` swapped in by `Invoke-StagedBurst` passes `Test-Comments`.
3. [ ] `Get-CombinedTypeHash.ps1` writes `form` as the form it hashed (`body` with a bcl block, else `whole`). Check: an import after a
       no-block hash leaves no stamp that makes the next compile throw.