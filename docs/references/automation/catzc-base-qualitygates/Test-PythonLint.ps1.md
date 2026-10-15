---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/Test-PythonLint.ps1.md
    kind: reference
    body_sha: "6f6827f4cb31"
    adrs:
      - ADR-AUTO-PY#8
---

# automation/Catzc.Base.QualityGates/Test-PythonLint.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Runs `ruff check` over every .py file the repository holds (Get-PythonCheckScope: the Python test folders, and the
tracked .py files outside the Python root, such as the agent helpers under .claude/;
[ADR-AUTO-PY#8](/docs/adr/automation/python/python-test-artifacts.md#rule-adr-auto-py8)), with the pinned ruff and
the Python test workspace's settings (Invoke-PythonWorkspaceTool). Every finding is one issue, as ruff reports it:
'<file>:<line>:<column>: <code> <message>'. The Python test bridge runs the same check on a test folder before its
tests; this gate covers the files no test run reads.

Ends with Write-QualityGateReport: the report lands in out/test-python-lint/, and the gate throws once listing every
issue (or returns the result with -PassThru). Needs the managed uv only when the repository holds Python, and the
source tree (Assert-SourceTree).
```

## comment:2

Above `$check = Invoke-PythonWorkspaceTool -Tool 'ruff check --output-format...`.

```text
--output-format concise prints one '<file>:<line>:<column>: <code> <message>' line per finding; exit 1 means
findings, anything above it means ruff itself failed.
```
