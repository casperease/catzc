---
catzc:
  immutable:
    with_body_sha: fe3b340399ec
    repo_status: clean
    path: docs/how-to/automation/manual-test-plan/static-analysis.md
    folder: docs/how-to/automation/manual-test-plan
    name: static-analysis
    filetype: md
    kind: how-to
    language: markdown
    track: docs
    tracktype: documentation
  edges:
    cites:
      - ADR-AUTO-BASH#6
      - ADR-AUTO-PY#8
      - ADR-PRIN-CONFIG#{2,4}
      - ADR-PWSH-ASSERT#1
    links:
      - docs/how-to/automation/manual-test-plan.md
---

# Manual test plan — Static analysis

PSScriptAnalyzer, the formatter, and the analyzer-to-ADR map. Part of the [manual test plan](../manual-test-plan.md), which says how to run
a check.

## Index

| #   | Tier | Test file                                                                        | FullNameFilter                                         | Guards                                                                                                                                                                                               |
| --- | ---- | -------------------------------------------------------------------------------- | ------------------------------------------------------ | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 1   | L1   | automation/Catzc.Base.QualityGates/tests/Get-AnalyzerAdrCoverage.Tests.ps1       | analyzer-adr-map integrity                             | `Test-AnalyzerAdrMap` reports 0 issues: every analyzer→ADR mapping cites a real rule, and every custom analyzer rule is listed in analyzer-adr-map.yml.                                              |
| 2   | L2   | automation/.internal/tests/Test-ScriptAnalyzer.Tests.ps1                         | PSScriptAnalyzer                                       | All module code passes PSScriptAnalyzer (style + custom rules).                                                                                                                                      |
| 3   | L2   | automation/.internal/tests/Get-DynamicManifestContent.Tests.ps1                  | Get-DynamicManifestContent is formatter-stable         | Every built module manifest is byte-stable under the repo formatter (`Test-BuildArtifact -Facet Manifest` reports 0 issues).                                                                         |
| 4   | L2   | automation/Catzc.Base.QualityGates/tests/Format-Code.Tests.ps1                   | Format-Code (real vendored analyzer and settings)      | Format-Code's PSScriptAnalyzer engine loads PSScriptAnalyzer and its settings from the active code root (`.vendor`, `.internal/assets`).                                                             |
| 5   | L2   | automation/Catzc.Base.QualityGates/tests/Get-ScriptAnalyzerDiagnostics.Tests.ps1 | Get-ScriptAnalyzerDiagnostics (real vendored analyzer) | The analysis engine imports the vendored PSScriptAnalyzer from the active code root and reports real diagnostics.                                                                                    |
| 6   | L2   | automation/Catzc.Base.QualityGates/tests/Test-ScriptAnalyzer.Tests.ps1           | Test-ScriptAnalyzer (real analyzer)                    | The analyzer quality gate runs the vendored PSScriptAnalyzer with the shipped settings from the active code root.                                                                                    |
| 7   | L2   | automation/Catzc.Base.QualityGates/tests/Test-Formatting.Tests.ps1               | Repository formatting integrity                        | Every file language with a formatter in languages.yml, and the C# type namespaces, are formatted (Test-Formatting reports none).                                                                     |
| 8   | L1   | automation/Catzc.Base.Timeouts/tests/Get-TimeoutSeconds.Repository.Tests.ps1     | TimeoutSeconds defaults come from the time safeguard   | No shipped function defaults a `-TimeoutSeconds` parameter to a number literal; long-running functions declare `[TimeLimit]` (ADR-PWSH-ASSERT#1).                                                    |
| 9   | L2   | automation/Catzc.Base.QualityGates/tests/Test-PythonLint.Tests.ps1               | Repository Python lint integrity                       | Every Python file the repository holds — the Python tests and the agent helpers — passes the pinned `ruff check` (ADR-AUTO-PY#8).                                                                    |
| 10  | L2   | automation/Catzc.Base.QualityGates/tests/Test-ShellScripts.Tests.ps1             | Repository shell script integrity                      | Every shell script the repository tracks is LF, carries the executable bit when it has a shebang, and passes the pinned ShellCheck (ADR-AUTO-BASH#6).                                                |
| 11  | L0   | automation/Catzc.Base.QualityGates/tests/Format-Code.Tests.ps1                   | Format-Code engines                                    | Every formatter engine languages.yml may name has its adapter, and the shipped languages.yml gives every file language a formatter or the reason it has none (ADR-PRIN-CONFIG#2, ADR-PRIN-CONFIG#4). |

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

- `Test-BuildArtifact -Facet Manifest` reports 0 issues: over a fresh build, `Format-Code -Language powershell -DryRun` (the shipped
  `PSScriptAnalyzerSettings.psd1`) would leave every built manifest (`Catzc.psd1` and each `<Module>.psd1`) byte-for-byte unchanged.

**Prerequisite:** PSScriptAnalyzer (vendored).
