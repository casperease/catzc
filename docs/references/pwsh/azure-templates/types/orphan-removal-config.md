# pwsh/Azure.Templates/types/OrphanRemovalConfig.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading. Prose written above the first section survives every
later export.

## comment:1

Above `public IReadOnlyList<string> azure_created { get; } = new[]`, written with `//`.

```text
The children Azure creates with their parent, which no template declares and az resource list returns: each is the resource type
and the last segment of its name, joined by '/'.
```
