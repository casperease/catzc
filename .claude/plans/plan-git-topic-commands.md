---
plan:
  status: active
  value: medium-high
  reviewed: 2026-10-21
  class: feature
  targets: [pwsh/Catzc.Base.Git]
---

# Git topic commands

The sync, commit and push commands of the git topic flow (ADR-FLOW-GIT) are in `Catzc.Base.Git` with their L0 and L1 tests, the VS Code
tasks and the Bash hook's denial; one check is left, held by the whole-tree re-format.

## Why its value is medium-high

Every change reaches the server's main through these steps; the formatting gate over the module is the last proof before the plan closes.

## Open steps

1. [ ] After plan-minimal-heads' whole-tree re-format: `Test-Formatting -Path pwsh/Catzc.Base.Git, docs/references/pwsh/catzc-base-git`
       passes. On 2026-10-21 it lists 39 files, every file of the module alike (the heads the re-format writes), and one comment of
       `types/GitFlowConfig.cs` that `Export-Comments` moves to its page; `Test-Links` over the same paths is clean. Check: the gate passes.
2. [ ] `.claude/hooks/Assert-BashTimeout`: the user-command deny matches an invocation only (the command word in command position), never
       the name inside a quoted string, heredoc or `printf` argument; on 2026-10-21 it denied two sessions' log writes that only named a
       command. Check: Build-AgentHook's tests with a case that a quoted mention passes and a bare invocation is denied.
