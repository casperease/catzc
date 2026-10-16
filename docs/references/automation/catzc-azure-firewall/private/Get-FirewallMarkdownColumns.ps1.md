---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-firewall/private/Get-FirewallMarkdownColumns.ps1.md
    kind: comment-page
    language: markdown
    filetype: md
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "2049fc81e20a"
---

# automation/Catzc.Azure.Firewall/private/Get-FirewallMarkdownColumns.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `if ($Present.Count -gt 0) {`, written with `#`.

```text
Trim candidates to fields the CSV actually has. A requested column with none left is a schema
mismatch — fail rather than silently drop it from the output.
```
