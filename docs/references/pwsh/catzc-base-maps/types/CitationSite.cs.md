# pwsh/Base.Maps/types/CitationSite.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `namespace Catzc.Base.Maps;`, written with `//`.

```text
One place a file cites an ADR: the file, the 1-based line, the canonical citation, and the kind of text it sits in, so
a highlight can say where a lit file cites the request and whether that citation is the file's subject or a passing
mention. CitationScanner.Sites finds them. A result type, so the properties are PascalCase
([ADR-BCL-TYPES-SNAKECASEMIRRORSYAML](/docs/drs/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-snakecasemirrorsyaml)).
```
