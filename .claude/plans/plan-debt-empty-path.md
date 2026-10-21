---
plan:
  status: active
  value: high
  reviewed: 2026-10-21
  class: meta
  targets: [pwsh/Catzc.Base.QualityGates/Format-Code.ps1]
---

# Debt empty path

On 2026-10-21 `pwsh -File` passed a comma-joined path list as one string (twice: the orchestrator's plan rename and catzc-05's verify
script), and an empty `-Path` reached `Format-Code`, which then formatted the whole tree (1,931 files) unannounced, with no hold. An empty
`-Path` must never mean "everything"; "everything" is said by leaving `-Path` out.

## Open steps

1. [ ] `pwsh/Catzc.Base.QualityGates/Format-Code.ps1`: `-Path` given but empty, or holding only empty strings, is an error naming the cause,
       never a whole-tree run; omitting `-Path` keeps today's default (check: `Invoke-TestFile` on `Format-Code.Tests.ps1` with a case for
       `-Path ''` and `-Path @()`).
2. [ ] The other commands whose `-Path` default is the whole tree (`Format-FileMeta`, `Test-Links`, `Test-FileMeta`, `Rename-CodeName`,
       `Sync-FileMeta`, the gates): the same refusal, through one shared assert rather than a copy per command (check: each command's test
       file with an empty-path case; `Test-ParameterConsistency`).
3. [ ] `.claude/skills/catzc-run/SKILL.md`: one clause merged into an existing item, that a path list is passed to `pwsh -File` as one
       argument per path or through `-Command`, never comma-joined (check: `Test-AgentDefinitions`).
