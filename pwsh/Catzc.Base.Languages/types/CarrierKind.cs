/*
---
catzc:
  immutable:
    with_body_sha: fd585ba55c11
  edges:
    docs: "[CarrierKind.cs.md](../../../docs/references/pwsh/catzc-base-languages/types/CarrierKind.cs.md)"
    cites:
      - ADR-REPO-FILEMETA-HEADPOLICY
---
*/

namespace Catzc.Base.Languages;

public enum CarrierKind
{
    FrontMatter,
    CommentHead,
    Property,
    None,
}
