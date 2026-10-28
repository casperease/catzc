# pwsh/Base.Maps/types/CitationSite.cs

One place a file cites a record: the file, the 1-based line, the canonical citation and the kind of text it sits in. A highlight uses it to
say where a lit file cites the request and whether that citation is the file's subject or a passing mention. `CitationScanner.Sites` finds
them.

## Kinds

The kind is `help` (the file's header help), `comment` (a comment after the header, a passing mention) or `text` (the rest, and all of
Markdown).

## Shape

It is a result type, so its properties are PascalCase
([ADR-BCL-TYPES-SNAKECASEMIRRORSYAML](../../../../drs/automation/BCL/native-csharp-types.md#rule-adr-bcl-types-snakecasemirrorsyaml)).
