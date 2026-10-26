---
task:
  status: open
  plans: [plan-master]
  value: highest
  blocked_on: nothing; every step is the user's own git operation, edit, run or eye check, and the last is the final session's full run
  targets: [.claude/plans, out, docs]
---

# Task: the user's git steps, one commit, and the one final full run

<!-- cspell:ignore adronly -->

Every step here is one the user does by hand, because agents never run mutating git, never edit `.claude/CLAUDE.md` or
`.claude/settings.json`, and never run all tests (ADR-REPO-AI; `.claude/CLAUDE.md`, No mutating git operations). A check is one test file
under `Invoke-TestFile`, one gate on named paths, a grep or a file read. The one full-repository proof is the last step. The typed DLL under
`pwsh/.compiled` is ignored by every step.

## Steps

1. Review `out/user/CLAUDE.md.diff` and copy `out/user/CLAUDE.md.proposed` over `.claude/CLAUDE.md`. It is the CLAUDE.md edits in one: the
   `.unordered/` line's "nothing internal reads", the BCL line for `types/*.cs`, `docs/references/pwsh/index.md` as where a design round
   starts, `## DRS` and the "domain rules / DRS rules" pair, the Sub-agents list cut to one clause each, the Time safeguard section pointing
   at `catzc-run` (Grep and Read as the probes, absolute paths, the hook's git-topic deny), and `Invoke-CatzcCommand.ps1` in the "Run
   PowerShell yourself" rule. Check: `Test-AgentDefinitions` passes, `Test-Links -Path .claude/CLAUDE.md` passes, and
   `wc -c .claude/CLAUDE.md` is at most 11900.
2. plan-debt-agent-traffic: add the `catzc-drone` line the plan quotes to `.claude/agents/catzc-drone.md` (a drone's permission mode refused
   it as self-modification), and register the `Record-SessionMessage` hook in `.claude/settings.json` (a PostToolUse entry matching
   `SendMessage`, and a UserPromptSubmit entry). Check: `Test-AgentDefinitions`, and one message sent between sessions appears in
   `out/orchestrator-<date>.log`.
3. Commit the working tree, one commit. Before it, `git status --short` lists only paths the plans name, with no `??` under `out/` and no
   `pwsh/.compiled`. After it:
   - `Invoke-TestFile` passes on `pwsh/Base.Slides/tests/Build-Diagrams.Tests.ps1`,
     `pwsh/Azure.Templates/tests/Build-Bicep.Integrity.Tests.ps1`, `pwsh/Base.Git/tests/Push-Topic.Flow.Tests.ps1` and
     `pwsh/Base.QualityGates/tests/Format-Code.Tests.ps1`;
   - `Test-Links` reports no `[Untracked]` issue (the BCL folders, the kebab reference pages, the flat diagram files);
   - `git status` showed the moves under `docs/` as renames, not delete and add pairs;
   - `git ls-files` lists no old case spelling, no `Catzc.` folder under `contracts`, and nothing matching `egg-info|__pycache__` or
     `pwsh/.compiled`;
   - `Test-Contracts` and `Test-BuildArtifact -Facet Types` report no issues;
   - `Test-Formatting` lists no function help hand edit outside Base.Contracts;
   - `Test-Diagrams` reports no issues: the commit carries the two query diagrams re-rendered after the track renames
     (`docs/explanation/model/.assets/zoom-internal-c4.drawio.png`, `docs/explanation/model/.assets/zoom-pwsh-c3.drawio.png`);
   - `Invoke-TestFile -Path pwsh/Base.ModuleSystem/tests/Test-FunctionDependency.Tests.ps1` passes: the commit carries the one-character fix
     at `pwsh/Tooling.Toolchain/private/Install-UvStandalone.ps1:57` (`Get-ChildPath $extractDirectory`).
4. plan-reference-normal-form step 3: move every reference page to its derived path. First ask catzc-2b, the step's keeper, to refresh
   `out/ns5/ref-map.csv` from the committed tree (`out/ns5/New-ReferencePageMap.ps1`). Then run
   `pwsh -NoProfile -File out/ns5/Rename-ReferencePages.ps1 -WhatIf`, then the same without `-WhatIf`, and tell the orchestrator. Check: the
   `-WhatIf` lists each page once and refuses nothing, and after the run `git status --short docs/references` shows only renames.
5. plan-types-build-local step 9: one ci-pwsh pipeline run once `cache-types.yaml` lands. Check: the second run of a job restores the types
   cache (Cache@2 "Cache restored") and skips the DLL build.
6. plan-vscode-extensions: rebuild and install the two new extensions (`Build-VsCodeExtension`, then `Install-VsCodeExtension`), reload VS
   Code, click a `/docs/drs/` link in a markdown file and open a coloured `out/**/*.log`. Check: the link opens its ADR and the log shows
   colours, not escape codes. In the same reload (plan-language-lamps step 5): rebuild and install `catzc-track-lamps`, press the languages
   button, tick two languages, put one out, veto the other, untick both. Check: each lamp appears, lights, vetoes and disappears with no
   reload.
7. The final full run, in a fresh session, when the chunks in plan-master have landed. Once it is green and committed, the work is done and
   every plan, task and prompt in `.claude/plans` is deleted (the user, 2026-10-20). Check: `.claude/plans` is empty.

## Report

As report-fixed: which steps the user reported done, with each verdict line.
