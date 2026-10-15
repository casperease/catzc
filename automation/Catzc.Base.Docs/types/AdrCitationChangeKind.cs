// catzc:
//   path: automation/Catzc.Base.Docs/types/AdrCitationChangeKind.cs
//   module: Catzc.Base.Docs

// Unhandled is the one form found but not rewritten mechanically, such as a citation range that a moved rule splits.
// [ADR-AUTO-TYPES#9](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types9)
// [comment:1](/docs/references/automation/catzc-base-docs/types/AdrCitationChangeKind.cs.md#comment1)

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
