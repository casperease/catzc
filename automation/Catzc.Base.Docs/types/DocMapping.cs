/*
---
catzc:
  derived:
    path: automation/Catzc.Base.Docs/types/DocMapping.cs
    kind: type
    language: csharp
    filetype: cs
    track: automation
    module: Catzc.Base.Docs
    moduletype: pwsh-folder-module
    bundle: azure
    relatives:
      page: docs/references/automation/catzc-base-docs/types/DocMapping.cs.md
      test: automation/Catzc.Base.Docs/tests/types/DocMapping.Tests.ps1
    adrs:
      - ADR-AUTO-PATH
---
*/

using System;
using System.Collections;

namespace Catzc.Base.Docs;

public sealed class DocMapping : Catzc.Base.Objects.DictionaryRecord
{
    // Target conventional folder that receives the generated README.md (repo-relative). Required.
    public string folder { get; }

    // Authored docs file copied out to that folder's README.md (repo-relative). Required.
    public string source { get; }

    public DocMapping(IDictionary d)
    {
        if (d == null) { throw new ArgumentException("DocMapping requires a dictionary"); }
        folder = Req(d, "folder");
        source = Req(d, "source");
    }
}
