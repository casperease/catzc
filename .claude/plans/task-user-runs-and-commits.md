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
5. Cut `.claude/CLAUDE.md`, section Sub-agents, to the agent names and one clause each, and in the same edit name
   `docs/references/pwsh/index.md` on the `docs/references/` line as where a design round starts (plan-claude-diet.md steps 1-2). Check:
   `Test-AgentDefinitions` passes and `wc -c .claude/CLAUDE.md` is at most 11900.
6. Commit the two BCL folder moves (plan-bcl-language.md): `docs/references/BCL/` and `docs/how-to/getting-started/BCL/` added, the old
   `docs/references/pwsh/BCL/` and `docs/how-to/getting-started/pwsh/BCL/` deleted; with them the sample folder
   `docs/adr/automation/BCL/.assets/bcl-language/`, the new `docs/adr/automation/BCL/dora-explains.md`, and the `ADR-BCL-TYPES` re-cite
   across 299 files. Check: `Test-Links` on both folders reports no `[Untracked]` issue.
7. Commit the bicepparam change (plan-bicepparam, done and deleted): the six foundation slots `nsub`, `psub`, `apex/nsub`, `apex/psub`,
   `flux/nsub`, `nova/nsub` under `infrastructure/templates/foundation/configuration/` replaced `.yml` by `.bicepparam` at the same path,
   with the renderer, discovery, build and their tests. Check: `Invoke-TestFile` on `Build-Bicep.Integrity.Tests.ps1` passes.
8. Commit the idiomatic-names acronym renames (plan-idiomatic-names): they are case-only and `core.ignorecase` is true, so each file (the
   `.ps1`, its `.Tests.ps1`, its `docs/references` page) lands by `git mv` from the old spelling. The old spellings, each with its
   `tests/<name>.Tests.ps1` and `docs/references/pwsh/<module-page>/[tests/]<name>...md`: `Catzc.Base.TypesSystem/Invoke-BuildForVSCode`,
   `Catzc.Base.Environment/assets/Set-LocalPSModulePath`, `Catzc.Base.QualityGates/private/Invoke-PSScriptAnalyzerFormat`,
   `Catzc.Tooling.KeyHandler/{Import,Save}-PSReadLineKeyHandlerSet`, `Catzc.Base.VSCode/{Build,Install}-VSCodeExtension`,
   `Catzc.Base.VSCode/private/New-VSCodeExtensionFolder`, `Catzc.Base.VSCode/New-VSCode{Tasks,Settings,Launch,Extensions,PipelineSchema}`,
   `Catzc.Base.Asserts/Assert-IsRunningInVSCode`, and `pwsh/.internal/tests/Test-IsRunningInVSCode.Tests.ps1`. Check: `git ls-files` lists
   no old spelling, and the L1 round trip in `ConvertTo-NormalName.Tests.ps1` passes.
9. Commit the contracts normal form (plan-idiomatic-names). Re-stage the whole working tree first: the index holds stale partial copies
   (`MM` on `Get-CommandContract.ps1` and five private readers; `AD` on `ConvertTo-NormalFormContract.ps1` and its tests, deleted on disk).
   Under `contracts/catzc/0.0.0/`, `git mv` each module folder to its normal form, the case-only ones in two moves via a temporary name:
   `Catzc.Azure`, `Catzc.Azure.Templates`, `Catzc.Base.{Contracts,Docs,Flow,Globs,Languages,Maps,Repository}` and
   `Catzc.Tooling.{Github,Inspiration,Node,Provisioning,Python,Toolchain}` to lower case; `Catzc.Azure.DevOps` to `catzc.azure.dev_ops`,
   `Catzc.Azure.DevOps.BuildValidation` to `catzc.azure.dev_ops.build_validation`, `Catzc.Base.ConfigExtensions` to
   `catzc.base.config_extensions`, `Catzc.Base.ModuleSystem` to `catzc.base.module_system`, `Catzc.Base.QualityGates` to
   `catzc.base.quality_gates`, `Catzc.Base.RootConfig` to `catzc.base.root_config`, `Catzc.Base.TypesSystem` to `catzc.base.types_system`.
   Inside them the 112 `Verb-Noun.command.yml` files are `verb_noun.command.yml`. Check: `git ls-files contracts` lists no `Catzc.` folder
   and `Test-Contracts` reports 0.
10. Commit the git topic commands (plan-git-topic-commands, done and deleted; the hook's deny now matches an invocation only):
    `pwsh/Catzc.Base.Git` (GitFlowConfig, `git.yml`, `Get-SyncPoint`, `Save-Topic`, `Sync-Topic`, `Push-Topic`, the L1 flow test), the VS
    Code tasks, the `Assert-BashTimeout` deny, and the deletion of `Push-Dirty.ps1`, its test and its page. Check: `Invoke-TestFile` on
    `pwsh/Catzc.Base.Git/tests/Push-Topic.Flow.Tests.ps1` passes.
11. Edit `.claude/CLAUDE.md`, section Project structure: one line saying the `types/*.cs` files are written in BCL, a subset of .NET, hosted
    by pwsh (plan-bcl-language.md, the CLAUDE.md step). Check: `Test-AgentDefinitions` passes.
12. The live proof of the Language bridge's setup-error step (plan-test-signal-proposals, done and deleted): run
    `Test-Automation -Modules Catzc.Base.Repository` once with a temporary lint-failing `test_probe.py` (an unused import) in that module's
    Python test folder, check that every Python case fails with the ruff message instead of "a setup in some parent block failed", then
    delete the probe file. Check: the run's case messages.
13. Commit the kebab reference-page renames (plan-idiomatic-names): `{kebab}` now renders through `NameCase`, so the pages of 12 modules
    moved on disk under `docs/references/pwsh/` (`catzc-base-qualitygates` to `catzc-base-quality-gates`, `-modulesystem` to
    `-module-system`, `-codemeta`, `-typessystem`, `-vscode` to `-vs-code`, `-rootconfig`, `-markdownmeta`, `-configextensions`,
    `catzc-tooling-keyhandler`, `catzc-azure-devops` to `catzc-azure-dev-ops` and its `-build-validation`, and
    `internal/catzc-internal-testkit` to `catzc-internal-test-kit`; 581 files, folder and module page each), with the `docs:` head edges of
    605 files, the four renderers and the hand links. Check: `Test-Links` reports no `[Untracked]` issue under `docs/references/pwsh`.
14. The final full run, in a fresh session, when the chunks in plan-master have landed. Once it is green and committed, the work is done and
    every plan, task and prompt in `.claude/plans` is deleted (the user, 2026-10-20). Check: `.claude/plans` is empty.

## Report

As report-fixed: which steps the user reported done, with each verdict line.
