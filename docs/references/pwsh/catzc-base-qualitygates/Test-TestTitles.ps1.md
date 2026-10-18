# pwsh/Catzc.Base.QualityGates/Test-TestTitles.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Quality gate: no test title carries an angle-bracket template token unless its block is data-driven.

### description

A quality gate ([ADR-AUTO-TEST-QUALITYGATE](../../../adr/automation/test-automation.md#rule-adr-auto-test-qualitygate)) over the titles of
every It, Describe, and Context in the test files (except the vendored ones). Pester treats an angle-bracket word in a title as its name
template and expands it as a variable in the test's scope. With -ForEach or -TestCases data that is the intended feature; without data the
token is almost always prose (a placeholder path), which expands to empty in a non-strict scope and THROWS in a strict one — and the tests
run strict ([ADR-AUTO-TEST-FILEPARALLELISM](../../../adr/automation/test-automation.md#rule-adr-auto-test-fileparallelism)), so such a title
fails its file at name expansion, far from the cause. Each such title is an issue: rephrase it, or add -ForEach data.

The title is a block's first string argument (single- or double-quoted). A file that does not parse is another gate's problem and is
skipped. It parses the repository's test files, which exist only in the source tree (Assert-SourceTree).

### parameter `OutputFolder`

The report base folder. Defaults to out/test-test-titles/ (Write-QualityGateReport).

### parameter `PassThru`

Return the result ({ Subject; IssueCount; Issues; ReportPath; TestFiles }) instead of throwing on issues.

### outputs

`[Catzc.Base.Reports.QualityGateResult]` With -PassThru only.

### example 1

```powershell
Test-TestTitles
```
