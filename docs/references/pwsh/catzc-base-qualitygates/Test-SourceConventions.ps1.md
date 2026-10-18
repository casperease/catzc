# pwsh/Catzc.Base.QualityGates/Test-SourceConventions.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Quality gate: every source and test file under pwsh/ follows the naming and one-function conventions.

### description

A quality gate ([ADR-AUTO-TEST-QUALITYGATE](../../../adr/automation/test-automation.md#rule-adr-auto-test-qualitygate)) over the per-function source files and
the test files. It enumerates the tree once with `[System.IO]`
([ADR-PWSH-PESTER-SYSTEMIOONHOTPATHS](../../../adr/pwsh/pester-testing.md#rule-adr-pwsh-pester-systemioonhotpaths)), parses each source file once, and collects every issue:

- every source file (a module-root .ps1, or a `private/*.ps1` not starting with '_') is named Verb-Noun, holds exactly one top-level
  function, and that function is named for the file;
- every function name (public and private) is defined in exactly one file;
- every test file directly under a tests/ folder is named Verb-Noun.Tests.ps1
  ([ADR-PWSH-PESTER-TESTFILE](../../../adr/pwsh/pester-testing.md#rule-adr-pwsh-pester-testfile));
- every test file under tests/types/ is named for a C# type (a `types/*.cs`) of its module;
- every literal Set-ItResult -Because reason is a constrained skip key (lowercase alnum segments joined by '_', e.g. `windows_only_<detail>`
  or `tool_<name>_missing`), never prose, so the skip report groups by a stable vocabulary. A computed reason cannot be checked statically
  and is left out.

Dot-prefixed folders hold no source files; their tests/ folders are scanned (except .vendor and .scriptanalyzer). It reads the per-function
source files, which exist only in the source tree (Assert-SourceTree).

Two source checks run beside these, each with its mode and exempt globs in configs/source-conventions.yml
(Catzc.Base.QualityGates.SourceConventionsConfig). In gate mode a check's findings are issues; in report mode they are printed as its work
list (Write-ReportModeFinding) and never fail the run.

- engine_set: the engine set is never restated ([ADR-AUTO-ENGINE-THREEENGINES](../../../adr/automation/execution-engines.md#rule-adr-auto-engine-threeengines)) —
  in any git-tracked markdown, PowerShell, C#, or YAML file, a literal engine list in code or a partial or miscounted engine set in prose
  (Get-EngineSetFinding), with the engine names read from `[Catzc.Base.Engines.ExecutionEngines]`;
- neutral_codes: an L0 test's fixture data names no real ADR code
  ([ADR-AUTO-TEST-DISTINCTFIXTUREIDENTITIES](../../../adr/automation/test-automation.md#rule-adr-auto-test-distinctfixtureidentities)) — in every test file, a code the ADR registry declares
  (Get-AdrCitationMap) in a string literal of an L0 block, outside -Tag (Get-NeutralCodeFinding).

Both leave out the files the content tools leave as written (Get-ContentExemptPath: vendored, generated, fixture, contract).

### parameter `OutputFolder`

The report base folder. Defaults to out/test-source-conventions/ (Write-QualityGateReport).

### parameter `PassThru`

Return the result ({ Subject; IssueCount; Issues; ReportPath; SourceFiles; TestFiles; SkipReasons; EngineSetCount; NeutralCodeCount;
EngineSet; NeutralCodes }) instead of throwing on issues. EngineSet and NeutralCodes list each check's findings whatever its mode.

### outputs

`[Catzc.Base.Reports.QualityGateResult]` With -PassThru only.

### example 1

```powershell
Test-SourceConventions
```

## comment:1

Above `$typesTestDirectory = Join-Path $testsDirectory 'types'`, written with `#`.

```text
tests/types/ holds the native-type tests, named for their type (which has no verb) — so each must name a
real types/*.cs of the module, and the folder cannot collect misplaced or misnamed tests.
```
