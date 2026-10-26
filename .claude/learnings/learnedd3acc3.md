# Session learnings d3acc3

Started 2026-10-26T14:27:33.1467183+01:00.

- 2026-10-26 Cats: In hindsight I wish I knew this fact: a built bundle and the pwsh/.internal Catzc.Internal.*.psm1 files keep full-name
  names on purpose (PSModulePath, global identity); Test-TrackNamespace lists the declared exemptions.
- 2026-10-26 Cats: In hindsight I wish I knew this fact: a staged-burst step must be an Invoke-TestFile call, never a bare *.Tests.ps1 path;
  Invoke-CatzcCommand now wraps bare paths, but verdicts are still read from the results XML.
- 2026-10-26 Cats: In hindsight I wish I knew this fact: an import that starts while a burst swaps files reads a half-applied tree;
  Wait-ImportBurst blocks imports during Local\catzc-run-burst, and bursts run one at a time.
- 2026-10-26 Cats: In hindsight I wish I knew this fact: the per-machine type-hash stamp (%LOCALAPPDATA%\catzc\types\stamp-*.json) can go
  stale after a move; deleting it is safe and the next import rebuilds it.
- 2026-10-26 Cats: In hindsight I wish I knew this fact: contract groups are \<track>.\<module short name> (pwsh.azure.dev_ops) via
  ContractsConfig, and a command contract starts with description: equal to its stripped comment-page synopsis.
- 2026-10-26 Cats: In hindsight I wish I knew this fact: Invoke-StagedBurst -Stage records a base hash and refuses a stale copy; a
  whole-file staged copy without it overwrote peers' dependencies.yml edits twice.
- 2026-10-26 Cats: In hindsight I wish I knew this fact: line width is measure-only; only length limits fail Test-FileLimits.
- 2026-10-26 Cats: Token tip: Next time, save tokens by: running one ListAgents check before re-pinging a silent worker instead of
  reassigning its burst.
- 2026-10-26 Cats: Token tip: Next time, save tokens by: writing the move list and its csv before any git mv, then letting every repair step
  read the csv.
- 2026-10-26 Cats: In hindsight I wish I knew this fact: a command-contract description is its comment page's ### synopsis through
  PlainText.Plain, and Test-Contracts holds the two equal.
- 2026-10-26 Cats: In hindsight I wish I knew this fact: help synopses live on docs/references comment pages, not in the .ps1; FunctionHelp
  and PlainText.Synopsis read them.
- 2026-10-26 Cats: In hindsight I wish I knew this fact: built bundles keep full-name module folders, while source folders drop the Catzc
  namespace; FolderNameOf applies only to source roots.
- 2026-10-26 Cats: In hindsight I wish I knew this fact: Invoke-TestFile -PassThru returns Rows, not PassedCount; count Rows by Result.
- 2026-10-26 Cats: In hindsight I wish I knew this fact: changing a contract type breaks every test fixture that builds it, in
  Get-CommandContract, Build-ContractReference and Get-ContractCheckResults tests.
- 2026-10-26 Cats: Token tip: Next time, save tokens by: grepping all fixture builders of a changed type before the first burst, so one
  burst covers them.
- 2026-10-26 Cats: Token tip: Next time, save tokens by: one reusable counts.ps1 taking a list file instead of a new check script per unit.
- 2026-10-26 Cats: In hindsight I wish I knew this fact: a module folder never equals its name; the full name comes from the track namespace
  through Resolve-ModuleName (bootstrap) or VariantTrack.FullNameOf/FolderNameOf, and a built bundle (Import-Catzc.ps1 at its root) resolves
  with no namespace.
- 2026-10-26 Cats: In hindsight I wish I knew this fact: Get-CatzcModuleRoot returns the loaded module's ModuleBase; a New-Module's Path is
  a fake cwd\guid, so "no file at Path" is the dynamic-module test.
- 2026-10-26 Cats: In hindsight I wish I knew this fact: the type hash memo (stamp-*.json under LOCALAPPDATA/catzc/types) records its form;
  a hash that disagrees with the build is a stale memo or a frozen copy hashed without the live namespace.
- 2026-10-26 Cats: In hindsight I wish I knew this fact: Invoke-StagedBurst refuses an empty staged folder; in-place tool passes run under
  Enter-CatzcBurst with one script step.
