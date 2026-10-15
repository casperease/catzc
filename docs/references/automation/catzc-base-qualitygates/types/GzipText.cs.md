# docs/references/automation/catzc-base-qualitygates/types/GzipText.cs.md

`automation/Catzc.Base.QualityGates/types/GzipText.cs`

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `public static class GzipText`.

```text
<summary>
Gzip compress/decompress for UTF-8 text payloads, using only the BCL
([ADR-PWSH-TYPES#1](/docs/adr/pwsh/hosting-csharp-types.md#rule-adr-pwsh-types1)). Shared by
Build-EnglishDictionary (writes the committed english.txt.gz) and SpellingOracle (reads it). Kept in one
place so the container handling cannot drift between the writer and the reader.
</summary>
```
