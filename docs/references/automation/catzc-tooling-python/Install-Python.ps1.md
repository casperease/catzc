---
catzc:
  immutable:
    with_body_sha: "734ffe400d0f"
    path: docs/references/automation/catzc-tooling-python/Install-Python.ps1.md
    folder: docs/references/automation/catzc-tooling-python
    name: install-python-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
---

# automation/Catzc.Tooling.Python/Install-Python.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$reinstall = if ($Force) {`, written with `#`.

```text
uv resolves the newest matching CPython, installs it, and (--default) writes the global python/python3
shims into its bin dir. --default is still behind uv's preview flag, so opt in explicitly with
--preview-features to keep it (and silence uv's experimental warning, which WarningPreference=Stop
would otherwise turn into a halt). --reinstall replaces an existing build of the same version under -Force.
```
