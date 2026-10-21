# Hindsight 031350

Started 2026-10-22T01:04:04.9915901+02:00.

- 2026-10-22 Jack: If only a how-to had pointed at the shape: docs/drs/repository/command-contracts.md declares the command contract, yet no
  how-to under docs/how-to/ names a command.yml, so the one sample worth reading is found by whoever already knows it.
- 2026-10-22 Jack: If only the session had read the generator article:
  docs/references/pwsh/catzc-base-contracts/New-CatsCommandLookup.ps1.md:14 says Build-RootConfig writes the lookup, and
  docs/references/pwsh/internal/index.md:19 says every janitor reads its source on every load, so the contract readers were on the import
  path by declaration.
- 2026-10-22 Jack: If only the session had read the private article:
  docs/references/pwsh/catzc-base-contracts/private/Get-ContractAssetKind.ps1.md:10 already says it picks a kind from the file name alone,
  so a renamed asset turning into a fragment was written down before it happened.
- 2026-10-22 Jack: If only the session had read past IsInCase: pwsh/Catzc.Base.Objects/types/NameCase.cs:53-54 already offers IsNormal,
  which splits a dotted name and checks every segment, so the hand-rolled segment loop was a method nobody called.
- 2026-10-22 Jack: If only the config page said what keys it: docs/references/pwsh/catzc-base-contracts/configs/contracts.yml.md:37-39
  declares target_roots per owning module, but never that the key is the folder in the normal form, so a unit that keeps its source names,
  EXTERNAL-azure, is looked up by trial.
