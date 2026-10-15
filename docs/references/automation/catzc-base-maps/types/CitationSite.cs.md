# docs/references/automation/catzc-base-maps/types/CitationSite.cs.md

`automation/Catzc.Base.Maps/types/CitationSite.cs`

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `namespace Catzc.Base.Maps;`.

```text
One place a file cites an ADR: the file, the 1-based line, the canonical citation, and the kind of text it sits in, so
a highlight can say where a lit file cites the request and whether that citation is the file's subject or a passing
mention. CitationScanner.Sites finds them. A result type, so the properties are PascalCase
([ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)).
```
