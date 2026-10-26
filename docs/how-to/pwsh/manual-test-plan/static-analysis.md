# Manual test plan — Static analysis

PSScriptAnalyzer, the formatter, and the analyzer-to-ADR map. Part of the [manual test plan](../manual-test-plan.md), which says how to run
a check.

## Index

| #   | Tier | Check                                                        |
| --- | ---- | ------------------------------------------------------------ |
| 1   | L1   | [analyzer-adr-map integrity][c1]                             |
| 2   | L2   | [PSScriptAnalyzer][c2]                                       |
| 3   | L2   | [Get-DynamicManifestContent is formatter-stable][c3]         |
| 4   | L2   | [Format-Code (real vendored analyzer and settings)][c4]      |
| 5   | L2   | [Get-ScriptAnalyzerDiagnostics (real vendored analyzer)][c5] |
| 6   | L2   | [Test-ScriptAnalyzer (real analyzer)][c6]                    |
| 7   | L2   | [Repository formatting integrity][c7]                        |
| 8   | L1   | [TimeoutSeconds defaults come from the time safeguard][c8]   |
| 9   | L2   | [Repository Python lint integrity][c9]                       |
| 10  | L2   | [Repository shell script integrity][c10]                     |
| 11  | L0   | [Format-Code engines][c11]                                   |
| 12  | L1   | [The shipped format engines' keyed settings][c12]            |
| 13  | L2   | [Repository Python type integrity][c13]                      |
| 14  | L2   | [Format-FileMeta on the repository][c14]                     |
| 15  | L1   | [Test-FileLimits — the real tree][c15]                       |
| 16  | L1   | [Test-TrackMemberCommitted — the real tree][c16]             |
| 17  | L1   | [Get-OutputRoot — no default reaches the output track][c17]  |

[c1]: #1-analyzer-adr-map-integrity
[c2]: #2-psscriptanalyzer
[c3]: #3-get-dynamicmanifestcontent-is-formatter-stable
[c4]: #4-format-code-real-vendored-analyzer-and-settings
[c5]: #5-get-scriptanalyzerdiagnostics-real-vendored-analyzer
[c6]: #6-test-scriptanalyzer-real-analyzer
[c7]: #7-repository-formatting-integrity
[c8]: #8-timeoutseconds-defaults-come-from-the-time-safeguard
[c9]: #9-repository-python-lint-integrity
[c10]: #10-repository-shell-script-integrity
[c11]: #11-format-code-engines
[c12]: #12-the-shipped-format-engines-keyed-settings
[c13]: #13-repository-python-type-integrity
[c14]: #14-format-filemeta-on-the-repository
[c15]: #15-test-filelimits--the-real-tree
[c16]: #16-test-trackmembercommitted--the-real-tree
[c17]: #17-get-outputroot--no-default-reaches-the-output-track

## Checks

### 1. analyzer-adr-map integrity

**Test file:** `pwsh/Catzc.Base.QualityGates/tests/Get-AnalyzerDrsCoverage.Tests.ps1` (L1), block `analyzer-adr-map integrity`.

**Guards:** `Test-AnalyzerDrsMap` reports 0 issues: every analyzer→rule mapping cites a real rule, and every custom analyzer rule is listed
in analyzer-drs-map.yml.

### 2. PSScriptAnalyzer

**Test file:** `pwsh/.internal/tests/Test-ScriptAnalyzer.Tests.ps1` (L2), block `PSScriptAnalyzer`.

**Guards:** all PowerShell module code meets the analyzer rule set.

**Checks:**

- The file set includes >50 module files (guards against a no-op).
- No PSScriptAnalyzer violation across module roots, `private/`, and `tests/` (built-in + custom rules).

**Prerequisite:** PSScriptAnalyzer (vendored).

### 3. Get-DynamicManifestContent is formatter-stable

**Test file:** `pwsh/.internal/tests/Get-DynamicManifestContent.Tests.ps1` (L2), block `Get-DynamicManifestContent is formatter-stable`.

**Guards:** a generated module manifest's canonical form equals what the repo formatter produces, so a published (immutable, versioned)
manifest never churns when it is later re-formatted.

**Checks:**

- `Test-BuildArtifact -Facet Manifest` reports 0 issues: over a fresh build, `Format-Code -Language powershell -DryRun` (the shipped
  `PSScriptAnalyzerSettings.psd1`) would leave every built manifest (`Catzc.psd1` and each `<Module>.psd1`) byte-for-byte unchanged.

**Prerequisite:** PSScriptAnalyzer (vendored).

### 4. Format-Code (real vendored analyzer and settings)

**Test file:** `pwsh/Catzc.Base.QualityGates/tests/Format-Code.Tests.ps1` (L2), block `Format-Code (real vendored analyzer and settings)`.

**Guards:** Format-Code's PSScriptAnalyzer engine loads PSScriptAnalyzer and its settings from the active code root (`.vendor`,
`.internal/assets`).

### 5. Get-ScriptAnalyzerDiagnostics (real vendored analyzer)

**Test file:** `pwsh/Catzc.Base.QualityGates/tests/Get-ScriptAnalyzerDiagnostics.Tests.ps1` (L2), block
`Get-ScriptAnalyzerDiagnostics (real vendored analyzer)`.

