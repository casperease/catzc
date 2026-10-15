/*
---
catzc:
  derived:
    path: automation/Catzc.Base.Languages/types/CarrierKind.cs
    kind: type
    module: Catzc.Base.Languages
    adrs:
      - ADR-REPO-FILEMETA#1
---
*/

// Where a file keeps its meta block: in its own text (front matter, comment head, ignored property), beside it (sidecar), or nowhere.
// [ADR-REPO-FILEMETA#1](/docs/adr/repository/file-meta.md#rule-adr-repo-filemeta1)
// [comment:1](/docs/references/automation/catzc-base-languages/types/CarrierKind.cs.md#comment1)

namespace Catzc.Base.Languages;

public enum CarrierKind
{
    FrontMatter,
    CommentHead,
    Property,
    Sidecar,
    None,
}
