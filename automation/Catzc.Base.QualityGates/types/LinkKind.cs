// The two kinds of link (ADR-REPO-LINK#1), fixed by the file a link lives in: a markdown link lives in a rendered
// .md file, a code link in a comment of any other tracked text file. [Flags], so Both is Code | Markdown and the
// engine tests HasFlag instead of special-casing Both; a parameter typed as this enum binds -Kind Code,
// -Kind Markdown, or -Kind Both and tab-completes the fixed set.

using System;

namespace Catzc.Base.QualityGates;

[Flags]
public enum LinkKind
{
    Code = 1,
    Markdown = 2,
    Both = Code | Markdown,
}
