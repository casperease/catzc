# pwsh/Azure/types/AzureTagSchema.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading. Prose written above the first section survives every
later export.

## comment:1

Above `public sealed class AzureTagSchema`, written with `//`.

```text
The tags section of azure.yml: the CAF tag keys every taggable resource carries, the closed value set of those that have one, and the
lowercase provenance tag names a deploy writes. Declared once; the compliance gate and every config check read it.
```
