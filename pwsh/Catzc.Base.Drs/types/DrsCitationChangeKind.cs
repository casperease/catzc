/*
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-drs/types/DrsCitationChangeKind.cs.md"
  header: "generated"
---
*/

namespace Catzc.Base.Drs;

public enum DrsCitationChangeKind
{
    // A rule code a rule-map row moves, ADR-<CODE>-<NAME>.
    Citation,

    // A code a code-map row moves, an ADR's code or a rule code that extends it.
    Code,

    // A standalone rule anchor, rule-adr-<code>-<name>, outside a path.
    Anchor,

    // The destination of a markdown link or a code link, (target) or [label]: target.
    Link,

    // A plain path mention of an ADR file or folder, with any rule anchor it carries.
    Path,

    // A numbered citation or group (ADR-<CODE>#3, ADR-<CODE>#{1,3}), which names no rule; left as written.
    Unhandled
}
