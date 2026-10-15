/*
---
catzc:
  derived:
    path: automation/Catzc.Base.MarkdownMeta/types/MarkdownMetaBlock.cs
    kind: type
    module: Catzc.Base.MarkdownMeta
    adrs:
      - ADR-REPO-FILEMETA#1
---
*/

using System;
using System.Collections;
using System.Collections.Generic;
using System.Globalization;
using System.Text;
using System.Text.RegularExpressions;

namespace Catzc.Base.MarkdownMeta;

public static class MarkdownMetaBlock
{
    // The two parts of the block, each a two-space-indented key under `catzc:`.
    // [comment:1](/docs/references/automation/catzc-base-markdownmeta/types/MarkdownMetaBlock.cs.md#comment1)
    public const string DerivedKey = "derived";
    public const string ConfigKey = "config";

    static readonly Regex PlainSafe = new Regex(@"^[A-Za-z_][A-Za-z0-9_./#@+-]*$", RegexOptions.Compiled);

    static readonly HashSet<string> Reserved = new HashSet<string>(StringComparer.OrdinalIgnoreCase)
    {
        "true", "false", "null", "yes", "no", "on", "off", "y", "n",
    };

    // Renders the block in its one canonical form: the derived facts in the order given, then the authored config lines as written.
    // [comment:2](/docs/references/automation/catzc-base-markdownmeta/types/MarkdownMetaBlock.cs.md#comment2)
    public static IReadOnlyList<string> Render(IDictionary derived, IReadOnlyList<string> config)
    {
        var lines = new List<string>();
        int facts = derived == null ? 0 : derived.Count;
        if (facts == 0 && (config == null || config.Count == 0)) { return lines; }
        lines.Add(MarkdownDocument.MetaKey + ":");
        if (facts > 0)
        {
            lines.Add("  " + DerivedKey + ":");
            foreach (DictionaryEntry fact in derived)
            {
                string key = Key(fact.Key as string);
                if (fact.Value is IEnumerable items && !(fact.Value is string))
                {
                    var list = new List<string>();
                    foreach (object item in items) { list.Add(Scalar(item)); }
                    if (list.Count == 0) { lines.Add("    " + key + ": []"); continue; }
                    lines.Add("    " + key + ":");
                    foreach (string item in list) { lines.Add("      - " + item); }
                }
                else
                {
                    lines.Add("    " + key + ": " + Scalar(fact.Value));
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

    // The keys at the block's first level, two spaces in: `derived`, `config`, and anything else an author wrote.
    public static IReadOnlyList<string> SectionKeys(IReadOnlyList<string> block) => KeysAt(block, 2, null);

    // The keys one level down inside `derived`, four spaces in.
    public static IReadOnlyList<string> DerivedKeys(IReadOnlyList<string> block) => KeysAt(block, 4, DerivedKey);

    static List<string> KeysAt(IReadOnlyList<string> block, int indent, string inside)
    {
        var keys = new List<string>();
        if (block == null) { return keys; }
        string section = null;
        string prefix = new string(' ', indent);
        foreach (string line in block)
        {
            if (line.StartsWith("  ", StringComparison.Ordinal) && !line.StartsWith("   ", StringComparison.Ordinal))
            {
                int colon = line.IndexOf(':');
                if (colon > 2 && line[2] != '#') { section = line.Substring(2, colon - 2).Trim(); }
            }
            bool atLevel = line.StartsWith(prefix, StringComparison.Ordinal) && line.Length > indent && line[indent] != ' ' && line[indent] != '#';
            if (!atLevel) { continue; }
            if (inside != null && section != inside) { continue; }
            if (inside != null && line[indent] == '-') { continue; }
            int end = line.IndexOf(':', indent);
            if (end > indent) { keys.Add(line.Substring(indent, end - indent).Trim().Trim('"')); }
        }
        return keys;
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
