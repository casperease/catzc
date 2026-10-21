---
task:
  status: open
  plans: [plan-master]
  value: highest
  blocked_on: nothing; every step is the user's own commit, git operation or command, and the last is the final session's full run
  targets: [.claude/plans, out, docs]
---

# Task: the user's commits, git operations, and the one final full run

Every step here is one the user does by hand, because agents never run mutating git and never run all tests (ADR-REPO-AI;
`.claude/CLAUDE.md`, No mutating git operations). A check is one test file under `Invoke-TestFile`, one gate on named paths, a grep or a
file read. The one full-repo proof is the last step, a final new session that dot-sources `importer.ps1` and runs `Test-Automation` once
over the whole repository. The typed DLL under `pwsh/.compiled` is ignored by every step. Order: the commits and git operations first, the
final full run last.

## Steps

1. Commit `pwsh/Catzc.Base.Slides/Build-Diagrams.ps1`: one `Write-Message` line per folder for the minimap, render and sync stages, and the
   total time on the closing line. Check: `Invoke-TestFile pwsh/Catzc.Base.Slides/tests/Build-Diagrams.Tests.ps1` passes.
2. Edit `.claude/CLAUDE.md:26` to read "nothing internal reads or defaults to the track" (plan-listen-internal-readers.md). Check:
   `Test-AgentDefinitions` passes.
3. Edit `.claude/CLAUDE.md`, the "Run PowerShell yourself" rule, to name
   `timeout <s> pwsh -NoProfile -File pwsh/.internal/assets/Invoke-CatzcCommand.ps1 "<cmd>"` in place of
   `pwsh -NoProfile -Command ". ./importer.ps1; <cmd>"` (plan-agent-shortcuts.md step 5). Check: `Test-AgentDefinitions` passes.
4. Stage the idiomatic-names moves (`python/tests/catzc_base_repository/`, `go/tests/catzcbaserepository/`, and later
   `python/catzc_diagrams/`): `Test-IdiomaticNames` reads the git index, so plan-idiomatic-names' gate-on step waits on it. Check:
   `Test-IdiomaticNames` no longer lists the old folders.
5. Cut `.claude/CLAUDE.md`, section Sub-agents, to the agent names and one clause each (plan-claude-diet.md step 1). Check:
   `Test-AgentDefinitions` passes and `wc -c .claude/CLAUDE.md` is at most 11900.
6. Commit the two BCL folder moves (plan-bcl-language.md): `docs/references/BCL/` and `docs/how-to/getting-started/BCL/` added, the old
   `docs/references/pwsh/BCL/` and `docs/how-to/getting-started/pwsh/BCL/` deleted. Check: `Test-Links` on both folders reports no
   `[Untracked]` issue.
7. Edit `.claude/CLAUDE.md`, section Project structure: one line saying the `types/*.cs` files are written in BCL, a subset of .NET, hosted
   by pwsh (plan-bcl-language.md, the CLAUDE.md step). Check: `Test-AgentDefinitions` passes.
8. The final full run, in a fresh session, when the chunks in plan-master have landed. Once it is green and committed, the work is done and
   every plan, task and prompt in `.claude/plans` is deleted (the user, 2026-10-20). Check: `.claude/plans` is empty.

## Report

As report-fixed: which steps the user reported done, with each verdict line.
