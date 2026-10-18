---
plan:
  status: active
  value: medium
  reviewed: 2026-10-18
  blocked_on: the user's one manual run, the one open step
  targets: [pwsh/Catzc.Base.Git/Push-Dirty.ps1, pwsh/Catzc.Base.VSCode, docs/adr/design/commit-lifecycle.md]
---

# Fast push to main: what is left

`Push-Dirty` (Catzc.Base.Git), the generated "Push dirty" task in `.vscode/tasks.json`, the `git.*` commit settings in `vscode-settings.yml`
and `ADR-DSGN-LIFE-FASTPUSHLANDS` are in the tree. A rejected push stops and reports; it never rebases.

## Decided

- VS Code has no setting for a default message in the Source Control field, so the empty-field default lives only in the task. No amend, no
  force, no rebase-on-reject (`ADR-DSGN-LIFE-FASTPUSHLANDS`).

## Open steps

- [ ] **By hand, once; the user's.** Bind a key to the task in the user keybindings (`workbench.action.tasks.runTask`, args `Push dirty`),
      and run `Push-Dirty` against the real remote once; the tests mock every git call (check: one real `Push-Dirty` run reported).
