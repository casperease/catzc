# Session learnings 4175dc

Started 2026-10-23T11:18:33.2487061+02:00.

- 2026-10-23 Cats: In hindsight I wish I knew this fact: cspell reads a PowerShell escape glued to a word (nnamespace) as one unknown word.
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
- 2026-10-23 Cats: In hindsight I wish I knew this fact: Measure-NoUnsafeFirstIndex flags `@(x)[0]`; the fix is `x | Select-Object -First 1`.
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
