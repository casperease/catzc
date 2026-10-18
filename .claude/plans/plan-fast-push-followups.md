---
plan:
  status: active
  value: medium
  reviewed: 2026-10-17
  blocked_on: nothing; the first three steps are checks and fixes, the last is the user's
  targets: [automation/Catzc.Base.Git/Push-Dirty.ps1, automation/Catzc.Base.VSCode, docs/adr/design/commit-lifecycle.md]
catzc:
  immutable:
    repo_status: clean
    path: ".claude/plans/plan-fast-push-followups.md"
    folder: plans
    name: plan-fast-push-followups
    filetype: md
    kind: other
    language: markdown
    track: ".claude"
    tracktype: vendor-settings
    vendor: claude
    module: ".claude"
    moduletype: settings
---

# Fast push to main: what is left

Landed and tested: the five `git.*` commit settings in `vscode-settings.yml`; `ADR-DSGN-LIFE:11` and `:12` in `commit-lifecycle.md`;
`Push-Dirty` in `Catzc.Base.Git`; the `.vscode/tasks.json` generator with the "Push dirty" task. A rejected push stops and reports, it never
rebases.

## Open steps

- [ ] **Four `Build-RootConfig` test failures.** The fixture-head tests in `Build-RootConfig.Tests.ps1` (lines 66, 71, 189, 206) now see
      `with_body_sha` and `repo_status` lines in a generated head. Not caused by the tasks work as far as known; the generated-head config
      was being changed by another session. Find which change moved the head and fix the tests or the head, one file at a time (check:
      `Build-RootConfig.Tests.ps1` passes).
- [ ] **Unrelated, found on the way: the registry.** `Test-AdrRegistry` reports `ai-agent-contract.md` declares `ADR-AI` but no `adrs.yml`
      rule set registers it (check: `Test-AdrRegistry` no longer names `ADR-AI`).
- [ ] **Unrelated, found on the way: the vocabulary.** `Test-Glossary` reports about 195 vocabulary findings in other plans and docs ("full
      suite", "gate", "phase", "layer", "source", "slot") (check: every finding is assigned to the plan that owns its file, as a step
      there).
- [ ] **By hand, once; the user's.** Bind a key to the task in the user keybindings (`workbench.action.tasks.runTask`, args `Push dirty`),
      and run `Push-Dirty` against the real remote once; the tests mock every git call (check: one real `Push-Dirty` run reported).

## Not in this plan

VS Code has no setting for a default message in the Source Control field, so the empty-field default lives only in the task. No amend, no
force, no rebase-on-reject (`ADR-DSGN-LIFE:11`).
