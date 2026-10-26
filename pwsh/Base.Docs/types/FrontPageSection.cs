using System;
using System.Collections;

namespace Catzc.Base.Docs;

// One section of the front page, rendered by the renderer its kind names.
public sealed class FrontPageSection : Catzc.Base.Objects.DictionaryRecord
{
    public static readonly string[] Kinds = { "fragment", "records", "contents" };

    public string id { get; }

    public string kind { get; }

    // fragment: the authored article whose '# ' title becomes the section heading.
    public string source { get; }

    // records and contents: the section heading.
    public string title { get; }

    // records: the paragraph above the table.
    public string intro { get; }

    // records: the record codes, one row each, in this order.
    public string[] records { get; }

    public FrontPageSection(IDictionary d)
    {
        if (d == null) { throw new ArgumentException("FrontPageSection requires a dictionary"); }
        id = Req(d, "id");
        kind = Req(d, "kind");
        source = OptStr(d, "source");
        title = OptStr(d, "title");
        intro = OptStr(d, "intro");
        records = StrArr(d, "records");

        if (Array.IndexOf(Kinds, kind) < 0)
        {
            throw new ArgumentException(string.Format("section '{0}': unknown kind '{1}' (allowed: {2})", id, kind, string.Join(", ", Kinds)));
        }
        if (kind == "fragment" && (source == null || title != null))
        {
            throw new ArgumentException(string.Format("section '{0}': a fragment takes 'source' and its title from that article, never 'title'", id));
        }
        if (kind != "fragment" && (title == null || source != null))
        {
            throw new ArgumentException(string.Format("section '{0}': a {1} section takes 'title', never 'source'", id, kind));
        }
        if ((kind == "records") != (records.Length > 0))
        {
            throw new ArgumentException(string.Format("section '{0}': 'records' is required on a records section and allowed nowhere else", id));
        }
    }
}
