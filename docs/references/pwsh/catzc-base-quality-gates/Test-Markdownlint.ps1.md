# pwsh/Catzc.Base.QualityGates/Test-Markdownlint.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Lints the repository's Markdown with markdownlint-cli2 and writes a report under out/.

### description

Runs markdownlint-cli2 over the repository's in-scope Markdown, applying the single root rule set at /.markdownlint.yml (auto-discovered by
markdownlint-cli2). Excludes transient and out-of-scope trees (out/, every .vendor/, .venv/, .pytest_cache/ and node_modules/ tree,
docs/notes/, .unordered/) via negation globs — markdownlint-cli2 does not apply .markdownlintignore to globs passed on the command line, so
the exclusions are passed explicitly. The root .markdownlintignore mirrors these for the editor extension's benefit.

A quality gate ([ADR-AUTO-TEST-QUALITYGATE](../../../drs/automation/test-automation.md#rule-adr-auto-test-qualitygate)): every violation
line ('`<path>:<line>:<col>` `<rule id>/<rule name>` …') is an issue, and the gate ends through Write-QualityGateReport, which writes
out/test-markdownlint/, prints every issue, and throws once listing them all; -PassThru returns the result object instead. A tool error
(exit > 1) throws before the report.

markdownlint-cli2 must be on PATH — install it once with Install-Markdownlint (or: npm install -g markdownlint-cli2).

### parameter `Path`

Repository-relative paths or globs to lint (markdownlint-cli2 expands a glob). Defaults to the repository's in-scope Markdown, with the
out-of-scope trees excluded via '!'-negation globs.

### parameter `OutputFolder`

The report base folder. Defaults to `<out>/test-markdownlint`.

### parameter `PassThru`

Return a result object ({ Subject, IssueCount, Issues, ReportPath, FileCount, ExitCode }) instead of throwing.

### example 1

```powershell
Test-Markdownlint
```

### example 2

```powershell
$result = Test-Markdownlint -PassThru
$result.IssueCount
```
