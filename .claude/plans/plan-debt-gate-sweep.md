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

- [ ] The comment pages against their code, after the day's code edits (catzc-e9): 21 findings, 13 sections on 11 pages re-pointed; the 8
      left and 3 stale-prose sections are rewritten to the current code, a fact the code still holds moved to the section that carries it, a
      section whose element and fact are both gone removed (a comment page follows its code; decided by the orchestrator as delegated,
      2026-10-22). (check: `Test-Comments` at 0)
- [ ] `Test-Spelling` skips files under dot folders (it checked 448 of the 615 files under `docs/drs`, `docs/explanation` and `docs/how-to`,
      missing every `.assets/*.drawio.yml`) and passes a folder `-Path` that checked nothing (catzc-a0, 2026-10-22,
      `out/catzc-a0-gate-sweep-spelling.md`): it checks the tracked files under a dot folder the spelling scope does not exclude, and a run
      that checked no file is a finding, not a pass (decided by the orchestrator as delegated). The three findings this uncovers, assembled
      Azure names in `docs/drs/azure/.assets/azure-name-assembly.drawio.yml`, are data (ADR-AUTO-SPELL-IDENTIFIERSNOTDATA) and get an
      ignore, not word-list entries. (check: the gate's test file green with a dot-folder case and an empty-scope case, and `Test-Spelling`
      on the three folders at 0)
