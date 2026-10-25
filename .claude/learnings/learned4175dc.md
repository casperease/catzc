# Session learnings 4175dc

Started 2026-10-23T11:18:33.2487061+02:00.

- 2026-10-23 Cats: In hindsight I wish I knew this fact: cspell reads a PowerShell escape glued to the word after it, such as a backtick-n
  before `namespace` in a string, as one unknown word.
- 2026-10-23 Cats: In hindsight I wish I knew this fact: the diagram kit runs as uv run --no-sync --project python; plain uv run may sync
  against the index.
- 2026-10-23 Cats: Token tip: Next time, save tokens by: reading a run's verdict with one grep for its passed/failed and IssueCount lines,
  never the whole output.
- 2026-10-23 Cats: Token tip: Next time, save tokens by: checking git status before a diff, since the user stages and commits mid-run and a
  plain git diff then shows nothing.
- 2026-10-23 Cats: In hindsight I wish I knew this fact: root-config generators are called by name from Invoke-RootConfigGenerator in
  Catzc.Base.RootConfig, so a generator must live in a Base module; one in Tooling is a Base-to-Tooling edge.
- 2026-10-23 Cats: In hindsight I wish I knew this fact: a dotnet publish restores from the user NuGet config, and NuGet's Azure Artifacts
  credential plugin outlives the publish holding its output open; the generated root nuget.config clears every source and
  Assert-DotnetOffline guards every in-tree dotnet run.
- 2026-10-23 Cats: In hindsight I wish I knew this fact: Invoke-CatzcCommand fails a line on Result Failed, on any per-test record with
  Outcome fail, and on any gate result with IssueCount above 0.
- 2026-10-23 Cats: In hindsight I wish I knew this fact: Enter-CatzcBurst and Invoke-CatzcCommand give up at once when the lock holder's
  deadline lies past their budget, even when the holder is the same session's own run.
- 2026-10-23 Cats: In hindsight I wish I knew this fact: the XML property carrier writes the head as a PropertyGroup labelled catzc right
  after the root tag, and NuGet reads past it in nuget.config.
- 2026-10-23 Cats: In hindsight I wish I knew this fact: under strict mode, assigning if-statement output that holds @() unrolls to a scalar
  or null; wrap the whole if in @() instead.
- 2026-10-23 Cats: In hindsight I wish I knew this fact: Measure-NoUnsafeFirstIndex flags `@(x)[0]`; the fix is
  `x | Select-Object -First 1`.
- 2026-10-23 Cats: In hindsight I wish I knew this fact: the Python diagram kit runs with uv run --no-sync, as the tooling runs it, so it
  never syncs or reads a package index.
- 2026-10-23 Cats: Token tip: Next time, save tokens by: reading a run's verdicts with one grep of the Invoke-CatzcCommand passed/failed
  lines instead of whole outputs.
- 2026-10-23 Cats: Token tip: Next time, save tokens by: staging a multi-file import-path change as a mirror tree with one Enter-CatzcBurst
  -Run script that backs up and restores, so each retry is one call.
- 2026-10-23 Cats: Token tip: Next time, save tokens by: never queuing a second run behind your own lock holder, since it gives up past its
  budget and costs a retry.
- 2026-10-23 Cats: In hindsight I wish I knew this fact: before 2026-10-23 Invoke-CatzcCommand passed a red pytest run and a -PassThru gate
  with issues; both now fail the call, so an older runner verdict on Python or a gate is not evidence.
- 2026-10-23 Cats: In hindsight I wish I knew this fact: every dotnet publish, build or format runs an implicit NuGet restore that reads the
  user-level NuGet.Config; the generated root nuget.config and Assert-DotnetOffline now keep it offline, and plain uv run (without
  --no-sync) can still sync against the package index.
- 2026-10-23 Cats: In hindsight I wish I knew this fact: Build-RootConfig calls every root-config generator from Base, so a generator lives
  in a Base module (Catzc.Base.Languages for nuget.config and Directory.Build.props), never in Tooling.
- 2026-10-23 Cats: In hindsight I wish I knew this fact: Enter-CatzcBurst takes its steps as the remaining positional arguments (-Seconds
  \<s> 'a' 'b'); -Run 'a' 'b' through pwsh -File once bound the second step to -LockName.
- 2026-10-23 Cats: In hindsight I wish I knew this fact: a diagram declaration holds only its minimaps inputs (about.adrs, shown ids,
  optional exclude); the cells are computed at build and never written back (ADR-REPO-SLIDES-MINIMAPSFROMDATA).
- 2026-10-23 Cats: In hindsight I wish I knew this fact: a plan step check must name a command a module exports; Test-Plans rejects an
  internal script such as Invoke-CatzcCommand.
- 2026-10-23 Cats: Token tip: Next time, save tokens by: batching the orchestrator plan checks into one Format-Code and Test-Plans run per
  worker report instead of one per edit.
- 2026-10-23 Cats: Token tip: Next time, save tokens by: treating an idle notice older than the worker last reply as stale without a tool
  call.
- 2026-10-23 Cats: In hindsight I wish I knew this fact: Assert-AccostedArgument checks only an argument against its type; the harmless-verb
  and out/ output_folder rules live in Get-AccostedFile, so Test-AccostedCommand can serve mutating calls.