**Guards:** The analysis engine imports the vendored PSScriptAnalyzer from the active code root and reports real diagnostics.

### 6. Test-ScriptAnalyzer (real analyzer)

**Test file:** `pwsh/Catzc.Base.QualityGates/tests/Test-ScriptAnalyzer.Tests.ps1` (L2), block `Test-ScriptAnalyzer (real analyzer)`.

**Guards:** The analyzer quality gate runs the vendored PSScriptAnalyzer with the shipped settings from the active code root.

### 7. Repository formatting integrity

**Test file:** `pwsh/Catzc.Base.QualityGates/tests/Test-Formatting.Tests.ps1` (L2), block `Repository formatting integrity`.

**Guards:** Every file language with a formatter in languages.yml, and the C# type namespaces, are formatted (Test-Formatting reports none).

### 8. TimeoutSeconds defaults come from the time safeguard

**Test file:** `pwsh/Catzc.Base.Timeouts/tests/Get-TimeoutSeconds.Repository.Tests.ps1` (L1), block
`TimeoutSeconds defaults come from the time safeguard`.

**Guards:** No shipped function defaults a `-TimeoutSeconds` parameter to a number literal; long-running functions declare `[TimeLimit]`
(ADR-PWSH-ASSERT-DECLAREDTIMELIMIT).

### 9. Repository Python lint integrity

**Test file:** `pwsh/Catzc.Base.QualityGates/tests/Test-PythonLint.Tests.ps1` (L2), block `Repository Python lint integrity`.

**Guards:** Every Python file the repository holds — the Python tests and the agent helpers — passes the pinned `ruff check`
(ADR-AUTO-PY-EVERYFILELINTED).

### 10. Repository shell script integrity

**Test file:** `pwsh/Catzc.Base.QualityGates/tests/Test-ShellScripts.Tests.ps1` (L2), block `Repository shell script integrity`.

**Guards:** Every shell script the repository tracks is LF, carries the executable bit when it has a shebang, and passes the pinned
ShellCheck (ADR-AUTO-BASH-SHELLSCRIPTSCHECKED).

### 11. Format-Code engines

**Test file:** `pwsh/Catzc.Base.QualityGates/tests/Format-Code.Tests.ps1` (L0), block `Format-Code engines`.

**Guards:** Every formatter engine languages.yml may name has its adapter, and the shipped languages.yml gives every file language a
formatter or the reason it has none (PDR-CONFIG-NEWINSTANCEISCONFIGCHANGE, PDR-CONFIG-EXCEPTIONISCONFIGENTRY).

### 12. The shipped format engines' keyed settings

**Test file:** `pwsh/Catzc.Base.QualityGates/tests/Get-FormatEngineStamp.Tests.ps1` (L1), block
`The shipped format engines' keyed settings`.

**Guards:** Each shipped format engine's keyed settings name a top-level key that exists in their file, and an engine never lists the whole
tool registry again (ADR-AUTO-CACHE-CHECKEDFILESACROSSSESSIONS).

### 13. Repository Python type integrity

**Test file:** `pwsh/Catzc.Base.QualityGates/tests/Test-PythonTypes.Tests.ps1` (L2), block `Repository Python type integrity`.

**Guards:** Every Python file the repository holds passes pyright in the mode python.yml names, the one the editor runs
(ADR-AUTO-PY-EVERYFILETYPECHECKED).

### 14. Format-FileMeta on the repository

**Test file:** `pwsh/Catzc.Base.QualityGates/tests/Format-FileMeta.Tests.ps1` (L2), block `Format-FileMeta on the repository`.

**Guards:** a generated page's head belongs to its generator, never to the head formatter (ADR-REPO-FILEMETA-HEADPOLICY).

**Checks:**

- `Format-FileMeta -Path docs/drs/index.md -DryRun` counts 0 files and 0 changes, and leaves the page byte-for-byte unchanged.

### 15. Test-FileLimits — the real tree

**Test file:** `pwsh/Catzc.Base.FileLimits/tests/Test-FileLimits.Tests.ps1` (L1), block `Test-FileLimits — the real tree`.

**Guards:** every tracked file in scope is within its length limit, and the gate runs inside its timeouts.yml roof.

**Checks:**

- `Test-FileLimits` reports 0 issues over every tracked file, inside the `Test-FileLimits` roof of `timeouts.yml`.

### 16. Test-TrackMemberCommitted — the real tree

**Test file:** `pwsh/Catzc.Base.QualityGates/tests/Test-TrackMemberCommitted.Tests.ps1` (L1), block
`Test-TrackMemberCommitted — the real tree`.

**Guards:** every declared track member is in step with the git index.

**Checks:**

- `Test-TrackMemberCommitted` finds every declared member in step with the git index.

### 17. Get-OutputRoot — no default reaches the output track

**Test file:** `pwsh/Catzc.Base.Repository/tests/Get-OutputRoot.OutputOnlyByAddress.Tests.ps1` (L1), block
`Get-OutputRoot — no default reaches the output track`.

**Guards:** no exported check command defaults a parameter into the output track.

**Checks:**

- A fixture command whose parameter default points into `out/` is flagged.
- No exported `Test-*`, `Assert-*` or `Format-*` command has a parameter default that points into `out/`.
