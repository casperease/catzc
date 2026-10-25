/*
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-docs/types/DocPattern.cs.md"
  warning: "Generated Header"
---
*/

using System;
using System.Collections;

namespace Catzc.Base.Docs;

public sealed class DocPattern : Catzc.Base.Objects.DictionaryRecord
{
    // Repository-relative glob whose matched folders each receive a generated README. Required.
    public string glob { get; }

    // README source template; `{kebab}` expands to the matched folder's kebab-cased leaf, `{name}` to the leaf as written. Required.
    public string source { get; }

    public DocPattern(IDictionary d)
    {
        if (d == null) { throw new ArgumentException("DocPattern requires a dictionary"); }
        glob = Req(d, "glob");
        source = Req(d, "source");
    }
}
