# pwsh/Azure.Templates/configs/template-compliance.yml

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading. Prose written above the first section survives every
later export.

## comment:1

Above `known_findings: []`, written with `#`.

```text
The ratchet: each finding the real templates have today and the plan-debt-azure-gaps step that closes it; the closing step deletes its
entries, and the real-templates test fails on a new finding or a stale entry.
```
