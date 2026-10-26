# pwsh/Base.CodeMeta/types/CodeMetaHead.cs

Reads and writes a code file's meta head as pure text work, so every behaviour is proved on strings and no file is touched. It parses a
text into what stays above the head, the head and the rest, and writes the head back byte for byte from the place facts, the edges and the
authored config. The rules behind it are
[ADR-REPO-CODEMETA-CODEFILEHEAD](../../../../drs/repository/code-file-meta.md#rule-adr-repo-codemeta-codefilehead) and
[ADR-REPO-FILEMETA-PUREPARTS](../../../../drs/repository/file-meta.md#rule-adr-repo-filemeta-pureparts).
