---
plan:
  status: active
  value: medium-high
  reviewed: 2026-10-21
  class: feature
  targets:
    [
      pwsh/Catzc.Base.Git,
      pwsh/Catzc.Base.VSCode/configs/vscode-tasks.yml,
      docs/adr/flow/git-topic-flow.md,
      .claude/hooks/Assert-BashTimeout,
    ]
---

# Git topic commands

The sync, commit and push commands of the git topic flow (ADR-FLOW-GIT), in `Catzc.Base.Git`: they run git only when the user invokes them
(ADR-FLOW-GIT-USERRUNSGIT), and only their own L0 and L1 tests run them otherwise. One reading command resolves the sync point for all of
them.

## Why its value is medium-high

Every change reaches the server's main through these steps, and today they are done by hand from memory: which commit to sync from, keeping
the topic one commit, rebasing before landing, never forcing main. Encoding them turns ADR-FLOW-GIT from prose into the one path the VS Code
tasks offer, and the reading command makes the sync point and its fallback visible without changing anything.

## Decided

- **Command names: `Get-SyncPoint`, `Sync-Topic`, `Save-Topic`, `Push-Topic`.** `Save-Topic` carries the commit semantics, because `Commit`
  is not an approved PowerShell verb and `PSUseApprovedVerbs` rejects it.
- **`Push-Topic` replaces `Push-Dirty`** (ADR-PRIN-ONELIVE-ONEVERSION): it saves pending changes, squashes, rebases onto the current server
  HEAD, squashes again and pushes. `Push-Dirty`, its test, its reference page and its VS Code task are deleted in the same change.
- **The sync point is read, never fetched.** `Get-SyncPoint` asks the server with `git ls-remote`, so it changes no ref; `Sync-Topic`
  fetches and then calls it.
- **The BVT mark is configuration with the default `none`.** `pwsh/Catzc.Base.Git/configs/git.yml` declares how a BVT-verified server head
  is marked; with `none` every run falls back to the current server HEAD and announces it (ADR-FLOW-GIT-FALLBACKISANNOUNCED). The default
  lives on the config type (ADR-PRIN-CONFIG-DEFAULTDECLAREDONCE).
- **The workspace variant decides the push target.** `Test-GitWorkspace -MainViaPr` true: the topic is pushed to its own branch with
  `--force-with-lease`, and main/master is refused. `main-direct`: the one squashed commit fast-pushes to main, and a rejected push stops
  (ADR-FLOW-CD-LIFE-FASTPUSHLANDS).
- **A conflict stops the command and leaves the rebase to the user.** The command reports the conflicting files and the git command that
  continues or aborts; it never resolves, skips or aborts on its own.

## Open steps

- [ ] `pwsh/Catzc.Base.Git/types/GitFlowConfig.cs`: the config type for `git.yml` (`remote` default `origin`, `main_branches` default
      `[main, master]`, `bvt_mark` default `none`), rejecting an unknown key and an unknown mark kind. (check: an L0
      `tests/types/GitFlowConfig.Tests.ps1` covers the defaults, a stated value and each rejection, and passes)
- [ ] `pwsh/Catzc.Base.Git/configs/git.yml`: the shipped config, stating only what deviates from the type's defaults. (check:
      `Get-Config     -Config git` loads it, and `Test-ConfigDefaults` passes)
- [ ] `pwsh/Catzc.Base.Git/Get-SyncPoint.ps1`: resolves the sync point read-only, the BVT-verified server head when `bvt_mark` names one,
      else the current server HEAD of the first main branch the server has, with a warning naming the commit and the missing mark; returns
      the commit, its source (`bvt` or `fallback`) and the branch. (check: L0 `tests/Get-SyncPoint.Tests.ps1` with `Invoke-Executable`
      mocked covers both sources and the warning, and passes)
- [ ] `pwsh/Catzc.Base.Git/Save-Topic.ps1`: stages every change and commits it with the message, `...` when empty, on a named branch;
      refuses a detached HEAD and main/master in `main-via-pr`; does nothing on a clean tree. (check: L0 `tests/Save-Topic.Tests.ps1` covers
      each refusal, the default message and the clean tree, and passes)
- [ ] `pwsh/Catzc.Base.Git/Sync-Topic.ps1`: fetches, takes the sync point from `Get-SyncPoint`, and rebases the topic onto it; refuses a
      dirty tree (save first), a detached HEAD and main/master; on conflict stops with the files and the continue/abort commands. (check: L0
      `tests/Sync-Topic.Tests.ps1` covers each refusal, the rebase onto the resolved commit and the conflict report, and passes)
- [ ] `pwsh/Catzc.Base.Git/Push-Topic.ps1`: `Save-Topic`, squash to one commit over the merge base, rebase onto the current server HEAD,
      squash again, assert exactly one commit ahead and none behind, then push by the workspace variant; a rejected push stops and keeps the
      commit. (check: L0 `tests/Push-Topic.Tests.ps1` covers the step order, both variants, the one-ahead assertion and the rejection, and
      passes)
- [ ] `pwsh/Catzc.Base.Git/tests/Git.Flow.Tests.ps1`: the L1 flow over a scratch bare server and clone in `$TestDrive`: the fallback
      warning, a sync that rebases onto new server work, a conflict that stops, a three-commit topic that lands as one commit, a rejected
      push, and the `main-via-pr` refusal on main. (check: the file passes under `Test-Automation -Path` at `-Level 1` and touches no
      repository outside `$TestDrive`)
- [ ] `pwsh/Catzc.Base.Git/Push-Dirty.ps1`: delete it with `tests/Push-Dirty.Tests.ps1` and
      `docs/references/pwsh/catzc-base-git/Push-Dirty.ps1.md`. (check: `Grep Push-Dirty` outside `out/` and `.unordered/` finds nothing)
- [ ] `pwsh/Catzc.Base.VSCode/configs/vscode-tasks.yml`: replace the `Push dirty` task with `Sync`, `Save` and `Push` tasks that invoke the
      three commands, the save and push tasks prompting for the message. (check: `New-VsCodeTasks` renders `.vscode/tasks.json` with the
      three tasks, and the VS Code config tests pass)
- [ ] `.claude/hooks/Assert-BashTimeout/Program.cs`: deny an agent's Bash call that invokes `Sync-Topic`, `Save-Topic` or `Push-Topic`,
      naming ADR-FLOW-GIT-USERRUNSGIT, with the command list read from `git.yml` rather than written in the hook. (check: the hook's tests
      cover a denied call and an allowed `Get-SyncPoint` call, and `Build-AgentHook` publishes it)
- [ ] `pwsh/Catzc.Base.Git/README.md` and the comment pages of the four commands: their help, citing ADR-FLOW-GIT. (check: `Test-Formatting`
      and `Test-Links` pass over `pwsh/Catzc.Base.Git` and `docs/references/pwsh/catzc-base-git`)

## Refs

- [git-topic-flow](../../docs/adr/flow/git-topic-flow.md) — the rules these commands carry out.
- [commit-lifecycle](../../docs/adr/flow/commit-lifecycle.md) — the fast push in `main-direct` and the sync from the verified head.
