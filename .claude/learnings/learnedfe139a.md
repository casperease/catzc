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
- 2026-11-02 Cats: In hindsight I wish I knew this fact: Get-Config keys configs by bare global name (about 741 call lines) and catzc's
  sealed configs.yml is the only registry; a second module owning a name throws at Resolve-ConfigEntry.ps1:91.
- 2026-11-02 Cats: In hindsight I wish I knew this fact: a bundle loads C# types prebuilt only (Import-CSharpTypes -PrebuiltOnly) and the
  Catzc.Types. prefix is hard-coded in Catzc.Internal.Types.psm1.
- 2026-11-02 Cats: In hindsight I wish I knew this fact: overlay local modules are New-Module dynamic modules with no manifest, namespace or
  dependency order (Import-Overlay.ps1:23-49).
- 2026-11-02 Cats: In hindsight I wish I knew this fact: Pester, PSScriptAnalyzer and TestKit ship only under -VendorPolicy full, and no
  exporter.yml bundle declares full.
- 2026-11-02 Cats: In hindsight I wish I knew this fact: no pipeline runs Test-CatzcBuild, although test-automation.md says both runs
  execute in CI; that record also gives two different default top tiers (2 and 3).
- 2026-11-02 Cats: In hindsight I wish I knew this fact: the quality-gate set is the union of languages.yml checks: lists, which
  Measure-QualityGates already enumerates.
- 2026-11-02 Cats: In hindsight I wish I knew this fact: in a bundle the leaf of CatzcModulesRoot is the version folder, and
  Get-CatzcModulesFolder throws when the code root sits outside the working root.
- 2026-11-02 Cats: Token tip: Next time, save tokens by: settling where consumer files live (.catzc vs own tracks) before writing full
  steps; the plan was rewritten four times.
- 2026-11-02 Cats: Token tip: Next time, save tokens by: giving verify agents numbered claims to mark TRUE/FALSE with file:line, which found
  every blocker in one round.
- 2026-11-04 Cats: In hindsight I wish I knew this fact: a command without a commands row in timeouts.yml waits or is killed at the devbox
  default of 3 s; Build-Bicep, Build-Modules and Invoke-ImporterJanitors have rows since 2026-11-03.
- 2026-11-04 Cats: In hindsight I wish I knew this fact: a BeforeAll Write-Message never reaches a worker log; a test that reports numbers
  writes a file beside its results, the run folder being the parent of CATZC_BICEP_BUILD_CACHE.
- 2026-11-04 Cats: In hindsight I wish I knew this fact: the run lock refuses a call whose wait would exceed its budget instead of queuing
  it, so two concurrent proofs through Invoke-CatzcCommand are impossible; chain commands into one call.
- 2026-11-04 Cats: In hindsight I wish I knew this fact: the build store is immutable per source stamp and selection under
  out/pwsh/built/\<bundle>/\<stamp>/, and the default destination out/pwsh/built/\<bundle>/Catzc/\<version> is shared by every Export-Catzc
  caller and guarded by Enter-BuildLock.
- 2026-11-04 Cats: In hindsight I wish I knew this fact: tests/ paths are outside the build stamp, so a test edit keeps every build warm and
  a module edit makes the next run rebuild each selection, about 35 s each.
- 2026-11-04 Cats: In hindsight I wish I knew this fact: the protection skip lives in a script-scoped variable of Base.Globs, so a second
  full run in one session runs nothing; Clear-GlobSetProtection or a fresh import runs everything.
- 2026-11-04 Cats: In hindsight I wish I knew this fact: language test folders are Pester containers discovered by Language.Bridge.ps1
  BeforeDiscovery; the discovery cache keys them on the folder test files and the bridge digest.
- 2026-11-04 Cats: In hindsight I wish I knew this fact: Consumer.L2 alone is 130-140 s and 2.3 times that under the 14-worker pool; it is
  the full run critical path and the 240 s budget predates it.
- 2026-11-04 Cats: In hindsight I wish I knew this fact: a session cache in a script-scoped variable dies with the next import;
  Get-ModuleGlobSet and Get-GlobSet keep their derived tables that way.
- 2026-11-04 Cats: In hindsight I wish I knew this fact: the manual test plan matches integrity blocks on file and block name, so re-tagging
  a Describe to integrity or moving it to a new file needs its check in a category page.
- 2026-11-04 Cats: Token tip: Next time, save tokens by: briefing a drone to add phase seconds first and cut second, with a stop at 40
  calls; three step premises were wrong until measured.
- 2026-11-04 Cats: Token tip: Next time, save tokens by: reading a run with one grep for its verdict lines and one results XML total, never
  a drone transcript.
- 2026-11-04 Cats: Token tip: Next time, save tokens by: never queuing a second Invoke-CatzcCommand behind one of mine that holds the lock
  over 120 s; it is refused and the call is wasted.