- 2026-10-23 Cats: In hindsight I wish I knew this fact: a diagram action or effect call is checked by the public Test-AccostedCommand
  (Catzc.Base.Contracts), which Slides may call; the Contracts private helpers (Get-CommandContractMap, Assert-AccostedArgument) are out of
  its reach.
- 2026-10-23 Cats: In hindsight I wish I knew this fact: a new public command needs a contract file under contracts/catzc/0.0.0/\<module>/
  and a Build-ContractReference run, or Test-Contracts fails.
- 2026-10-23 Cats: In hindsight I wish I knew this fact: a comment page section names its code line, so renaming a variable under a comment
  (here $dueWriters to $checkedWriters) needs the page anchor updated or Test-Comments reports it.
- 2026-10-23 Cats: In hindsight I wish I knew this fact: under strict mode, .Count on a command that returns nothing fails; wrap the call in
  @() in tests and callers.
- 2026-10-23 Cats: Token tip: write one out/ script per verification round (Format-Code, tests, gates) and run it once in the background,
  instead of many separate Bash probes.
- 2026-10-23 Cats: Token tip: read the Test-Comments/Test-FileMeta tail of the output only (grep out the Format-Code chatter) to see the
  verdict.
- 2026-10-23 Cats: In hindsight I wish I knew this fact: the real-process tripwire is armed per outermost Describe by its tier
  (Test-RealProcessBlocked), so an L0/L1 test that launches git fails in every run; a test whose point is the real tree belongs at L2 with a
  literal tool_*_missing self-skip.
- 2026-10-23 Cats: In hindsight I wish I knew this fact: the word accosted is reserved; every new file that names the language needs a scope
  line in Catzc.Base.QualityGates/configs/terminology.yml before Test-Terminology passes.
- 2026-10-23 Cats: In hindsight I wish I knew this fact: TestTiers.cs is linked into the Assert-BashTimeout hook, and a new timeouts.yml key
  is read by it, so either change needs Build-AgentHook in the same burst or every Bash call is denied.
- 2026-10-23 Cats: In hindsight I wish I knew this fact: Invoke-TestFile -MaxLevel takes only 3 or 4; a tier-filtered check of one module is
  Test-Automation -MinLevel 0 -MaxLevel 1 -Modules \<module>.
- 2026-10-23 Cats: In hindsight I wish I knew this fact: Test-Change runs only the tests covering changed files, so a green Test-Change says
  nothing about tests in unchanged files; the tier runs found 165 failures it could not.
- 2026-10-23 Cats: In hindsight I wish I knew this fact: generated-files.yml declares each writer inputs, outputs and at_import, and
  Get-GeneratedWriterDue is the one matcher the gate and the import janitors share.
- 2026-10-23 Cats: In hindsight I wish I knew this fact: an action diagram (about.lens: action) proves its effects against the proof file
  and its action and executions against their command contracts through Test-AccostedCommand.
- 2026-10-23 Cats: In hindsight I wish I knew this fact: striking plan steps with sed line ranges breaks numbered lists when Format-Code
  reflows them; strike by exact text with the Edit tool.
- 2026-10-23 Cats: Token tip: Next time, save tokens by: batching the plan check into one Format-Code + Test-Plans run per worker report
  instead of one per edit; four were starved by the run lock in a row.
- 2026-10-23 Cats: Token tip: Next time, save tokens by: adding reserved-scope and terminology lines up front when briefing a feature, not
  one red Test-Terminology run at a time.
- 2026-10-23 Cats: Token tip: Next time, save tokens by: running every gate call with -BudgetSeconds 335; the default 280 s budget lost runs
  to busy locks.
- 2026-10-23 Cats: In hindsight I wish I knew this fact: a comment page section anchors on its code line cut at 80 columns on a space plus
  ..., compared exactly, and Test-Comments flags a section whose anchor no longer matches.
- 2026-10-23 Cats: In hindsight I wish I knew this fact: on the pinned Pester 5.7.1 a Mock body reads the It locals and the test file
  script: variables, with or without -ModuleName, so a Set mock and a Get mock do round-trip.
- 2026-10-23 Cats: In hindsight I wish I knew this fact: PSReviewUnusedParameter flags an InModuleScope block parameter used only inside a
  nested Should -Throw block; put the call and its param block inside the throw block.
- 2026-10-23 Cats: In hindsight I wish I knew this fact: Invoke-TestFile -MaxLevel takes only 3 or 4; a tier-capped run is Test-Automation
  -MinLevel n -MaxLevel n -Modules \<Module>.
- 2026-10-23 Cats: In hindsight I wish I knew this fact: Build-Diagrams accepts a new diagram only when its stem is in drawio.yml carriers:,
  which declaration.py carry \<stem> file records.
- 2026-10-23 Cats: In hindsight I wish I knew this fact: a hand-written file head whose cites the code lacks is deleted by the file-meta
  imprint, and Test-Formatting reports it as not formatted for the owning language.
- 2026-10-23 Cats: In hindsight I wish I knew this fact: the word accosted is reserved to the files of the reserved scope in
  terminology.yml, so a skill or an article outside it says proof file or needs a scope line.
- 2026-10-23 Cats: In hindsight I wish I knew this fact: glossary families take only declared forms, so proof facet, inner zone and spelling
  gate fail G6; write proof box, a zone nearer the action and spelling quality gate.
- 2026-10-23 Cats: In hindsight I wish I knew this fact: a design-domain record may not cite automation or repository records
  (Test-DrsRegistry checks the dependency direction), so it names them in words.
