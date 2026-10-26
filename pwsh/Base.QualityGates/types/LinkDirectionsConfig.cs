using System;
using System.Collections;
using System.Collections.Generic;
using System.Globalization;

namespace Catzc.Base.QualityGates;

// With no rows every relation is denied.
public sealed class LinkDirectionsConfig
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    public IReadOnlyList<LinkDirectionRow> rows { get; }
    public IReadOnlyDictionary<string, string> exempt { get; }

    public LinkDirectionsConfig(IDictionary raw)
    {
        var list = new List<LinkDirectionRow>();
        var exemptions = new Dictionary<string, string>(StringComparer.Ordinal);
        if (raw != null)
        {
            foreach (object key in raw.Keys)
            {
                string name = Convert.ToString(key, CultureInfo.InvariantCulture);
                if (name != "rows" && name != "exempt")
                {
                    throw new ArgumentException(string.Format(CultureInfo.InvariantCulture,
                        "link-directions config: unknown key '{0}' (allowed: rows, exempt)", name));
                }
            }

            if (raw.Contains("rows") && raw["rows"] != null)
            {
                if (!(raw["rows"] is IEnumerable items) || raw["rows"] is string || raw["rows"] is IDictionary)
                {
                    throw new ArgumentException("link-directions config: rows must be a list of rows");
                }
                foreach (object item in items)
                {
                    list.Add(new LinkDirectionRow(item as IDictionary,
                        string.Format(CultureInfo.InvariantCulture, "link-directions config: row {0}", list.Count + 1)));
                }
            }

            if (raw.Contains("exempt") && raw["exempt"] != null)
            {
                if (!(raw["exempt"] is IDictionary map))
                {
                    throw new ArgumentException("link-directions config: exempt must be a map of file to its reason");
                }
                foreach (DictionaryEntry entry in map)
                {
                    string file = Convert.ToString(entry.Key, CultureInfo.InvariantCulture);
                    string reason = Convert.ToString(entry.Value, CultureInfo.InvariantCulture)?.Trim();
                    if (string.IsNullOrEmpty(reason))
                    {
                        throw new ArgumentException(string.Format(CultureInfo.InvariantCulture,
                            "link-directions config: exempt '{0}' needs its reason", file));
                    }
                    exemptions[file] = reason;
                }
            }
        }
        rows = list;
        exempt = exemptions;
    }
}
