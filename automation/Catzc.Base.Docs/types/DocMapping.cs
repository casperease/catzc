// catzc:
//   path: automation/Catzc.Base.Docs/types/DocMapping.cs
//   module: Catzc.Base.Docs

// Both paths are root-relative and slash-separated, so source and folder compare the same on every OS.
// [ADR-AUTO-PATH](/docs/adr/automation/path-representation.md)
// [comment:1](/docs/references/automation/catzc-base-docs/types/DocMapping.cs.md#comment1)

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
