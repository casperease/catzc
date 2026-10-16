---
catzc:
  immutable:
    with_body_sha: bf24a2013655
    repo_status: locked
    path: docs/references/automation/catzc-base-qualitygates/types/GzipText.cs.md
    folder: docs/references/automation/catzc-base-qualitygates/types
    name: gzip-text-cs
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
  edges:
    cites:
      - ADR-PWSH-TYPES#1
---

# automation/Catzc.Base.QualityGates/types/GzipText.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `public static class GzipText`, written with `///`.

```text
<summary>
Gzip compress/decompress for UTF-8 text payloads, using only the BCL
([ADR-PWSH-TYPES#1](/docs/adr/pwsh/hosting-csharp-types.md#rule-adr-pwsh-types1)). Shared by
Build-EnglishDictionary (writes the committed english.txt.gz) and SpellingOracle (reads it). Kept in one
place so the container handling cannot drift between the writer and the reader.
</summary>
```
