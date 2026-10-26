using System;
using System.Collections;

namespace Catzc.Base.Docs;

// A glob convention: every matched folder derives its README source from the template, {kebab} or {name} expanded from the leaf.
public sealed class DocPattern : Catzc.Base.Objects.DictionaryRecord
{
    // Repository-relative glob whose matched module folders each receive a generated README. Required. A folder's README source is its
    // module article, which the comment-pages resolver derives, so a pattern names no source of its own.
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
