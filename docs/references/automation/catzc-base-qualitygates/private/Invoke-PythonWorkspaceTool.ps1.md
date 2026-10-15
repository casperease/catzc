---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/private/Invoke-PythonWorkspaceTool.ps1.md
    kind: reference
    body_sha: "86e086671781"
    adrs:
      - ADR-AUTO-PY#8
---

# automation/Catzc.Base.QualityGates/private/Invoke-PythonWorkspaceTool.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The Python checks run one pinned tool set for every .py file the repository tracks — the Python tests, and the agent
helpers under .claude/ ([ADR-AUTO-PY#8](/docs/adr/automation/python/python-test-artifacts.md#rule-adr-auto-py8)).
The tools are the workspace's dependencies (python.yml), so this syncs the workspace once (`uv sync --all-packages`)
and runs `uv run --no-sync <tool> <arguments> --config pyproject.toml <files>` from the workspace root, the Python
root: the explicit --config gives every file the workspace's ruff settings (the 140-column line, the pinned Python),
wherever it lives.

uv is the managed uv (Resolve-ToolExecutable, the tools.yml `uv` entry), run with UV_PYTHON_DOWNLOADS=never so it
never fetches an interpreter; the variable is restored afterwards. Throws with "Run Install-Uv" when no uv at the pin
is found, and with uv's output when the sync fails (a missing interpreter names Install-Python).
```
