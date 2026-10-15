---
catzc:
  derived:
    path: docs/references/automation/catzc-base-languages/New-PythonProject.ps1.md
    kind: comment-page
    body_sha: "2d1727895cf7"
---

# automation/Catzc.Base.Languages/New-PythonProject.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:3

Above `$pythonVersion = "$(Get-ConfigValue -Address 'global.tools.python.version')"`.

```text
The one Python version: the python tool's tools.yml pin, read by address (reading config is global access,
[ADR-CONF-ADDRESSING](/docs/adr/configuration/config-value-addressing.md)).
```
