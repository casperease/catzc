# pwsh/Base.ModuleSystem/Test-CheckedInBinaries.ps1

A quality gate that keeps every tracked binary byte-exact: git must not apply line-ending conversion to it, and a `.gitattributes` rule must
mark it binary. It follows the content, never an extension list.

## help

### synopsis

Checks that every checked-in binary in the repository is stored byte-exact.

### description

A quality gate ([ADR-AUTO-TEST-QUALITYGATE](../../../drs/automation/test-automation.md#rule-adr-auto-test-qualitygate)) over every tracked
file — the vendored modules (`pwsh/.vendor/**`) and the committed combined C# types assembly (`pwsh/.compiled/**`, see the caching record)
as much as the diagrams and documents under docs/. A tracked file is a binary the way git decides — a NUL byte in its first 8000 bytes — so
the gate follows the content, not an extension list, and a binary of a type .gitattributes does not name yet fails here instead of slipping
by. For each binary it collects an issue when:

- git stores it as text: `git ls-files --eol` reports its index EOL as lf, crlf, or mixed (git applied EOL conversion and corrupted the
  bytes) rather than -text;
- no .gitattributes rule marks it binary: `git check-attr binary` reports `set` only when a rule applies (it never sniffs content), so this
  fails as soon as a rule is removed, before any corruption.

It drives the git CLI over the repository's index and .gitattributes, which exist only in a git work tree.

### parameter `OutputFolder`

The report base folder. Defaults to out/test-checked-in-binaries/ (Write-QualityGateReport).

### parameter `PassThru`

Return the result ({ Subject; IssueCount; Issues; ReportPath; Binaries }) instead of throwing on issues.

### outputs

`[Catzc.Base.Reports.QualityGateResult]` With -PassThru only.

### example 1

```powershell
Test-CheckedInBinaries
```
