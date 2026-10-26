using System;
using System.Collections;

namespace Catzc.Base.Docs;

// A glob convention: every matched folder derives its README source from the template, {kebab} or {name} expanded from the leaf.
public sealed class DocPattern : Catzc.Base.Objects.DictionaryRecord
{
    public string glob { get; }

    public DocPattern(IDictionary d)
    {
        if (d == null) { throw new ArgumentException("DocPattern requires a dictionary"); }
        if (d.Contains("source"))
        {
            throw new ArgumentException("DocPattern: 'source' is no longer a pattern key; a matched folder's README is its module article, which comment-pages.yml derives");
        }
        glob = Req(d, "glob");
    }
}
