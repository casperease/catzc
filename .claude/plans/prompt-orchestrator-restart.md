---
prompt:
  for: the orchestrator session after a restart
  written: 2026-10-22
  plan: plan-master
---

# Prompt: restart as the orchestrator of the live worker sessions

You are the orchestrator of this repository's worker sessions (`.claude/agents/implementation-orchestrator.md` is your definition; load
`plans-orchestrate`). Read `.claude/CLAUDE.md`, then `docs/drs/index.md`. Workers may already be live and will message you.

1. Run `Test-Plans` through `pwsh/.internal/assets/Invoke-CatzcCommand.ps1` in the background; fix any finding in the plans first.
2. Read `.claude/plans/plan-master.md`; its open chunks are the work. The agent-doable ones at 05:10 on 2026-10-22:
   plan-debt-build-artifact-cause (one test-file step), plan-debt-test-speed's report (catzc-e9 writing it), plan-debt-agent-traffic's
   lock-wait step (a burst outlasts a waiter's 120 s). Everything else waits on the user (`task-user-runs-and-commits.md`): the VSCode case
   rename, the dense-yaml pilot commit and its 175-declarations question, the `catzc-drone.md` line, the hook registration.
3. Read the last 40 lines of `out/orchestrator-2026-10-22.log` for who held what.
4. `ListAgents`, then ask each live session "what are you working on?" once. Brief a free one as
   `<plan> step <n>; owns <files>; check <check>`; a reply comes as `<step> PASS|RED|BLOCKED: <line>`.
5. Runs need no turns: `Invoke-CatzcCommand.ps1` takes the machine lock `Local\catzc-run` before the import, waits up to 120 s, and exits 1
   when a test file is red. An import-path burst runs under `Enter-CatzcBurst.ps1` / `Exit-CatzcBurst.ps1` (`catzc-verify` names them), no
   HOLD or GO messages; a run queued behind a long burst exits "run lock busy", so rerun it after the worker's "burst done".
6. Decide a session's small questions yourself and record them as delegated in the owning plan; ask the user only what is theirs (a rule, a
   removed key, git, `.claude/settings.json`, `CLAUDE.md`), recommendation first. Strike a step only on its verdict line;
   `Format-Code -Path` on the plans touched, then `Test-Plans`, after each batch of plan edits.
7. Never `git` mutations, never `-Language markdown`, never a session's own `out/*.ps1` for a cats command.
