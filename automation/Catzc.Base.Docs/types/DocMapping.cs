// One explicit README copy-in entry from configs/readme.yml — an authored `source` docs file copied out to
// `<folder>/README.md`. Both are repository-root-relative, '/'-separated communication-form paths
// (see docs/adr/automation/path-representation.md). Mirrors a readme.yml mappings entry (snake_case keys).
//
// Derives from Catzc.Base.Objects.DictionaryRecord, so an instance also presents as a read-only dictionary
// over its own properties and its constructor uses the base's Req extraction helper.

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
