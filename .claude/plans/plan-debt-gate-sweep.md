---
plan:
  status: active
  value: medium
  reviewed: 2026-10-22
  class: feature
  targets: [docs/explanation, docs/drs, docs/how-to, docs/references]
---

# Debt gate sweep: one gate per slice of docs, fixed before the user's full run

Every agent-doable chunk of the master landed on 2026-10-22 while the rest waits on the user. The free sessions sweep the docs with one gate
per slice, so the user's full run meets fewer reds; each finding is fixed one file at a time, and what a session cannot fix (a generated
file, an untracked target, a word-list entry) comes back as an ask.

## Why its value

`Test-Links` and `Test-Spelling` run inside the full `Test-Automation`; a finding left in the docs is a red the user meets last, after the
other plans close on that run.

## Decided

- **Swept by slice, not the whole tree** (the orchestrator, delegated, 2026-10-22): a step runs its gate on named folders only; a generated
  file's finding goes to its generator, a shared word list's entry is an ask.

## Open steps

- [ ] `docs/drs` and `docs/explanation` (catzc-e3), `docs/references` and `docs/how-to` (catzc-54): `Test-Formatting` findings fixed by
      `Format-Code -Path` on the files it names, a generated file through its generator. (check: `Test-Formatting` on the slice at 0)
- [ ] `python/catzc_diagrams` (catzc-e9): `Test-PythonLint` and `Test-PythonTypes` findings fixed one file at a time, after the day's
      `declaration.py` edits. (check: both gates at 0, and `pytest test_declaration.py` green)
- [ ] `pwsh/.internal` and `pwsh/Catzc.Base.QualityGates`, the code edited most on 2026-10-22 (catzc-a0): `Test-ScriptAnalyzer` findings
      fixed one file at a time, an import-path file in a burst. (check: `Test-ScriptAnalyzer -Path` on both at 0)
