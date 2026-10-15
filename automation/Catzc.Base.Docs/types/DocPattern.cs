// One glob-based README source convention from configs/readme.yml — every folder matched by `glob` derives its README source from...
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
