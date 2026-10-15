/*
---
catzc:
  derived:
    path: automation/Catzc.Base.CodeMeta/types/HeadAnchor.cs
    kind: type
    module: Catzc.Base.CodeMeta
---
*/

// What must stay above a comment head: nothing, a shebang, an XML or HTML prolog, or a fixed number of preamble lines.
// [ADR-REPO-CODEMETA#1](/docs/adr/repository/code-file-meta.md#rule-adr-repo-codemeta1)
// [comment:1](/docs/references/automation/catzc-base-codemeta/types/HeadAnchor.cs.md#comment1)

namespace Catzc.Base.CodeMeta;

public enum HeadAnchor
{
    Start,
    AfterShebang,
    AfterProlog,
    AfterPreamble,
}
