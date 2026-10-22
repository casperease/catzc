# Session learnings 147c48

Started 2026-10-22T09:08:25.1759302+02:00.

- 2026-10-22 Cats: Token tip: run the fast L0 test files inside a burst and the whole-repository L2 tiers one per call after it lands, so a
  burst never nears its time limit.
- 2026-10-22 Cats: In hindsight I wish I knew this fact: Build-AgentHook publishes into the hook's shared obj/ and bin/ in the tree, so
  Build-AgentHook.Tests races every fresh import and the live hooks, and Invoke-TestFile shows a failed BeforeAll only as an empty setup
  failure.
- 2026-10-22 Cats: In hindsight I wish I knew this fact: Import-CSharpTypes.Tests is red whenever pwsh/.compiled holds an uncommitted
  rebuilt DLL, so every C# burst leaves it out until the user commits.
- 2026-10-22 Cats: In hindsight I wish I knew this fact: Test-Plans rejects a check that names any Verb-Noun no module exports, internal
  Invoke-CatzcCommand included, so a check names test files and exported commands only.
- 2026-10-22 Cats: Token tip: Next time, save tokens by: running one Format-Code + Test-Plans per round over every plan touched, not one per
  edit, since each waits on the run lock behind drone bursts.
- 2026-10-22 Cats: Token tip: Next time, save tokens by: answering a drone only when it asks or a sequence changes; logging a no-question
  report needs no reply.
- 2026-10-22 Cats: In hindsight I wish I knew this fact: cspell reads a PowerShell or Python escape (backtick-n, backslash-n) as part of the
  next word, so a string like a backtick-n before namespace is flagged as an unknown word.
- 2026-10-22 Cats: In hindsight I wish I knew this fact: a pipeline that only prints an issue count, such as (Test-Spelling
  -PassThru).Issues.Count, passes under Invoke-CatzcCommand whatever the count; only the gate itself fails the call.
- 2026-10-22 Cats: In hindsight I wish I knew this fact: a plan file name is spell-checked wherever it is cited (plan-master.md,
  value-of-plan.md), so a plan name takes dictionary words only.
- 2026-10-22 Cats: Token tip: Next time, save tokens by: calling the gate itself (Test-Spelling -Path ...) inside Invoke-CatzcCommand rather
  than printing its count, so a red fails the call and is never misread.
- 2026-10-22 Cats: In hindsight I wish I knew this fact: Build-AgentHook.Tests goes red not from a file race but because dotnet publish
  leaves an MSBuild node or compiler server holding the redirected stdout open, so Invoke-Executable never sees the output end;
  -nodeReuse:false -p:UseSharedCompilation=false stops it (this corrects the earlier race line).
- 2026-10-22 Cats: In hindsight I wish I knew this fact: per ADR-AUTO-SPELL-ONEVOCABULARYSOURCE a new known word goes into terminology.yml,
  never into the cspell config.
- 2026-10-22 Cats: Every pwsh death in VS Code today was a window reload: main.log says received terminate message from renderer with exit
  code 0, and the PowerShell extension log then says terminated or Extension Terminal was closed; neither is a crash.
- 2026-10-22 Cats: Get-CombinedTypeHash strips each type source's generated head before hashing, so any second copy of the algorithm (the
  csproj task, the compiled-info extension) calls every build stale.
- 2026-10-22 Cats: The type-cache janitor used to stop any process holding a superseded types DLL at every person's first prompt; a session
  bound to an earlier instance is a fact now, never a target (ADR-PWSH-TYPES-ONEINSTANCEPERSESSION).
- 2026-10-22 Cats: A BCL ADR may not cite a pwsh rule: the citation graph lets pwsh depend on bcl only, so a BCL sentence stands on its own
  rule.
- 2026-10-22 Cats: Formatting a new C# type after the run's import leaves the analyzer's spelling pass without the current assembly;
  Format-Types first, then a fresh import.
- 2026-10-22 Cats: The extension-host pwsh is headless to the importer (its command line has -Command without -NoExit), so its janitors run
  inline at import, not at the first prompt.
- 2026-10-22 Cats: The orchestrator session's inbox can be full; a HOLD or RELEASE to it is then dropped, and the notice arrives later.
- 2026-10-22 Cats: Token tip: read the heads of a log before grepping its tail; the extension-host activation list answers the
  terminal-environment question in one read.
- 2026-10-22 Cats: Token tip: name the gate set once in one Invoke-CatzcCommand run instead of one run per gate; the run lock serialises
  them anyway.
- 2026-10-22 Cats: In hindsight I wish I knew this fact: the test tag gate accepts only logic or integrity as a category; integration is not
  one, and a Context with no category leaves every It below it untagged.
- 2026-10-22 Cats: In hindsight I wish I knew this fact: an -Isolated run tests the git index, so the uncommitted case-only acronym renames
  (task-user-runs-and-commits item 8) fail the normal-name round trip until the user git mvs them.
- 2026-10-22 Cats: In hindsight I wish I knew this fact: Test-Automation scopes a run with -Modules, not -Path.
- 2026-10-22 Cats: Token tip: Next time, save tokens by: grepping .claude/plans for a failing test name before proposing a fix, since the
  plans may already hold the cause.
