/*
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-quality-gates/types/LinkDirectionRow.cs.md"
  header: "generated"
---
*/

using System;
using System.Collections;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;

namespace Catzc.Base.QualityGates;

public sealed class LinkDirectionRow
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    static readonly string[] Keys = { "relations", "when", "from", "to", "verdict", "because" };

    public IReadOnlyList<LinkRelation> relations { get; }
    // A require row's condition: it holds only for a file that has an edge of one of these relations to the to side; none means always.
    public IReadOnlyList<LinkRelation> when { get; }
    public LinkSelector from { get; }
    public LinkSelector to { get; }
    public LinkVerdict verdict { get; }
    public string because { get; }

    public LinkDirectionRow(IDictionary raw, string where)
    {
        if (raw == null) { throw new ArgumentException(where + ": a row is a map (" + string.Join(", ", Keys) + ")"); }
        foreach (object key in raw.Keys)
        {
            string name = Convert.ToString(key, CultureInfo.InvariantCulture);
            if (!Keys.Contains(name, StringComparer.Ordinal))
            {
                throw new ArgumentException(string.Format(CultureInfo.InvariantCulture,
                    "{0}: unknown key '{1}' (allowed: {2})", where, name, string.Join(", ", Keys)));
            }
        }

        string verdictText = raw.Contains("verdict") ? Convert.ToString(raw["verdict"], CultureInfo.InvariantCulture) : null;
        if (string.IsNullOrWhiteSpace(verdictText) || int.TryParse(verdictText, out _) || !Enum.TryParse(verdictText, true, out LinkVerdict parsed))
        {
            throw new ArgumentException(string.Format(CultureInfo.InvariantCulture,
                "{0}: verdict '{1}' is not one of: allow, deny, require", where, verdictText));
        }
        verdict = parsed;

        because = raw.Contains("because") ? Convert.ToString(raw["because"], CultureInfo.InvariantCulture)?.Trim() : null;
        if (string.IsNullOrEmpty(because))
        {
            throw new ArgumentException(where + ": because is required: the rule code that decides the row");
        }

        relations = Relations(raw, "relations", where);
        when = Relations(raw, "when", where);
        if (verdict == LinkVerdict.Require && relations.Count == 0)
        {
            throw new ArgumentException(where + ": a require row names the relations it requires");
        }
        if (verdict != LinkVerdict.Require && when.Count > 0)
        {
            throw new ArgumentException(where + ": when belongs to a require row only");
        }
        from = new LinkSelector(raw.Contains("from") ? raw["from"] as IDictionary : null, where + ".from");
        to = new LinkSelector(raw.Contains("to") ? raw["to"] as IDictionary : null, where + ".to");
    }

    static IReadOnlyList<LinkRelation> Relations(IDictionary raw, string key, string where)
    {
        var list = new List<LinkRelation>();
        if (!raw.Contains(key) || raw[key] == null) { return list; }
        IEnumerable items = raw[key] is string single ? new[] { single } : raw[key] as IEnumerable
            ?? throw new ArgumentException(where + "." + key + ": must be a list");
        foreach (object item in items)
        {
            string text = Convert.ToString(item, CultureInfo.InvariantCulture);
            if (string.IsNullOrEmpty(text) || int.TryParse(text, out _) || !Enum.TryParse(text.Replace("_", string.Empty), true, out LinkRelation relation))
            {
                throw new ArgumentException(string.Format(CultureInfo.InvariantCulture,
                    "{0}.{1}: '{2}' is not one of: markdown_link, code_link, docs_edge, convention", where, key, text));
            }
            list.Add(relation);
        }
        return list;
    }

    public bool Matches(LinkRelation relation, LinkEndpoint fromEnd, LinkEndpoint toEnd) =>
        (relations.Count == 0 || relations.Contains(relation)) && from.Matches(fromEnd) && to.Matches(toEnd);
}
