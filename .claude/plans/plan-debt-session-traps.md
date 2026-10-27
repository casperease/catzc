---
plan:
  status: active
  value: medium
  reviewed: 2026-10-27
  class: feature
  targets:
    [
      pwsh/Base.Config/Get-Config.ps1,
      docs/how-to/getting-started/BCL/add-a-dotnet-type.md,
      docs/how-to/automation/strict-mode-traps.md,
      pwsh/.internal/assets/Invoke-StagedBurst.ps1,
      pwsh/.internal/assets/Invoke-CatzcCommand.ps1,
      pwsh/Base.Drs/Update-DrsCitation.ps1,
      pwsh/.internal/tests/Invoke-ModuleBuild.Tests.ps1,
      docs/how-to/pwsh/build-all-diagrams.md,
      pwsh/.internal/assets/bootstrap/Import-CSharpTypes.ps1,
      pwsh/Base.Docs/Add-SessionLearning.ps1,
    ]
---

# Session traps: the gaps the hindsight log found, closed by a command, a guard or a how-to

The hindsight log of 2026-10-27 judged every learning against the tree. The gap verdicts and the halves whose home is code or a how-to, not
a skill line, land here: a guard where the tree can refuse the trap, a how-to line where only a reader can avoid it.

## Why its value is medium

Each trap cost a session a failed burst, a stuck import or a red verdict with no code fault; none blocks a feature, and each fix is one
file.

## Open steps

- [ ] Susan from HR: "If only the config author had been warned that a file and a same-named folder clash": the pair broke every import at
      once. `pwsh/Base.Config/Get-Config.ps1` throws, naming both paths, when `configs/<name>.yml` and `configs/<name>/` sit side by side;
      it is on the import path, so it lands by `Invoke-StagedBurst` (check:
      `Invoke-TestFile -Path     pwsh/Base.Config/tests/Get-Config.Tests.ps1 -PassThru` shows the pair refused).
- [ ] Susan from HR: "If only the C# splitter had been told one public class per types file": a split into partial classes failed the
      loader. `docs/how-to/getting-started/BCL/add-a-dotnet-type.md` gains the rule that a `types/<Name>.cs` declares one public class
      `<Name>`, a split uses public static helper classes, never partial classes, and its test file takes a real type's name (check:
      `Test-Links -Path docs/how-to/getting-started/BCL/add-a-dotnet-type.md` reports 0 issues and a Grep finds `partial`).
- [ ] Susan from HR: "If only the asserter had known -ErrorText is built eagerly" and "If only the list builder had known PowerShell
      flattens": two strict-mode reds. `docs/how-to/automation/strict-mode-traps.md` gains both traps: an `-ErrorText` string is evaluated
      even when the assert passes, and nested `@(@())` flattens where `[pscustomobject]` rows do not (check:
      `Test-Links -Path     docs/how-to/automation/strict-mode-traps.md` reports 0 issues and a Grep finds `ErrorText`).
- [ ] Susan from HR: "If only the burst script author had known .NET keeps its own cwd": `[IO.File]` calls on relative paths resolved under
      out/. `pwsh/.internal/assets/Invoke-StagedBurst.ps1` sets the .NET current directory to the repository root for its steps and restores
      it after (check: `Invoke-TestFile -Path pwsh/.internal/tests/Invoke-StagedBurst.Tests.ps1 -PassThru` shows a step's
      `[System.Environment]::CurrentDirectory` equal to the root).
- [ ] Susan from HR: "If only the stopped run had let go": a stopped run blocked the next until its lease ended.
      `pwsh/.internal/assets/Invoke-CatzcCommand.ps1` releases `Local\catzc-run` when its process is stopped, first proven red by a test
      that stops a holder (check: `Invoke-TestFile -Path pwsh/.internal/tests/Wait-CatzcRunLock.Tests.ps1 -PassThru` shows the lock taken at
      once after a holder is stopped).
- [ ] Susan from HR: "If only the path rewriter had been fenced off the logs": a rewrite edited append-only lines.
      `pwsh/Base.Drs/Update-DrsCitation.ps1` skips `.claude/learnings` and `.claude/hindsight` (check:
      `Invoke-TestFile -Path     pwsh/Base.Drs/tests/Update-DrsCitation.Tests.ps1 -PassThru` shows a log line left as it was).
- [ ] Susan from HR: "If only the rebuild-hash tests knew about bursts": a peer swap between their two builds failed them with no code
      fault. `pwsh/.internal/tests/Invoke-ModuleBuild.Tests.ps1` builds both hashes from one snapshot of the tree, never the live tree twice
      (check: `Invoke-TestFile -Path pwsh/.internal/tests/Invoke-ModuleBuild.Tests.ps1 -PassThru` passes).
- [ ] Susan from HR: "If only the kit editor had reinstalled" with the raster, glyph, rasterizer and contract-path halves: five
      rediscoveries in the diagram kit. `docs/how-to/pwsh/build-all-diagrams.md` gains one section: an edited `python/diagrams/*.py` needs
      the workspace reinstall before a render sees it, what the PNG raster paints, where the glyph styles live, the headless-Edge route for
      an SVG, and that the kit spells contract-group paths literally (check: `Test-Links -Path docs/how-to/pwsh/build-all-diagrams.md`
      reports 0 issues).
- [ ] Susan from HR: "If only the C# burst had written its contract": a cache hit left the types contract stale.
      `pwsh/.internal/assets/bootstrap/Import-CSharpTypes.ps1` runs `Write-TypesContract` on a cache hit whose contract is missing or
      differs, on the import path, so by `Invoke-StagedBurst` (check:
      `Invoke-TestFile -Path     pwsh/.internal/tests/Import-CSharpTypes.Tests.ps1 -PassThru` shows the contract written on a cache hit).
- [ ] Susan from HR: the log's own heading: `Add-SessionLearning` titles a new log file with its hash, and a hash whose letters run four
      long reads as a word `Test-Spelling` flags, which the coordinator fixed by hand in one hindsight file on 2026-10-27.
      `pwsh/Base.Docs/Add-SessionLearning.ps1` writes the title without the hash, which the file name already carries (check:
      `Invoke-TestFile -Path     pwsh/Base.Docs/tests/Add-SessionLearning.Tests.ps1 -PassThru` shows a new file titled without its hash).

## Refs

- The hindsight log `.claude/hindsight/`, Jack's lines of 2026-10-27; ADR-REPO-PLANS; the debt-reduce skill.
