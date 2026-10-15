using System;
using System.Collections;
using System.Collections.Generic;
using System.Globalization;
using System.Text;
using System.Text.RegularExpressions;

namespace Catzc.Base.MarkdownMeta;

public static class MarkdownMetaBlock
{
    // The two parts of the block, each a two-space-indented key under `catzc:` (ADR-REPO-MDMETA#1).
    public const string DerivedKey = "derived";
    public const string ConfigKey = "config";

    static readonly Regex PlainSafe = new Regex(@"^[A-Za-z_][A-Za-z0-9_./#@+-]*$", RegexOptions.Compiled);

    static readonly HashSet<string> Reserved = new HashSet<string>(StringComparer.OrdinalIgnoreCase)
    {
        "true", "false", "null", "yes", "no", "on", "off", "y", "n",
    };

    // Renders the block in its one canonical form: the derived facts in the order given, then the authored config lines as written.
    // A value is a scalar or a list of scalars. No facts and no config lines render no block at all.
    public static IReadOnlyList<string> Render(IEnumerable<KeyValuePair<string, object>> derived, IReadOnlyList<string> config)
    {
        var facts = new List<KeyValuePair<string, object>>(derived ?? new KeyValuePair<string, object>[0]);
        var lines = new List<string>();
        if (facts.Count == 0 && (config == null || config.Count == 0)) { return lines; }
        lines.Add(MarkdownDocument.MetaKey + ":");
        if (facts.Count > 0)
        {
            lines.Add("  " + DerivedKey + ":");
            foreach (KeyValuePair<string, object> fact in facts)
            {
                if (fact.Value is IEnumerable items && !(fact.Value is string))
                {
                    var list = new List<string>();
                    foreach (object item in items) { list.Add(Scalar(item)); }
                    if (list.Count == 0) { lines.Add("    " + Key(fact.Key) + ": []"); continue; }
                    lines.Add("    " + Key(fact.Key) + ":");
                    foreach (string item in list) { lines.Add("      - " + item); }
                }
                else
                {
                    lines.Add("    " + Key(fact.Key) + ": " + Scalar(fact.Value));
                }
            }
        }
        if (config != null && config.Count > 0)
        {
            lines.Add("  " + ConfigKey + ":");
            lines.AddRange(config);
        }
        return lines;
    }

    // The authored lines under `config:` of an existing block, as written; empty when the block has no config part.
    public static IReadOnlyList<string> ConfigLines(IReadOnlyList<string> block)
    {
        var lines = new List<string>();
        if (block == null) { return lines; }
        bool inside = false;
        foreach (string line in block)
        {
            if (line.StartsWith("  " + ConfigKey + ":", StringComparison.Ordinal) && !line.StartsWith("   ", StringComparison.Ordinal))
            {
                inside = true;
                continue;
            }
            if (!inside) { continue; }
            if (line.Trim().Length > 0 && !line.StartsWith("   ", StringComparison.Ordinal)) { break; }
            lines.Add(line);
        }
        while (lines.Count > 0 && lines[lines.Count - 1].Trim().Length == 0) { lines.RemoveAt(lines.Count - 1); }
        return lines;
    }

    // One value, plain where YAML would read it back as the same string, otherwise double-quoted.
    public static string Scalar(object value)
    {
        if (value == null) { return "null"; }
        if (value is bool flag) { return flag ? "true" : "false"; }
        if (value is IFormattable number && !(value is string)) { return number.ToString(null, CultureInfo.InvariantCulture); }
        string text = value.ToString();
        if (PlainSafe.IsMatch(text) && !Reserved.Contains(text)) { return text; }
        return Quote(text);
    }

    static string Key(string key)
    {
        if (string.IsNullOrEmpty(key)) { throw new ArgumentException("A meta key is never empty."); }
        return PlainSafe.IsMatch(key) && !Reserved.Contains(key) ? key : Quote(key);
    }

    static string Quote(string text)
    {
        var quoted = new StringBuilder("\"");
        foreach (char c in text)
        {
            switch (c)
            {
                case '\\': quoted.Append("\\\\"); break;
                case '"': quoted.Append("\\\""); break;
                case '\n': quoted.Append("\\n"); break;
                case '\r': quoted.Append("\\r"); break;
                case '\t': quoted.Append("\\t"); break;
                default:
                    if (char.IsControl(c)) { quoted.Append("\\u").Append(((int)c).ToString("x4", CultureInfo.InvariantCulture)); }
                    else { quoted.Append(c); }
                    break;
            }
        }
        return quoted.Append('"').ToString();
    }
}
