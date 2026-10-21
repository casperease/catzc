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
