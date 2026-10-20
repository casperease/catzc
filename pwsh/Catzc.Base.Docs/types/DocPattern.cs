/*
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.Docs/types/DocPattern.cs
    folder: types
    name: doc-pattern
    filetype: cs
    role: type
    language: csharp
    track: pwsh
    tracktype: modules
    module: Catzc.Base.Docs
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    test: pwsh/Catzc.Base.Docs/tests/types/DocPattern.Tests.ps1
    docs: "[DocPattern.cs.md](docs/references/pwsh/catzc-base-docs/types/DocPattern.cs.md)"
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
