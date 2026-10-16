---
catzc:
  immutable:
    with_body_sha: "33f95b5ebf1e"
    repo_status: locked
    path: docs/references/automation/catzc-base-languages/New-PythonProject.ps1.md
    folder: docs/references/automation/catzc-base-languages
    name: new-python-project-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
---

# automation/Catzc.Base.Languages/New-PythonProject.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$pythonVersion = "$(Get-ConfigValue -Address 'global.tools.python.version')"`, written with `#`.

```text
The one Python version: the python tool's tools.yml pin, read by address (reading config is global access,
[ADR-CONF-ADDRESSING](/docs/adr/configuration/config-value-addressing.md)).
```
