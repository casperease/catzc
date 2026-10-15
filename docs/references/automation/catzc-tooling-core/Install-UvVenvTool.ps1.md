---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-core/Install-UvVenvTool.ps1.md
    kind: comment-page
    body_sha: b8b938fce923
---

# automation/Catzc.Tooling.Core/Install-UvVenvTool.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
For a CLI whose own launcher expects python.exe adjacent to it (azure-cli's az.bat), which an isolated
`uv tool` shim in ~/.local/bin breaks by placing the launcher next to uv's --default python instead. This
creates a dedicated venv (`uv venv`), installs the package into it (`uv pip install --python <venv>`), and
puts the venv's script directory on PATH — so the launcher sits beside the venv's own python and works.
Pre-release resolution (for packages that pin a beta dependency) is threaded through Invoke-Uv's
-Prerelease switch, which warns. Handles idempotency and -Force.
```

## comment:2

Above ``Invoke-Uv "venv `"$venvDir`" --python $pythonVersion --clear --seed"``.

```text
--clear rebuilds the venv clean; --seed adds pip/setuptools/wheel so packages that expect `pkg_resources`
(azure-cli's azure-devops extension) can load.
```

## comment:3

Above `if (($env:PATH -split [System.IO.Path]::PathSeparator) -notcontains...`.

```text
APPEND the venv's script directory to PATH (the janitor keeps it there each load via session_path_hints).
Append, not prepend: the venv's Scripts dir also holds its own python.exe, and prepending would shadow the
uv-managed `python` on ~/.local/bin. The tool's command resolves from here because nothing earlier provides
it, while `python` stays the managed interpreter.
```

## comment:4

Above ``Invoke-Uv "venv `"$venvDir`" --python $pythonVersion --clear --seed"``.

```text
--clear rebuilds the venv clean; --seed adds pip/setuptools/wheel so packages that expect `pkg_resources`
(azure-cli's azure-devops extension) can load.
```

## comment:5

Above `if (($env:PATH -split [System.IO.Path]::PathSeparator) -notcontains...`.

```text
APPEND the venv's script directory to PATH (the janitor keeps it there each load via session_path_hints).
Append, not prepend: the venv's Scripts dir also holds its own python.exe, and prepending would shadow the
uv-managed `python` on ~/.local/bin. The tool's command resolves from here because nothing earlier provides
it, while `python` stays the managed interpreter.
```
