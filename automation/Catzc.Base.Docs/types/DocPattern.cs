// One glob-based README source convention from configs/readme.yml — every folder matched by `glob` derives its
// README source from `source`, a template whose `{kebab}` placeholder expands to the matched folder's leaf name
// lowercased with dots turned to hyphens. Both are repository-root-relative, '/'-separated communication-form
// values (see docs/adr/automation/path-representation.md). Mirrors a readme.yml patterns entry (snake_case keys).
//
// Derives from Catzc.Base.Objects.DictionaryRecord, so an instance also presents as a read-only dictionary over
// its own properties and its constructor uses the base's Req extraction helper.

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