- 2026-10-22 Jack: If only the types article warned the formatter: docs/references/pwsh/internal/catzc-internal-types.md:3-5 keys the DLL on
  a hash of every types/*.cs, so a Format-Code that touches a C# file moves the key, yet no capability says the gate after it needs a fresh
  import.
- 2026-10-22 Jack: If only the session had counted from the article:
  docs/references/pwsh/catzc-base-contracts/New-CatsCommandLookup.ps1.md:15-17 lists the fields of a lookup line, command, parameter, type,
  list, mandatory, pipeline and asset, so the article, not the learning, holds the row and its count.
- 2026-10-22 Jack: If only the staging script had never been written: .claude/skills/catzc-run/SKILL.md:17-18 already runs every cats
  command as one quoted argument through Invoke-CatzcCommand.ps1 in one process with one import, and forbids an out/*.ps1 of one own making.
- 2026-10-22 Jack: If only the session had read the parameter it relied on:
  docs/references/pwsh/catzc-base-execution/Invoke-Executable.ps1.md:78-80 already says WorkingDirectory defaults to the repository root and
  callers pass it rather than rely on the current folder, so a Push-Location into a scratch clone was always ignored.
- 2026-10-22 Jack: If only someone had made the instant check a command: nothing in the tree, no command, capability or how-to, parse-checks
  a module ps1 or a yml on the import path before the next import, so one stray colon in a string still breaks every session first.
- 2026-10-22 Jack: If only the session had read the hook before quoting the command: .claude/hooks/Assert-BashTimeout/Program.cs:68-79
  denies any call naming a git topic user command from GitFlowConfig, whose default at pwsh/Catzc.Base.Git/types/GitFlowConfig.cs:36 is
  Sync-Topic, Save-Topic and Push-Topic, heredoc or not.
- 2026-10-22 Jack: If only someone had written down how to feed a hook: nothing in the tree, no how-to under docs/how-to/ and no capability,
  says a hook payload is tested from a file redirected into the exe, so Git Bash echo keeps eating the JSON backslashes.
- 2026-10-22 Jack: If only the session had read the error it got: pwsh/Catzc.Base.Execution/types/CliRunner.cs:184 already says the command
  exited but a process it started still holds its output open, and its test at Invoke-Executable.Tests.ps1:329 pins the
  --disable-build-servers hint, so the rerun was the second-best cure.
- 2026-10-22 Jack: If only the session had read what the gate promises:
  docs/references/pwsh/catzc-base-quality-gates/Test-Formatting.ps1.md:17 makes every file an engine would change one issue, so a module
  still waiting for its re-format can prove nothing about one new file until Format-Code has run over it.
- 2026-10-22 Jack: If only the session had read the gate article:
  docs/references/pwsh/catzc-base-quality-gates/Test-ManualTestPlan.ps1.md:16-21 already says it finds every integrity-tagged Describe and
  that a block is identified by the pair of file and block name, so a renamed block takes its row with it.
- 2026-10-22 Jack: If only the mover obeyed the contract: docs/references/pwsh/catzc-base-slides/Move-Diagram.ps1.md:10-18 moves only a
  tracked source and stages it with git mv, while docs/drs/repository/ai-agent-contract.md:28 (ADR-REPO-AI-NEVERMUTATEGIT) forbids an agent
  that very mv, so the one mover is the one tool a session may not use.
- 2026-10-22 Jack: If only the article had named the attribute: docs/references/pwsh/catzc-base-slides/private/Get-SlideFinding.ps1.md:16-17
  says every text of every field must be found in the rendered section, but not that a field rendered into an attribute is found among
  attribute values, so an image src fails until someone reads the code.
- 2026-10-22 Jack: If only the session had read the types ADR: docs/drs/automation/BCL/native-csharp-types.md:46 already says a loaded
  assembly cannot be swapped in a running process, so a renamed config key was always an error until a fresh pwsh.
- 2026-10-22 Jack: If only the session had renamed with the command: docs/references/pwsh/catzc-base-files/Rename-CodeName.ps1.md:16-18
  replaces whole tokens longest first and renames WidgetConfig inside a bracketed full type name, so a half-renamed type prefix is what the
  hand edit produces and the command does not.
- 2026-10-22 Jack: If only the session had read the hook project: .claude/hooks/Assert-BashTimeout/Assert-BashTimeout.csproj:37 links
  TimeoutsConfig.cs, and its head at :2-3 says Build-AgentHook republishes the hook whenever a linked source changes, so the type-first
  order was declared in the build.
- 2026-10-22 Jack: If only the session had read the comments ADR: docs/drs/repository/comments-in-docs.md:64 already puts a function help in
  the comment page under its help section (ADR-REPO-HELP-HELPONCOMMENTPAGE), so inline help was always the shape Format-Code moves out.
- 2026-10-22 Jack: If only the session had read the parameter: docs/references/pwsh/catzc-base-quality-gates/Invoke-TestFile.ps1.md:43-45
  already says Path takes the test files to run, absolute or root-relative, so a tests folder was never an answer it promised to accept.
- 2026-10-22 Jack: If only the session had read the rename article: docs/references/pwsh/catzc-base-files/Rename-CodeName.ps1.md:16-17
  replaces a name only where it stands as a whole token, never after a letter, digit, underscore or hyphen, so a prefixed id such as g-name
  was declared out of reach before the rows said Skipped.
- 2026-10-22 Jack: If only the session had read the same article to the end: docs/references/pwsh/catzc-base-files/Rename-CodeName.ps1.md:15
  reads only what Get-GitTrackedPath lists and :20-21 leave binaries and tracked files deleted from the tree alone and move no file, so the
  rename runs before the move, by declaration.
- 2026-10-22 Jack: If only Jack had counted columns too: importer.sh:86-99 reads columns 10, 11 and 13 of a lookup row, so the learning of
  13 columns was right, and docs/references/pwsh/catzc-base-contracts/New-CatsCommandLookup.ps1.md:15-17, listing seven fields, is the stale
  half that an earlier line of this log trusted.
- 2026-10-22 Jack: If only the session had read the contracts ADR: docs/drs/repository/command-contracts.md:24 already closes the output
  type set, so a command returning pscustomobject needs a typed result before it can be contracted, by rule.
- 2026-10-22 Jack: If only importer.sh knew lists: the lookup carries a list flag per parameter (New-CatsCommandLookup.ps1.md:16-17), yet
  importer.sh:98-100 passes only switch, int, bool and single values, so a list parameter is the one variant cats cannot call.
- 2026-10-22 Jack: If only the session had read the gate article before calling it:
  docs/references/pwsh/catzc-base-quality-gates/Invoke-TestFile.ps1.md:38-40 already says the opt-in L4 tests run only with -MaxLevel 4, and
  every gate article lists its parameter sets the same way, so the failed call was a page unread.
- 2026-10-22 Jack: If only the session had read the example: docs/references/pwsh/catzc-base-languages/Invoke-PythonTest.ps1.md:71 documents
  -Folder and :97 shows Invoke-PythonTest Catzc.Base.Slides -Folder python/catzc_diagrams/tests, the very call the learning rediscovered.
- 2026-10-22 Jack: If only the session had read the minimap writer:
  docs/references/pwsh/catzc-base-slides/private/Write-DiagramMinimapData.ps1.md:11 computes each minimap from the ADR codes and :21 drops
  and reports any lit cell nobody declared, so content.minimaps choosing the maps was declared in the writer.
