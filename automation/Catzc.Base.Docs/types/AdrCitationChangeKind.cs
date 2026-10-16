/*
---
catzc:
  immutable:
    path: automation/Catzc.Base.Docs/types/AdrCitationChangeKind.cs
    folder: types
    name: adr-citation-change-kind
    filetype: cs
    kind: type
    language: csharp
    track: automation
    tracktype: modules
    module: Catzc.Base.Docs
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    page: docs/references/automation/catzc-base-docs/types/AdrCitationChangeKind.cs.md
    cites:
      - ADR-AUTO-TYPES#9
---
*/

namespace Catzc.Base.Docs;

public enum AdrCitationChangeKind
{
    // A rule citation, ADR-<CODE>#<n> or ADR-<CODE>:<n>, with any list continuation (, #5 and #7) it carries.
    Citation,

    // A bare code, ADR-<CODE>, with no rule number.
    Code,

    // A standalone rule anchor, rule-adr-<code><n>, outside a path.
    Anchor,

    // The destination of a markdown link or a code link, (target) or [label]: target.
    Link,

    // A plain path mention of an ADR file or folder, with any rule anchor it carries.
    Path,

    // A citation range (ADR-<CODE>#1 to #6) that a moved or collapsed rule splits; left as written.
    Unhandled
}
