# Session learnings fc1db4

Started 2026-10-21T06:22:09.4408143+02:00.

- 2026-10-21 Cats: In hindsight I wish I knew this fact: ADR-REPO-PLANS-ONESHAPE and -OPENSTEP still describe a Done section and ticked
  steps, though the user retired both on 2026-10-20; plan-agent-friction step 9 restates them.
- 2026-10-21 Cats: In hindsight I wish I knew this fact: Catzc.Base.CodeMeta is loaded by both Catzc.Base.Languages and
  Catzc.Base.QualityGates, so it is the home for a head derivation both need.
- 2026-10-21 Cats: In hindsight I wish I knew this fact: Get-AdrCitationGraphViolations in Catzc.Base.Docs fails a citation outside a domain
  depends_on, so Test-AdrRegistry already holds that rule.
- 2026-10-21 Cats: In hindsight I wish I knew this fact: the product-thesis deck has no slide pattern that carries an image, and its slide
  orders run 1 to 21 without gaps.
- 2026-10-21 Cats: Token tip: Next time, save tokens by: diffing each master line and value row against the plan open steps before reading
  any plan in full.
- 2026-10-21 Cats: Token tip: Next time, save tokens by: using the Grep tool for any recursive search under pwsh/, since a recursive bash
  grep overruns the 3 s roof.
- 2026-10-21 Cats: Token tip: Next time, save tokens by: running git status on .claude/plans before a repeat finalize, since a clean tree
  means nothing is owed.
- 2026-10-21 Cats: In hindsight I wish I knew this fact: catzc.sln at the root is a gitignored output of Build-RootConfig; only
  pwsh/Catzc.Base.RootConfig/assets/root/catzc.sln is tracked.
- 2026-10-21 Cats: In hindsight I wish I knew this fact: a config is registered in pwsh/Catzc.Base.Config/configs/configs.yml as name -> C#
  type, and its default is a const on that type, so an empty yml is a valid config.
- 2026-10-21 Cats: In hindsight I wish I knew this fact: Format-Code moves a long code comment to a docs/references comment page whose
  "Above `...`" line names the code line, so editing that code line means editing the page too.
- 2026-10-21 Cats: In hindsight I wish I knew this fact: Base modules run dotnet through Invoke-Executable, never Invoke-Dotnet, and
  Build-AgentHook and Invoke-BuildForVSCode are the only catzc callers of dotnet build/publish.
- 2026-10-21 Cats: In hindsight I wish I knew this fact: plan-bcl-language re-cites every ADR-AUTO-TYPES-* rule to ADR-BCL-TYPES-*, so a new
  rule in native-csharp-types.md rides that re-cite.
- 2026-10-21 Cats: Token tip: Next time, save tokens by: using the Grep tool instead of grep -r with many --include flags, which overran the
  3 s foreground roof twice.
- 2026-10-21 Cats: Token tip: Next time, save tokens by: reading an ADR with Read and an offset rather than cat, whose large output was
  persisted and read twice.
- 2026-10-21 Cats: In hindsight I wish I knew this fact: New-Plan writes only the plan file; the value-of-plan.md row and the plan-master.md
  chunk line are written by hand.
- 2026-10-21 Cats: In hindsight I wish I knew this fact: the contract language has no side-effect key and no config marks a command
  harmless; a verb allow-list in config is the planned way (plan-accosted-language).
- 2026-10-21 Cats: In hindsight I wish I knew this fact: terminology.yml categories carry a scope that is a zone map, and no category
  reserves a token to named paths yet.
- 2026-10-21 Cats: In hindsight I wish I knew this fact: the plan-decide agent names no folder for its questionnaire and decisions files;
  older rounds kept them in .claude/plans, the 2026-10-21 round in out/.
- 2026-10-21 Cats: In hindsight I wish I knew this fact: a bash find or grep -r over the whole tree exceeds the 3 s foreground roof; the
  Grep and Glob tools answer the same question in time.
- 2026-10-21 Cats: Token tip: Next time, save tokens by: probing the tree with the Grep and Glob tools instead of bash find or grep -r,
  which time out and need a second read.
- 2026-10-21 Cats: Token tip: Next time, save tokens by: reading one sample command.yml and the plans ADR rule headings before writing a
  plan, instead of whole ADR pages.
