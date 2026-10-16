---
plan:
  status: open
  value: medium
  reviewed: 2026-10-17
  blocked_on: nothing; items 1-4 are checks and generation, items 5-6 are the user's
  targets:
    [
      automation/Catzc.Base.Git/Push-Dirty.ps1,
      automation/Catzc.Base.VSCode,
      docs/adr/design/commit-lifecycle.md,
    ]
---

# Fast push to main: what is left

Landed and tested: the five `git.*` commit settings in `vscode-settings.yml`; `ADR-DSGN-LIFE:11` and `:12` in `commit-lifecycle.md`; `Push-Dirty`
in `Catzc.Base.Git`; the `.vscode/tasks.json` generator with the "Push dirty" task. A rejected push stops and reports, it never rebases.

## Open steps

1. **Reference pages.** Generate the pages the new files name in `edges.page`: `Push-Dirty.ps1.md`, `New-VSCodeTasks.ps1.md`,
   `VscodeTasksConfig.cs.md`, `vscode-tasks.yml.md`, and the three test pages. Find the generator first (`Export-Comments` makes comment pages).
2. **Link gate.** Re-run `Test-Links` over `automation/Catzc.Base.VSCode` and `automation/Catzc.Base.Git`; the one bare citation in
   `vscode-tasks.yml` was reworded and not re-checked.
3. **Glossary.** Rule `ADR-DSGN-LIFE:12` bolds **landed**; run `Test-Glossary` and add the term if it asks (`glossary-keeper`).
4. **Four `Build-RootConfig` test failures.** The fixture-head tests in `Build-RootConfig.Tests.ps1` (lines 66, 71, 189, 206) now see
   `with_body_sha` and `repo_status` lines in a generated head. Not caused by the tasks work as far as known; the generated-head config was
   being changed by another session. Find which change moved the head and fix the tests or the head, one file at a time.
5. **Unrelated, found on the way.** `Test-AdrRegistry` reports `ai-agent-contract.md` declares `ADR-AI` but no `adrs.yml` rule set registers it.
6. **By hand, once.** Bind a key to the task in the user keybindings
   (`workbench.action.tasks.runTask`, args `Push dirty`), and run `Push-Dirty` against the real remote once; the tests mock every git call.

## Not in this plan

VS Code has no setting for a default message in the Source Control field, so the empty-field default lives only in the task. No amend, no force,
no rebase-on-reject (`ADR-DSGN-LIFE:11`).
