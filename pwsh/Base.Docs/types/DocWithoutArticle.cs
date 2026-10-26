using System;
using System.Collections;

namespace Catzc.Base.Docs;

public sealed class DocWithoutArticle : Catzc.Base.Objects.DictionaryRecord
{
    // A folder a pattern matches that is allowed to have no source article, so no generated README (repo-relative). Required.
    public string folder { get; }

    // Why the folder needs no article, so the exemption is read as a decision, not a gap. Required.
    public string reason { get; }

    public DocWithoutArticle(IDictionary d)
    {
        if (d == null) { throw new ArgumentException("DocWithoutArticle requires a dictionary"); }
        folder = Req(d, "folder");
        reason = Req(d, "reason");
    }
}
