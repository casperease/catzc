# docs/references/automation/catzc-base-qualitygates/private/Invoke-RuffFormat.ps1.md

`automation/Catzc.Base.QualityGates/private/Invoke-RuffFormat.ps1`

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
One Format-Code engine adapter ([ADR-PRIN-CONFIG#2](/docs/adr/principles/configure-not-program.md#rule-adr-prin-config2)).
ruff is pinned in python.yml and runs from the Python test workspace's environment with the workspace's settings
(the 140-column line, the pinned Python) for every file, wherever it lives (Invoke-PythonWorkspaceTool;
[ADR-AUTO-PY#8](/docs/adr/automation/python/python-test-artifacts.md#rule-adr-auto-py8)).
`ruff format --check` names the files whose formatting differs; without -DryRun, `ruff format` rewrites exactly
those. Throws with "Run Install-Uv" when no uv at the pin is found, and with ruff's message for a file it cannot
parse.
```
