# Session learnings d2a5f2

Started 2026-10-25T23:52:39.8581500+01:00.

- 2026-10-25 Cats: In hindsight I wish I knew this fact: a config may be a folder of disjoint parts, configs/\<name>/*.yml, merged by
  Get-Config; every gate that walks configs/ must accept it.
- 2026-10-25 Cats: In hindsight I wish I knew this fact: under manifest-glob addressing one contract asset yields one record per Target, so
  a contract test matches on AssetPath and Target.
- 2026-10-25 Cats: In hindsight I wish I knew this fact: a case-only rename on disk leaves the git index in the old case, and the
  normal-name round-trip test reads the index.
- 2026-10-25 Cats: In hindsight I wish I knew this fact: ConvertTo-Guid and SentenceGuid live in Catzc.Base.Objects, so any module may mint
  a sentence GUID without a dependency cycle.
- 2026-10-25 Cats: Token tip: Next time, save tokens by: reading a run's results-shard-*.xml failure messages in one python pass instead of
  guessing from the pasted tail.
- 2026-10-25 Cats: Token tip: Next time, save tokens by: re-running a snapshot-only failure in a small -Isolated -Modules slice before
  chasing its cause.
- 2026-10-25 Cats: In hindsight I wish I knew this fact: Add-Type -OutputAssembly gives each build a random assembly name, so two
  Catzc.Types builds load side by side; a full type name still resolves to the first-loaded build, and only a re-pointed accelerator reaches
  the new one.
- 2026-10-25 Cats: In hindsight I wish I knew this fact: Import-TypesAssembly already loads a per-user shadow copy, so no session locks
  pwsh/.compiled; the churn comes from the DLL being tracked.
- 2026-10-25 Cats: In hindsight I wish I knew this fact: Import-CSharpTypes.ps1 lines 97-135 is the one types-changed branch; the pipeline
  throw sits first in it, so a console-only change placed after it never reaches CI.
- 2026-10-25 Cats: In hindsight I wish I knew this fact: the tracked DLL is assumed by ADR-AUTO-CACHE-COMPILEDTYPEPREBUILD,
  Clear-ModuleTypeCache, Invoke-ModuleBuild, SpellOutIdentifiers and gitignore.yml.
- 2026-10-25 Cats: Token tip: Next time, save tokens by: grepping "\.compiled" once across the tree before proposing a change to the types
  artefact.
- 2026-10-25 Cats: In hindsight I wish I knew this fact: CommentEngine Page.Parse keeps all text before the first "## comment:N" heading, so
  a comment page rewritten as prose survives every later Export-Comments run.
- 2026-10-25 Cats: In hindsight I wish I knew this fact: Test-Comments counts a "## comment:N" section without its "Above `...`" context
  line as an orphan.
- 2026-10-25 Cats: In hindsight I wish I knew this fact: Test-Links rejects repository-rooted links (/docs/...) in docs prose; comment
  sections carry them, so folded prose must re-point them relative.
- 2026-10-25 Cats: In hindsight I wish I knew this fact: Test-Plans finds an open step's check only by the literal "Check:"; "Check, per
  module:" fails.
- 2026-10-25 Cats: In hindsight I wish I knew this fact: 1,789 pages under docs/references still carry the exporter fresh-page line; most
  sources already hold their one-line insights.
- 2026-10-25 Cats: Token tip: Next time, save tokens by: reading QualityGateResult (Subject, Issues, ReportPath, Facts) before scripting
  gate checks; it has no Passed property.
- 2026-10-25 Cats: Token tip: Next time, save tokens by: writing "Check:" verbatim in every plan step on the first pass.
- 2026-10-25 Cats: In hindsight I wish I knew this fact: Get-Config resolves a config by name across every configs/ folder, so a file and a
  same-named folder side by side break every import at once.
- 2026-10-25 Cats: In hindsight I wish I knew this fact: the type loader needs each types/\<Name>.cs to declare a public class of that name,
  so a C# split uses public static helper classes, never partial classes.
- 2026-10-25 Cats: In hindsight I wish I knew this fact: a .internal psm1 that ships in a bundle needs every dot-sourced file listed in
  Builder runtimeInternalFiles; assets/ is outside the comment engine.
- 2026-10-25 Cats: In hindsight I wish I knew this fact: the track-lamps packager and the swap test copied only extension.js; both now take
  every sibling .js.
- 2026-10-25 Cats: In hindsight I wish I knew this fact: a new file that names the reserved word accosted needs its scope line in
  configs/terminology/reserved.yml.
- 2026-10-25 Cats: In hindsight I wish I knew this fact: comment pages anchor on the code line text, so private-to-internal changes and
  moved code orphan sections; regenerate the page with Format-Code.
- 2026-10-25 Cats: Token tip: Next time, save tokens by: briefing drones to report after each landed file, since 50-turn limits cut off
  three of them.
- 2026-10-25 Cats: Token tip: Next time, save tokens by: stopping a finished drone at once, so its idle notices do not each cost a turn.