- 2026-10-26 Cats: In hindsight I wish I knew this fact: a check script that pipes Invoke-TestFile to Out-Null makes a burst step pass while
  tests fail; read the results XML (total/failures) for every verdict.
- 2026-10-26 Cats: In hindsight I wish I knew this fact: Update-DrsCitation's code map rewrites only repository-root paths, and a folder row
  maps the parent of its path; relative links, /repo/ or \<repo>/ prefixes and .catzc overlay paths need hand edits or stay.
- 2026-10-26 Cats: In hindsight I wish I knew this fact: Catzc.Internal.Builder.psm1's runtime list is what a bundle ships; every file the
  importer or Types module dot-sources must be on it and in Invoke-ModuleBuild.Tests' fixture.
- 2026-10-26 Cats: In hindsight I wish I knew this fact: Invoke-TestFile and Test-Parsing reject a dot-folder path (pwsh/.internal); pass
  the test files by name.
- 2026-10-26 Cats: In hindsight I wish I knew this fact: rebuild-hash tests build twice from the live tree, so a peer swap between builds
  fails them without any code fault.
- 2026-10-26 Cats: Token tip: Next time, save tokens by: writing PowerShell lists of pairs as [pscustomobject] rows, never nested @(@()),
  which flattens.
- 2026-10-26 Cats: Token tip: Next time, save tokens by: editing backslash-bearing text with Edit, never python heredocs, which eat
  backslashes.
- 2026-10-26 Cats: Token tip: Next time, save tokens by: excluding .claude/CLAUDE.md, learnings and hindsight from any tool-driven path
  rewrite up front.
- 2026-10-26 Cats: In hindsight I wish I knew this fact: a contract-group folder rename breaks the diagram kit too, because
  python/diagrams/minimap_contract.py and tests/test_query_rows.py spell contracts/catzc/\<v>/\<group> literally.
- 2026-10-26 Cats: In hindsight I wish I knew this fact: Invoke-StagedBurst refuses an empty staged folder, so a re-render under the run
  lock needs one unchanged file staged as its carrier.
- 2026-10-26 Cats: In hindsight I wish I knew this fact: a new L1 integrity block fails ManualTestPlan-Coverage until a category page under
  docs/how-to/pwsh/manual-test-plan/ names the block exactly.
- 2026-10-26 Cats: In hindsight I wish I knew this fact: a slide that quotes a rule must match the registry word for word, so a wording
  sweep over slides breaks Test-Slides on quote slides.
- 2026-10-26 Cats: In hindsight I wish I knew this fact: Export-Comments creates untracked reference pages, and anything listing pages from
  Get-TrackedFile misses them until the user commits.
- 2026-10-26 Cats: In hindsight I wish I knew this fact: staged C# types can be tested before a swap by compiling them under a scratch
  namespace with Add-Type against the loaded types DLL.
- 2026-10-26 Cats: Token tip: Next time, save tokens by: running Format-Code and Format-Links on new files before the first burst, not after
  the final check flags them.
- 2026-10-26 Cats: Token tip: Next time, save tokens by: passing -WorkingDirectory C:/projects/catzc to every pwsh call, since a python
  heredoc cd drifts the shell cwd.
- 2026-10-26 Cats: In hindsight I wish I knew this fact: Invoke-StagedBurst bare test paths in -Command could report passed while Pester
  showed failures; read results-shard-*.xml totals, never the verdict line.
- 2026-10-26 Cats: In hindsight I wish I knew this fact: a module folder drops its track namespace; full name comes from the loaded module,
  the generated psd1 or VariantTrack.FolderNameOf/FullNameOf, never from the folder name.
- 2026-10-26 Cats: In hindsight I wish I knew this fact: Catzc.Base.Globs already depends on Catzc.Base.Variants, so Variants can never call
  Globs; shared glob matching lives in Catzc.Base.Objects.GlobPattern.
- 2026-10-26 Cats: In hindsight I wish I knew this fact: Get-CatzcModuleRoot with a non-literal -Module fails the internal-asset inventory;
  resolve by Get-Module instead.
- 2026-10-26 Cats: In hindsight I wish I knew this fact: a test file under tests/types/ must be named for a C# type in types/, so a split
  takes the name of a real type.
- 2026-10-26 Cats: Token tip: Next time, save tokens by: running one module per Invoke-TestFile under a resumable sweep script that writes a
  file per chunk.
- 2026-10-26 Cats: Token tip: Next time, save tokens by: reading results-shard XML counts directly instead of grepping console output.
