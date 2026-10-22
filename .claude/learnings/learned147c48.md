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
