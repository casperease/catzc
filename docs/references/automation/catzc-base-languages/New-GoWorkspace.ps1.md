---
catzc:
  derived:
    path: docs/references/automation/catzc-base-languages/New-GoWorkspace.ps1.md
    kind: comment-page
    body_sha: "2d71eedfdab2"
---

# automation/Catzc.Base.Languages/New-GoWorkspace.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:4

Above `$goVersion = "$(Get-ConfigValue -Address 'global.tools.go.version')"`.

```text
The one Go version: the go tool's tools.yml pin, read by address (reading config is global access,
[ADR-CONF-ADDRESSING](/docs/adr/configuration/config-value-addressing.md)). A major.minor pin (1.27) is a valid go
directive, as is a full 1.N.P.
```
