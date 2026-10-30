# Session learnings

Started 2026-10-30T12:08:26.6530558+01:00.

- 2026-10-30 Cats: In hindsight I wish I knew this fact: the track lamps judge a marker by its file time against the module files, so a
  failure lapses only on an edit or a passing Invoke-TestFile.
- 2026-10-30 Cats: In hindsight I wish I knew this fact: a run scoped by tier, category, rule or name filter cannot prove a whole test file
  green.
- 2026-10-30 Cats: In hindsight I wish I knew this fact: Test-Plans rejects a check that names a private function, since no module exports
  it.
- 2026-10-30 Cats: Token tip: Next time, save tokens by: waiting on a background cats call by its completion notification alone, never a
  tail waiter.
- 2026-10-30 Cats: Get-TestRunOutcome runs over every file and row of a full run (about 1,150 files, 11,000 rows): a per-file filter over
  the rows stalls it, so failed rows are counted in one pass.
- 2026-10-30 Cats: Invoke-TestRun.Tests.ps1 feeds failed rows without a File property, so code over run rows reads File only where the
  property exists (strict mode).
- 2026-10-30 Cats: A new private function needs a comment page with a help section under docs/references/pwsh/\<module>/private/, or
  Test-Formatting fails.
- 2026-10-30 Cats: Measure-NoUnboundedEnumeration rejects SearchOption.AllDirectories and Get-ChildItem in code and tests alike;
  Get-ChildPath with -Depth is the one walker.
- 2026-10-30 Cats: The glossary rule allows only declared words before scope; stored scope fails Test-Glossary.
- 2026-10-30 Cats: A drone passing its named test files can still leave formatting, analyzer, help-page and glossary failures that only the
  full run shows.
- 2026-10-30 Cats: Token tip: brief a drone with the closing gates (Format-Code, Test-Formatting, Test-ScriptAnalyzer, Test-Glossary,
  Test-Terminology) on every touched path.
- 2026-10-30 Cats: Token tip: split a plan of more than four steps across two drones; one hit its 50-turn roof on seven.
- 2026-10-30 Cats: Token tip: read a failed run from the Failures section of its summary.md, not from pasted console output.
