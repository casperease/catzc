# Session learnings 78d9be

Started 2026-10-22T00:37:21.0823062+02:00.

- 2026-10-22 Cats: In hindsight I wish I knew this fact: a validation attribute such as ValidatePathGiven also runs when the function
  reassigns that parameter, so a computed default belongs in a local variable, never in $Path.
- 2026-10-22 Cats: In hindsight I wish I knew this fact: Rename-CodeName rewrites whole tokens only; a mapped name inside a longer token
  (g-\<name>) is listed as Skipped as line:token and never rewritten.
- 2026-10-22 Cats: In hindsight I wish I knew this fact: pwsh -File passes a comma-joined list as one string; a script taking a list is
  called with pwsh -Command "& ./script.ps1 -Target 'a','b'".
- 2026-10-22 Cats: In hindsight I wish I knew this fact: every diagram is .assets/\<name>.drawio.png plus .assets/\<name>.drawio.yml, or a
  yml drawio block directly above its image in the article when the kit drawio.yml carriers: map says article.
- 2026-10-22 Cats: In hindsight I wish I knew this fact: minimap citation sources exclude docs/**/.assets/**, so a diagram yml never lights
  its own minimap.
- 2026-10-22 Cats: In hindsight I wish I knew this fact: a tracked file deleted on disk stays in git ls-files until staged, so a tool
  reading ls-files checks that each path exists.
- 2026-10-22 Cats: In hindsight I wish I knew this fact: value-of-plan.md keeps one line per deleted plan under Pending deletion
  (ADR-REPO-PLANS-DONEPLANDELETED).
- 2026-10-22 Cats: Token tip: Next time, save tokens by: treating an idle notice older than the session's last reply as stale and asking
  nothing.
- 2026-10-22 Cats: Token tip: Next time, save tokens by: grepping a background run's output for its verdict line instead of reading its
  tail.
- 2026-10-22 Cats: In hindsight I wish I knew this fact: Rename-CodeName (Catzc.Base.Files) renames whole-token names in tracked files only,
  so a rename runs on the old tracked paths before the files move on disk.
- 2026-10-22 Cats: In hindsight I wish I knew this fact: a file-meta kind id derives its subscriber function name (kind drs-codes →
  Get-DrsCodesFileMetaFact), so renaming that function renames the kind in file-meta.yml in the same pass.
- 2026-10-22 Cats: In hindsight I wish I knew this fact: a PowerShell validation attribute such as ValidatePathGiven also runs when the
  function reassigns that parameter, so a computed default set goes into its own variable.
- 2026-10-22 Cats: In hindsight I wish I knew this fact: a private function is visible only inside its module, so a function moved to
  another module is public there when its old module still calls it.
- 2026-10-22 Cats: In hindsight I wish I knew this fact: Test-Links resolves a code head docs edge from the file folder and reports a broken
  one as Dangling, fixed by Format-FileMeta.
- 2026-10-22 Cats: In hindsight I wish I knew this fact: Get-NeutralCodeFinding skips only the -Tag text, so a real rule code in an L0 test
  body stays a finding even when the It carries it as a tag.
- 2026-10-22 Cats: In hindsight I wish I knew this fact: Invoke-TestFile -Path takes test file paths, not a tests folder.
- 2026-10-22 Cats: Token tip: Next time, save tokens by: running cats commands through Invoke-CatzcCommand.ps1 with one quoted argument per
  command instead of writing out/*.ps1 scripts.
- 2026-10-22 Cats: Token tip: Next time, save tokens by: inventorying with one background git grep script into out/ and one Get-CodeCaller
  pass, not repeated foreground greps that hit the 3 s roof.
- 2026-10-22 Cats: In hindsight I wish I knew this fact: the snapshot case of Invoke-TestFile.Tests.ps1 costs 30 to 39 s from
  New-RepositorySnapshot plus a priming import plus the worker import, the end-to-end path it proves, so the file has no fixable speed
  cause.
- 2026-10-22 Cats: In hindsight I wish I knew this fact: Test-Plans already reads a step count in digits (regex alternative \d+); only a
  number word above twelve escapes the check.
- 2026-10-22 Cats: In hindsight I wish I knew this fact: a new test file whose long leading comment Format-Code moves out (Export-Comments)
  gets its comment page created by the engine, so a page is never written by hand.
- 2026-10-22 Cats: In hindsight I wish I knew this fact: a new test file adds a test edge to its code file head, so the code file needs one
  Format-Code -Path re-imprint, a file the test author may not own.
- 2026-10-22 Cats: In hindsight I wish I knew this fact: there is no Test-DrsCodes; Test-DrsRegistry is the gate over the rule headings of
  docs/drs.
- 2026-10-22 Cats: In hindsight I wish I knew this fact: when Invoke-TestFile cannot prime its snapshot it throws before writing run.json
  and keeps the import output in out/test-snapshot-priming/.
- 2026-10-22 Cats: In hindsight I wish I knew this fact: Claude Code reaps a background shell under memory pressure, and the orchestrator
  then runs one heavy run machine-wide through its memory queue.
- 2026-10-22 Cats: Token tip: Next time, save tokens by: splitting a multi-area rules review over parallel drs-reviewer agents, one per ADR
  set, and checking only their findings.
- 2026-10-22 Cats: Token tip: Next time, save tokens by: writing a script that holds backslashes with the Write tool, since a bash heredoc
  collapses them, and grepping a run log for its verdict lines only.
- 2026-10-22 Cats: In hindsight I wish I knew this fact: the glossary G6 excludes every source shares are GlossaryOptions.DefaultExclude in
  C# (now .claude/plans, hindsight and learnings); a glossary.yml can only add its own options.exclude.
- 2026-10-22 Cats: In hindsight I wish I knew this fact: Test-Plans now fails a master chunk line or value-row state cell whose stated step
  count (three steps, one step left) differs from the plan open steps.
- 2026-10-22 Cats: In hindsight I wish I knew this fact: Invoke-PythonTest takes the pascal-dotted module name (Catzc.Diagrams) and finds
  the module own python/\<snake>/tests before the holder python/tests/\<snake>.
- 2026-10-22 Cats: In hindsight I wish I knew this fact: Get-SlideOrderFinding is the one deck order check (gap, duplicate), run by
  Build-SlideDeck and by Test-Slides for each folder read whole; Get-SlideFinding sees one slide only.
- 2026-10-22 Cats: In hindsight I wish I knew this fact: the importer runs Build-RootConfig -Silent on every load
  (Catzc.Internal.Importer.psm1:406), so pwsh/Catzc.Base.RootConfig/assets/root/* are import-path files.
- 2026-10-22 Cats: In hindsight I wish I knew this fact: PowerShell names are case-insensitive, so a scriptblock param named Where shadows
  an outer where, and a -match inside an if overwrites the Matches of the outer match.
- 2026-10-22 Cats: In hindsight I wish I knew this fact: a Pester Mock body does not see the It block locals, so a mocked value is written
  as a literal.
- 2026-10-22 Cats: In hindsight I wish I knew this fact: ValidatePattern ignores case unless it carries Options = None
  (ADR-PWSH-PARAM-CASESENSITIVEPATTERN).
- 2026-10-22 Cats: Token tip: Next time, save tokens by: reading an Invoke-CatzcCommand output with one grep for its Invoke-CatzcCommand,
  Write-QualityGateReport and Invoke-TestFile lines instead of tailing it.
- 2026-10-22 Cats: Token tip: Next time, save tokens by: chaining Format-Code, the test file and the gate of one step into one
  Invoke-CatzcCommand call, so one import serves all three.
- 2026-10-22 Cats: Test-AgentDefinitions counts every top-level front-matter key, metadata included, toward a capability line roof of 10,
  and never checks line width.
- 2026-10-22 Cats: A command help lives in its comment page under docs/references; Get-Help shows none of it, only the generated syntax.
- 2026-10-22 Cats: Test-Plans fails when the step count in a plan master line or value row differs from its open steps
  (ADR-REPO-PLANS-THREEPARTS).
- 2026-10-22 Cats: The importer tail runs Build-RootConfig on every load, so any session import materialises an edited root asset under
  pwsh/Catzc.Base.RootConfig/assets/root.
- 2026-10-22 Cats: Test-ParameterConsistency takes no -Path; it always checks the whole tree.
- 2026-10-22 Cats: New-Plan writes the plan, its value row and its master line ahead of the task pointers, leaving the row docs and tests
  cells empty.
- 2026-10-22 Cats: Under ADR-AUTO-PY-MODULESBYLAYOUT a Python module may keep its own tests folder; only black-box engine tests sit under
  python/tests/\<module>.
- 2026-10-22 Cats: Token tip: hand each hindsight file to a read-only Explore agent that returns one fixed verdict table.
- 2026-10-22 Cats: Token tip: pass several quoted commands to one Invoke-CatzcCommand.ps1 call instead of writing an out/ script per gate.
- 2026-10-22 Cats: In hindsight I wish I knew this fact: root importer.sh is generated from
  pwsh/Catzc.Base.RootConfig/assets/root/importer.sh, and the root copy follows an asset edit before any Build-RootConfig run, so an asset
  edit is already a live import-path change.
- 2026-10-22 Cats: In hindsight I wish I knew this fact: a new public command's help goes straight onto its docs/references comment page;
  the ps-help imprint step only moves help in git-tracked files, so an untracked new file keeps inline help.
- 2026-10-22 Cats: In hindsight I wish I knew this fact: a QualityGateResult exposes a gate's facts as .Facts['Name'], never as a top-level
  property.
- 2026-10-22 Cats: In hindsight I wish I knew this fact: a bats test that hands a temp path to pwsh on Windows needs cygpath -m first, as
  importer.sh does for its own root.
