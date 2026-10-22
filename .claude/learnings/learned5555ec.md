# Session learnings 5555ec

Started 2026-10-22T02:17:29.6324179+02:00.

- 2026-10-22 Cats: In hindsight I wish I knew this fact: a test file's own report goes to its TestDrive, so the gate itself (Test-Spelling
  -PassThru) is the quick way to list a red integrity test's findings.
- 2026-10-22 Cats: In hindsight I wish I knew this fact: Get-CommandContract reads every contract in about 1.2 s, but once per command costs
  about 390 ms; an integrity test over all contracts reads them once in BeforeAll.
- 2026-10-22 Cats: Token tip: Next time, save tokens by: grepping a run's tests.csv and files-shard-*.json for the slow or failing rows
  instead of printing whole gate outputs.
- 2026-10-22 Cats: Token tip: Next time, save tokens by: passing a path list to a pwsh -File script inside -Command as an array, never
  comma-joined, which binds as one string.
- 2026-10-22 Cats: In hindsight I wish I knew this fact: the importer runs Build-RootConfig -Silent on every load
  (Catzc.Internal.Importer.psm1:406-407), so a root asset edit under pwsh/Catzc.Base.RootConfig/assets/root is materialised by the next
  import of any session.
- 2026-10-22 Cats: In hindsight I wish I knew this fact: Test-Plans fails a chunk line or value row whose stated step count differs from the
  plan open steps (ADR-REPO-PLANS-THREEPARTS), so striking a step means syncing the master line and the value row in the same edit.
- 2026-10-22 Cats: In hindsight I wish I knew this fact: catzc-run forbids Format-Code -Language markdown and a session of its own out/*.ps1
  scripts; a plan check runs as one Invoke-CatzcCommand.ps1 call with Format-Code -Path on the files touched, then Test-Plans.
- 2026-10-22 Cats: In hindsight I wish I knew this fact: five sessions running Pester at once take this 32 GB machine below 4 GB free and
  the host kills the runs, so heavy runs go one at a time.
- 2026-10-22 Cats: In hindsight I wish I knew this fact: Get-Help shows none of the help on a command comment page under docs/references, so
  help is proven by reading the page.
- 2026-10-22 Cats: In hindsight I wish I knew this fact: 321 of the 338 failures of the 2026-10-21 full run were one parent setup fall of
  the diagram kit test folder under its old name python/Catzc.Diagrams.
- 2026-10-22 Cats: In hindsight I wish I knew this fact: hindsight lines go stale within a day, so a gap is grepped in the tree before it is
  planned.
- 2026-10-22 Cats: In hindsight I wish I knew this fact: GlossaryConcept checks defined_by by shape only; the kind-aware rule-code check is
  the post-load check in Get-GlossarySourceViolations against (Get-Config drs).CodeForm.
- 2026-10-22 Cats: Token tip: Next time, save tokens by: reading a run result with one grep for its Write-QualityGateReport and
  Invoke-CatzcCommand lines instead of a tail.
- 2026-10-22 Cats: Token tip: Next time, save tokens by: editing a plan with the Edit tool, never a pwsh one-liner, which strips backticks
  and apostrophes and costs a rewrite.
