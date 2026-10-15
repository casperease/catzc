// A flags enum, so Both is Code | Markdown and the engine tests HasFlag instead of special-casing Both.
// [ADR-REPO-LINK#1](/docs/adr/repository/markdown-links.md#rule-adr-repo-link1)
// [comment:1](/docs/references/automation/catzc-base-qualitygates/types/LinkKind.cs.md#comment1)

using System;

namespace Catzc.Base.QualityGates;

[Flags]
public enum LinkKind
{
    Code = 1,
    Markdown = 2,
    Both = Code | Markdown,
}
