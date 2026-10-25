/*
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-code-meta/types/HeadAnchor.cs.md"
  header: "generated"
---
*/

namespace Catzc.Base.CodeMeta;

// What must stay above a head, since a shebang or an XML prolog stops working once anything comes before it.
public enum HeadAnchor
{
    Start,
    AfterShebang,
    AfterProlog,
    AfterPreamble,
}
