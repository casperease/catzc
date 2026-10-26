# pwsh/Base.QualityGates/Test-PythonLint.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Lints every Python file the repository holds with ruff.

### description

Runs `ruff check` over every .py file the repository holds (Get-PythonCheckScope: the Python test folders, and the tracked .py files outside
the Python root, such as the agent helpers under .claude/;
[ADR-AUTO-PY-EVERYFILELINTED](../../../drs/automation/python/python-test-artifacts.md#rule-adr-auto-py-everyfilelinted)), with the pinned
ruff and the Python test workspace's settings (Invoke-PythonWorkspaceTool). Every finding is one issue, as ruff reports it:
'`<file>:<line>:<column>`: `<code>` `<message>`'. The Python test bridge runs the same check on a test folder before its tests; this gate
covers the files no test run reads.

Ends with Write-QualityGateReport: the report lands in out/test-python-lint/, and the gate throws once listing every issue (or returns the
result with -PassThru). Needs the managed uv only when the repository holds Python, and the source tree (Assert-SourceTree).

### parameter `OutputFolder`

The report base folder. Defaults to Write-QualityGateReport's (out/test-python-lint).

### parameter `PassThru`

Return the gate result { Subject; IssueCount; Issues; ReportPath; Files } instead of throwing on issues.

### outputs

`[Catzc.Base.Reports.QualityGateResult]` With -PassThru only.

### example 1

```powershell
Test-PythonLint
```

### example 2

```powershell
(Test-PythonLint -PassThru).Issues
```

## comment:1

Above `$check = Invoke-PythonWorkspaceTool -Tool 'ruff check --output-format...`, written with `#`.

```text
--output-format concise prints one '<file>:<line>:<column>: <code> <message>' line per finding; exit 1 means
findings, anything above it means ruff itself failed.
```
