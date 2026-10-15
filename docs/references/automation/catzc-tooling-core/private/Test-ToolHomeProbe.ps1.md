---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-core/private/Test-ToolHomeProbe.ps1.md
    kind: reference
    body_sha: bf5e10142342
    adrs: []
---

# automation/Catzc.Tooling.Core/private/Test-ToolHomeProbe.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
A probe is a home-relative path whose last segment is `{version}` (validated by ToolConfig). The home
satisfies it when the probe's parent folder holds a directory named exactly the version, or starting with
"<version>." — so `sdk/{version}` at version 10.0 matches sdk/10.0.201 but not sdk/10.01 or sdk/6.0.428.
A pure filesystem check: no process is started, so it is safe on the importer's hot path.
```
