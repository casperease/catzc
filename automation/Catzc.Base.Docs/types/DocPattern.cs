/*
---
catzc:
  derived:
    path: automation/Catzc.Base.Docs/types/DocPattern.cs
    kind: csharp-type
    language: csharp
    track: automation
    module: Catzc.Base.Docs
    relatives:
      page: docs/references/automation/catzc-base-docs/types/DocPattern.cs.md
      test: automation/Catzc.Base.Docs/tests/types/DocPattern.Tests.ps1
    adrs:
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
