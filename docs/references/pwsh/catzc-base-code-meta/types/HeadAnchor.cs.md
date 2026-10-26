# pwsh/Base.CodeMeta/types/HeadAnchor.cs

What must stay above a comment head: nothing, a shebang, an XML or HTML prolog, or a fixed number of preamble lines. A shebang or a prolog
stops working once anything comes before it, so the head is written after it
([ADR-REPO-CODEMETA-CODEFILEHEAD](../../../../drs/repository/code-file-meta.md#rule-adr-repo-codemeta-codefilehead)).
