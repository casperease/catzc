# docs/how-to/automation/manual-test-plan/static-analysis.md

`Manual test plan — Static analysis`

PSScriptAnalyzer, the formatter, and the analyzer-to-ADR map. Part of the [manual test plan](../manual-test-plan.md), which says how to run
a check.

## Index

| #   | Tier | Test file                                                                        | FullNameFilter                                          | Guards                                                                                                                                                  |
| --- | ---- | -------------------------------------------------------------------------------- | ------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 1   | L1   | automation/Catzc.Base.QualityGates/tests/Get-AnalyzerAdrCoverage.Tests.ps1       | analyzer-adr-map integrity                              | `Test-AnalyzerAdrMap` reports 0 issues: every analyzer→ADR mapping cites a real rule, and every custom analyzer rule is listed in analyzer-adr-map.yml. |
| 2   | L2   | automation/.internal/tests/Test-ScriptAnalyzer.Tests.ps1                         | PSScriptAnalyzer                                        | All module code passes PSScriptAnalyzer (style + custom rules).                                                                                         |
| 3   | L2   | automation/.internal/tests/Get-DynamicManifestContent.Tests.ps1                  | Get-DynamicManifestContent is formatter-stable          | Every built module manifest is byte-stable under the repo formatter (`Test-BuildArtifact -Facet Manifest` reports 0 issues).                            |
| 4   | L2   | automation/Catzc.Base.QualityGates/tests/Format-Automation.Tests.ps1             | Format-Automation (real vendored analyzer and settings) | Format-Automation loads PSScriptAnalyzer and its settings from the active code root (`.vendor`, `.internal/assets`).                                    |
| 5   | L2   | automation/Catzc.Base.QualityGates/tests/Get-ScriptAnalyzerDiagnostics.Tests.ps1 | Get-ScriptAnalyzerDiagnostics (real vendored analyzer)  | The analysis engine imports the vendored PSScriptAnalyzer from the active code root and reports real diagnostics.                                       |
| 6   | L2   | automation/Catzc.Base.QualityGates/tests/Test-ScriptAnalyzer.Tests.ps1           | Test-ScriptAnalyzer (real analyzer)                     | The analyzer gate runs the vendored PSScriptAnalyzer with the shipped settings from the active code root.                                               |
| 7   | L2   | automation/Catzc.Base.QualityGates/tests/Test-Formatting.Tests.ps1               | Repository formatting integrity                         | The repository's Markdown, gated PowerShell, and C# type namespaces are formatted (Test-Formatting reports none).                                       |

## Checks

### 2. PSScriptAnalyzer

**Guards:** all PowerShell module code meets the analyzer rule set.

**Checks:**

- The file set includes >50 module files (guards against a no-op).
- No PSScriptAnalyzer violation across module roots, `private/`, and `tests/` (built-in + custom rules).

**Prerequisite:** PSScriptAnalyzer (vendored).

### 3. Get-DynamicManifestContent is formatter-stable

**Guards:** a generated module manifest's canonical form equals what the repo formatter produces, so a published (immutable, versioned)
manifest never churns when it is later re-formatted.

**Checks:**

- `Test-BuildArtifact -Facet Manifest` reports 0 issues: over a fresh build, `Format-Automation -DryRun` (the shipped
  `PSScriptAnalyzerSettings.psd1`) would leave every built manifest (`Catzc.psd1` and each `<Module>.psd1`) byte-for-byte unchanged.

**Prerequisite:** PSScriptAnalyzer (vendored).
