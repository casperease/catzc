# automation/Catzc.Base.QualityGates/private/Invoke-RuffFormat.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its
comment sat above (Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

The ruff formatter engine: formats the given Python files with the pinned ruff and returns the files it changed.

### description

One Format-Code engine adapter ([ADR-PRIN-CONFIG#2](../../../../adr/principles/configure-not-program.md#rule-adr-prin-config2)).
ruff is pinned in python.yml and runs from the Python test workspace's environment with the workspace's settings
(the 140-column line, the pinned Python) for every file, wherever it lives (Invoke-PythonWorkspaceTool;
[ADR-AUTO-PY#8](../../../../adr/automation/python/python-test-artifacts.md#rule-adr-auto-py8)).
`ruff format --check` names the files whose formatting differs; without -DryRun, `ruff format` rewrites exactly
those. Throws with "Run Install-Uv" when no uv at the pin is found, and with ruff's message for a file it cannot
parse.

### parameter File

Absolute paths of the .py files to format.

### parameter DryRun

List the files ruff would change without writing them.

### outputs

`[string[]]` Absolute paths of the files changed (or, under -DryRun, that would change).
