/*
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-drs/types/DrsCitationChangeKind.cs.md"
  header: "generated"
---
*/

namespace Catzc.Base.Drs;

// The closed set of reference forms Update-DrsCitation recognises, plus the one form it found and could not rewrite mechanically.
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

    // An inline citation whose line outgrew the markdown width, respelled as a reference with its definition at the end of the file.
    Form,

    // A numbered citation or group (ADR-<CODE>#3, ADR-<CODE>#{1,3}), which names no rule; left as written.
    Unhandled
}
