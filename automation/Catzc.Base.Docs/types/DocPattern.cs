/*
---
catzc:
  derived:
    path: automation/Catzc.Base.Docs/types/DocPattern.cs
    kind: type
    module: Catzc.Base.Docs
    adrs:
      - ADR-AUTO-PATH
---
*/

// The kebab placeholder is the folder leaf lowercased with dots turned to hyphens, so Catzc.Base.Docs becomes catzc-base-docs.
// [ADR-AUTO-PATH](/docs/adr/automation/path-representation.md)
// [comment:1](/docs/references/automation/catzc-base-docs/types/DocPattern.cs.md#comment1)

using System;
using System.Collections;

namespace Catzc.Base.Docs;

public sealed class DocPattern : Catzc.Base.Objects.DictionaryRecord
{
    // Repository-relative glob whose matched folders each receive a generated README. Required.
    public string glob { get; }

    // README source template; its `{kebab}` placeholder expands to the matched folder's kebab-cased leaf. Required.
    public string source { get; }

    public DocPattern(IDictionary d)
    {
        if (d == null) { throw new ArgumentException("DocPattern requires a dictionary"); }
        glob = Req(d, "glob");
        source = Req(d, "source");
    }
}
