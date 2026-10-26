# pwsh/Base.CodeMeta/types/HeadForm.cs

The comment syntax of one file class's meta head, handed in as parameters because this module reads no config. A head is either a line
comment (`ForLine`, each line opened by a prefix) or one block comment (`ForBlock`, opened and closed by delimiters), together with the
anchor that says what stays above it and the openers of old heads the formatter removes
([ADR-REPO-CODEMETA-CODEFILEHEAD](../../../../drs/repository/code-file-meta.md#rule-adr-repo-codemeta-codefilehead)). A new comment syntax
is therefore a carrier entry, not a code change here.
