/*
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-markdown-meta/types/MarkdownMetaBlock.cs.md"
  warning: "Generated Header"
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
    public const string ImmutableKey = "immutable";
    public const string ConfigKey = "config";
    // The note an authored head closes with, that the head itself is generated; a generated file's warning sits under immutable.
    public const string HeaderKey = "header";

    // The keys at the block's first level that are no imprinted fact: every other first-level key is one.
    static readonly HashSet<string> PartKeys = new HashSet<string>(StringComparer.Ordinal) { ImmutableKey, ConfigKey, HeaderKey };

    static readonly Regex PlainSafe = new Regex(@"^[A-Za-z_][A-Za-z0-9_./#@+-]*$", RegexOptions.Compiled);

    // An ADR group (ADR-<CODE>#{1,3-5}): YAML reads its braces and comma as plain text inside a block scalar.

    static readonly HashSet<string> Reserved = new HashSet<string>(StringComparer.OrdinalIgnoreCase)
    {
        "true", "false", "null", "yes", "no", "on", "off", "y", "n",
    };

    // The block of a head with no header line, as a generated head writes it: its warning lives in its place facts.
    public static IReadOnlyList<string> Render(IDictionary immutable, IDictionary edges, IReadOnlyList<string> config) =>
        Render(null, immutable, edges, config);

    public static IReadOnlyList<string> Render(string header, IDictionary immutable, IDictionary edges, IReadOnlyList<string> config)
    {
        var lines = new List<string>();
        List<DictionaryEntry> places = Present(immutable);
        List<DictionaryEntry> outgoing = Present(edges);
        bool noted = !string.IsNullOrEmpty(header);
        if (!noted && places.Count == 0 && outgoing.Count == 0 && (config == null || config.Count == 0)) { return lines; }
        lines.Add(MarkdownDocument.MetaKey + ":");
        RenderFacts(lines, "  ", outgoing);
        if (noted) { lines.Add("  " + HeaderKey + ": " + Quote(header)); }
        RenderPart(lines, ImmutableKey, places);
        if (config != null && config.Count > 0)
        {
            lines.Add("  " + ConfigKey + ":");
            lines.AddRange(config);
        }
        return lines;
    }

    // A fact with no value is the default, so the key is left out and its absence reads as the empty value.
    static List<DictionaryEntry> Present(IDictionary part)
    {
        var present = new List<DictionaryEntry>();
        if (part == null) { return present; }
        foreach (DictionaryEntry fact in part)
        {
            if (!IsEmpty(fact.Value)) { present.Add(fact); }
        }
        return present;
    }

    static void RenderPart(List<string> lines, string name, List<DictionaryEntry> present)
    {
        if (present.Count == 0) { return; }
        lines.Add("  " + name + ":");
        RenderFacts(lines, "    ", present);
    }

    static void RenderFacts(List<string> lines, string indent, List<DictionaryEntry> present)
    {
        foreach (DictionaryEntry fact in present)
        {
            string key = Key(fact.Key as string);
            if (fact.Value is IDictionary map)
            {
                lines.Add(indent + key + ":");
                foreach (DictionaryEntry slot in map) { lines.Add(indent + "  " + Key(slot.Key as string) + ": " + Scalar(slot.Value)); }
            }
            else if (fact.Value is IEnumerable items && !(fact.Value is string))
            {
                var list = new List<string>();
                foreach (object item in items) { list.Add(Scalar(item)); }
                lines.Add(indent + key + ":");
                foreach (string item in list) { lines.Add(indent + "  - " + item); }
            }
            else
            {
                lines.Add(indent + key + ": " + Scalar(fact.Value));
            }
        }
    }

    // Nothing, an empty string, an empty list or an empty map: the value a key has when it is absent.
    static bool IsEmpty(object value)
    {
        if (value == null) { return true; }
        if (value is string text) { return text.Length == 0; }
        if (value is IDictionary map) { return map.Count == 0; }
        if (value is IEnumerable items) { return !items.GetEnumerator().MoveNext(); }
        return false;
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

    // The block without its config part; a block left with only its own `catzc:` line is no block.
    public static IReadOnlyList<string> WithoutConfig(IReadOnlyList<string> block)
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
            if (inside && (line.Trim().Length == 0 || line.StartsWith("   ", StringComparison.Ordinal))) { continue; }
            inside = false;
            lines.Add(line);
        }
        if (lines.Count == 1 && lines[0] == MarkdownDocument.MetaKey + ":") { lines.Clear(); }
        return lines;
    }

    // The keys at the block's first level, two spaces in: the imprinted facts, `header`, `immutable`, `config`.
    public static IReadOnlyList<string> SectionKeys(IReadOnlyList<string> block) => KeysAt(block, 2, null);

    // The keys one level down inside `immutable`, four spaces in.
    public static IReadOnlyList<string> ImmutableKeys(IReadOnlyList<string> block) => KeysAt(block, 4, ImmutableKey);

    // The imprinted facts: the first-level keys that are no part (header, immutable, config), the names of the edges.
    public static IReadOnlyList<string> EdgeKeys(IReadOnlyList<string> block)
    {
        var keys = new List<string>();
        foreach (string key in SectionKeys(block)) { if (!PartKeys.Contains(key)) { keys.Add(key); } }
        return keys;
    }

    // The items of one list edge at the first level, as written; empty when the edge is absent or holds a scalar.
    public static IReadOnlyList<string> EdgeList(IReadOnlyList<string> block, string key)
    {
        var items = new List<string>();
        if (block == null) { return items; }
        bool inKey = false;
        foreach (string line in block)
        {
            if (line.StartsWith("  ", StringComparison.Ordinal) && line.Length > 2 && line[2] != ' ' && line[2] != '-')
            {
                inKey = line.Substring(2).StartsWith(key + ":", StringComparison.Ordinal)
                    || line.Substring(2).StartsWith("\"" + key + "\":", StringComparison.Ordinal);
                continue;
            }
            string item = line.TrimStart();
            if (inKey && item.StartsWith("- ", StringComparison.Ordinal)) { items.Add(item.Substring(2).Trim().Trim('"')); }
        }
        return items;
    }

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
