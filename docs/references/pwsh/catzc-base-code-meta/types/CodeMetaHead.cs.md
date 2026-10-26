# pwsh/Base.CodeMeta/types/CodeMetaHead.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

```text
Reads and writes a code file's meta head as pure text work, so every behaviour is proved on strings and no file is touched.
[ADR-REPO-CODEMETA-CODEFILEHEAD](/docs/drs/repository/code-file-meta.md#rule-adr-repo-codemeta-codefilehead),
[ADR-REPO-FILEMETA-PUREPARTS](/docs/drs/repository/file-meta.md#rule-adr-repo-filemeta-pureparts)
```
