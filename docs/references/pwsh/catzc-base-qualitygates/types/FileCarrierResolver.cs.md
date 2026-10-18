# pwsh/Catzc.Base.QualityGates/types/FileCarrierResolver.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
Finds the carrier entry of a repository path, with every glob compiled once, so a scan of all tracked files stays cheap.
[ADR-REPO-FILEMETA-KINDSCOPE](/docs/adr/repository/file-meta.md#rule-adr-repo-filemeta-kindscope)
```
