---
catzc:
  immutable:
    with_body_sha: "7cab80b49b24"
    repo_status: locked
    path: docs/references/automation/catzc-tooling-core/Install-UvVenvTool.ps1.md
    folder: docs/references/automation/catzc-tooling-core
    name: install-uv-venv-tool-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
---

# automation/Catzc.Tooling.Core/Install-UvVenvTool.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above ``Invoke-Uv "venv `"$venvDir`" --python $pythonVersion --clear --seed"``, written with `#`.

```text
--clear rebuilds the venv clean; --seed adds pip/setuptools/wheel so packages that expect `pkg_resources`
(azure-cli's azure-devops extension) can load.
```

## comment:2

Above `if (($env:PATH -split [System.IO.Path]::PathSeparator) -notcontains...`, written with `#`.

```text
APPEND the venv's script directory to PATH (the janitor keeps it there each load via session_path_hints).
Append, not prepend: the venv's Scripts dir also holds its own python.exe, and prepending would shadow the
uv-managed `python` on ~/.local/bin. The tool's command resolves from here because nothing earlier provides
it, while `python` stays the managed interpreter.
```
