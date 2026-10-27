# pwsh/Azure.Templates/types/TemplateComplianceConfig.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading. Prose written above the first section survives every
later export.

## comment:1

Above `public IReadOnlyDictionary<string, string> known_findings { get; } = new...`, written with `//`.

```text
The ratchet: each finding the real templates have today, exactly as the gate words it, keyed to the plan step that closes it.
The real-templates test fails on a finding not listed here and on an entry no finding matches; a closing step deletes its entries.
```
