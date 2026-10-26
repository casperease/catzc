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

## Open steps

1. [ ] Should `catzc-verify` carry one line naming what a new file needs (the meta head of a new `.cs`, the Builder row and build fixture of
       a new `.internal` asset), or should `New-` scaffolding write them so no line is needed? Recommendation: the scaffolding, since a
       default beats an instruction. Check: a new `.cs` and a new `.internal` asset pass `Test-FileMeta` and `Invoke-ModuleBuild.Tests` with
       no hand step.
2. [ ] Should `catzc-run` say how a staged file's comments are exported (`CommentEngine.Export` on the staged text, the page written to
       docs), or should `Export-Comments` take a `-StagedFolder`? Recommendation: the parameter, so the one command covers it. Check:
       `Export-Comments -StagedFolder` on a staged `.cs` moves its long comments and `Test-Comments` passes after the swap.
3. [ ] Should the importer's "sources changed during the import" error name the stale stamp and how to clear it, now that
       `Get-CombinedTypeHash.ps1` writes `form` as `body` whatever was hashed? Recommendation: fix the stamp's `form` at its writer
       (catzc-cc has it), and drop the error text change. Check: an import after a no-block hash leaves no stamp that makes the next compile
       throw.
