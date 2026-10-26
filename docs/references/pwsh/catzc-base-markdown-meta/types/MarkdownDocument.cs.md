# pwsh/Base.MarkdownMeta/types/MarkdownDocument.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `public string BodyHash() => HashOf(Body);`, written with `//`.

```text
The first 12 hex characters of the SHA-256 of the body, its line endings read as LF and its leading blank lines dropped. The blank
line that separates written front matter from the body is no part of the body, so imprinting never changes the hash it records.
```
