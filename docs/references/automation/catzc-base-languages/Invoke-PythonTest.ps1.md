---
catzc:
  derived:
    path: docs/references/automation/catzc-base-languages/Invoke-PythonTest.ps1.md
    kind: comment-page
    language: markdown
    filetype: md
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "946a8e5b52bb"
    adrs:
      - ADR-AUTO-ENVVAR#1
      - ADR-AUTO-PY#6
---

# automation/Catzc.Base.Languages/Invoke-PythonTest.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$pythonRelative = (Get-Config -Config python).ResolveRoot($root)`, written with `#`.

```text
The Python root from python.yml (PythonConfig.ResolveRoot: the declared root, else python/ when present, else
.python/): the uv workspace root.
```

## comment:2

Above `$uvPath = if ($UvExecutable) {`, written with `#`.

```text
The managed uv, by its path: the caller's, already located and checked, or located here from its tools.yml entry
(Resolve-ToolExecutable); never a bare uv off PATH.
```

## comment:3

Above `$environment = Get-EngineContract -Engine $Engine -EngineExecutable...`, written with `#`.

```text
How the tests start the engine (Get-EngineContract) is an external contract with the test processes
([ADR-AUTO-ENVVAR#1](/docs/adr/automation/environment-variables.md#rule-adr-auto-envvar1)): set for these
commands only, then restored. UV_PYTHON_DOWNLOADS=never keeps uv on the managed interpreter at the pin
([ADR-AUTO-PY#6](/docs/adr/automation/python/python-test-artifacts.md#rule-adr-auto-py6)).
```

## comment:4

Above `if ($run.ExitCode -ne 0 -and -not ($run.ExitCode -eq 1 -and @($results |...`, written with `#`.

```text
pytest exits 1 when a test failed; any other non-zero exit, or 1 with no failing test, means it failed around
the tests (a usage or collection error, or no tests collected: exit 5).
```
