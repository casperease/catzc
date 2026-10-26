# pwsh/Base.QualityGates/Test-Markdownlint.ps1

The quality gate that lints Markdown: it runs markdownlint-cli2 over the repository's Markdown and writes a report to the output folder.

## help

### synopsis

Lints the repository's Markdown with markdownlint-cli2 and writes a report to the output folder.

### description

Runs markdownlint-cli2 over the repository's in-scope Markdown, applying the single root rule set at /.markdownlint.yml (auto-discovered by
markdownlint-cli2). The default scope is the markdown-scope glob set of Catzc.Base.Globs: its Markdown include as the target and each of its
excludes (transient and out-of-scope trees such as out/, every .vendor/, .venv/ and node_modules/ tree, docs/notes/, .unordered/) as a
negation glob — markdownlint-cli2 does not apply .markdownlintignore to globs passed on the command line, so the exclusions are passed
explicitly. The root .markdownlintignore mirrors these for the editor extension's benefit. A long path list is linted in batches of
batch_size paths (markdownlint.yml, default 50).

A quality gate ([ADR-AUTO-TEST-QUALITYGATE](../../../drs/automation/test-automation.md#rule-adr-auto-test-qualitygate)): every violation
line ('`<path>:<line>:<col>` `<rule id>/<rule name>` …') is an issue, and the gate ends through Write-QualityGateReport, which writes
out/test-markdownlint/, prints every issue, and throws once listing them all; -PassThru returns the result object instead. A tool error
(exit > 1) throws before the report.

markdownlint-cli2 must be on PATH — install it once with Install-Markdownlint (or: npm install -g markdownlint-cli2).

### parameter `Path`

Repository-relative paths or globs to lint (markdownlint-cli2 expands a glob). A folder lints the Markdown under it only, never its images,
PDFs or YAML. Defaults to the markdown-scope glob set: its Markdown include, its excludes as '!'-negation globs.

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

## Output

The tool runs with `-Silent`, which captures the output instead of streaming it to the console, because the report prints the issues.
