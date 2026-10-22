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

- [ ] `docs/explanation`: `Test-Links` findings fixed, links only (catzc-e3). (check: `Test-Links -Path docs/explanation` at 0)
- [ ] `docs/drs`: `Test-Links` findings fixed, generated files reported (catzc-e9). (check: `Test-Links -Path docs/drs` at 0)
- [ ] `docs/how-to` and `docs/references`: `Test-Links` findings fixed, generated pages reported (catzc-54). (check: `Test-Links` on both
      at 0)
- [ ] `docs/drs`, `docs/explanation`, `docs/how-to`: `Test-Spelling` typos fixed, missing real words listed as word-list asks (catzc-a0).
      (check: `Test-Spelling` on the three at 0, or each remaining finding an ask)
