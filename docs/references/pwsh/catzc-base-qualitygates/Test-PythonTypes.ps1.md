# pwsh/Catzc.Base.QualityGates/Test-PythonTypes.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Quality gate: type-checks every Python file the repository holds with pyright, the engine Pylance runs in the editor.

### description

Runs `pyright` over every .py file the repository holds (Get-PythonCheckScope: the Python test folders, and the tracked .py files outside
the Python root, such as the agent helpers under .claude/;
[ADR-AUTO-PY-EVERYFILETYPECHECKED](../../../adr/automation/python/python-test-artifacts.md#rule-adr-auto-py-everyfiletypechecked)), with the pinned pyright and the Python test
workspace's `[tool.pyright]` settings (Invoke-PythonWorkspaceTool, `--project pyproject.toml`). The type-checking mode is `python.yml`'s
`type_checking`, the same mode the generated VS Code settings give Pylance, so the gate and the editor report the same findings. Every error
and warning is one issue: '`<file>:<line>:<column>`: `<severity>` `<rule>` `<message>`'; information diagnostics are not issues.

Ends with Write-QualityGateReport: the report lands in out/test-python-types/, and the gate throws once listing every issue (or returns the
result with -PassThru). Needs the managed uv only when the repository holds Python, and the source tree (Assert-SourceTree).

### parameter `OutputFolder`

The report base folder. Defaults to Write-QualityGateReport's (out/test-python-types).

### parameter `PassThru`

Return the gate result { Subject; IssueCount; Issues; ReportPath; Files } instead of throwing on issues.

### outputs

`[Catzc.Base.Reports.QualityGateResult]` With -PassThru only.

### example 1

```powershell
Test-PythonTypes
```

### example 2

```powershell
(Test-PythonTypes -PassThru).Issues
```
