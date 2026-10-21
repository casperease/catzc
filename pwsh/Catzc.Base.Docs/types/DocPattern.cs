/*
---
catzc:
  immutable:
    with_body_sha: "917e43ba4284"
  edges:
    test: pwsh/Catzc.Base.Docs/tests/types/DocPattern.Tests.ps1
    docs: "[DocPattern.cs.md](../../../docs/references/pwsh/catzc-base-docs/types/DocPattern.cs.md)"
    cites:
      - ADR-AUTO-PATH
---
*/

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
