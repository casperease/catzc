/*
---
catzc:
  immutable:
    with_body_sha: "8bf5d698d890"
  edges:
    test: pwsh/Catzc.Base.Languages/tests/types/FileCarriersConfig.Tests.ps1
    docs: "[FileCarriersConfig.cs.md](../../../docs/references/pwsh/catzc-base-languages/types/FileCarriersConfig.cs.md)"
    cites:
      - ADR-AUTO-DEFAULT-ONERESOLUTIONORDER
      - ADR-REPO-FILEMETA-HEADPOLICY
      - PDR-CONFIG-VARYINGBEHAVIOURISCONFIG
---
*/

using System;
using System.Collections;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Text.RegularExpressions;

namespace Catzc.Base.Languages;

public sealed class FileCarriersConfig : Catzc.Base.Objects.DictionaryRecord
{
    public const Catzc.Base.CodeMeta.HeadAnchor DefaultAnchor = Catzc.Base.CodeMeta.HeadAnchor.Start;

    // A front-matter block sits at the reserved top-level key unless the entry nests it under another tool's keys.
    public const string DefaultKey = Catzc.Base.MarkdownMeta.MarkdownDocument.MetaKey;

    private const string Failed = "file-carriers config validation failed:\n";
    private static readonly string[] AllowedKeys = { "carriers" };
    private static readonly string[] AllowedEntryKeys = { "files", "carrier", "key", "line", "block", "anchor", "preamble_lines", "property", "sidecar", "reason", "exclude", "strip" };
    private static readonly Regex EntryId = new Regex("^[a-z][a-z0-9]*(-[a-z0-9]+)*$");

    // The file classes in declared order. Empty when the file declares none.
    public IReadOnlyList<FileCarrier> carriers { get; }

    public FileCarriersConfig(IDictionary raw)
    {
        List<string> errors = new List<string>();
        List<FileCarrier> result = new List<FileCarrier>();

        if (raw != null)
        {
            foreach (object k in raw.Keys)
            {
                string key = Text(k);
                if (Array.IndexOf(AllowedKeys, key) < 0)
                {
                    errors.Add(string.Format(CultureInfo.InvariantCulture, "unknown key '{0}' (allowed: {1})", key, string.Join(", ", AllowedKeys)));
                }
            }

            if (raw.Contains("carriers") && raw["carriers"] != null)
            {
                IDictionary map = raw["carriers"] as IDictionary;
                if (map == null)
                {
                    errors.Add("invalid carriers (must be a map of file class -> { carrier, ... })");
                }
                else
                {
                    foreach (object idKey in map.Keys)
                    {
                        FileCarrier entry = ReadEntry(Text(idKey), map[idKey], errors);
                        if (entry != null) { result.Add(entry); }
                    }
                }
            }
        }

        if (errors.Count > 0) { throw new ArgumentException(Failed + string.Join("\n", errors)); }
        carriers = result;
    }

    // The entry with this id, or null when the file declares none.
    public FileCarrier Find(string id) => carriers.FirstOrDefault(c => string.Equals(c.id, id, StringComparison.Ordinal));

    private static string Text(object value) => value == null ? "" : Convert.ToString(value, CultureInfo.InvariantCulture);

    private static bool Has(IDictionary entry, string key) => entry.Contains(key) && entry[key] != null;

    // A kebab-case name such as front-matter reads as the enum member FrontMatter; a number never does.
    private static bool TryParseKebab<T>(string text, out T value) where T : struct
    {
        value = default(T);
        return !int.TryParse(text, out _) && Enum.TryParse(text.Replace("-", ""), true, out value) && string.Equals(KebabOf(value.ToString()), text, StringComparison.Ordinal);
    }

    private static string KebabOf(string name) => Regex.Replace(name, "(?<=[a-z0-9])(?=[A-Z])", "-").ToLowerInvariant();

    private static string Names<T>() where T : struct => string.Join(", ", Enum.GetNames(typeof(T)).Select(KebabOf));

    private static FileCarrier ReadEntry(string id, object value, List<string> errors)
    {
        int before = errors.Count;
        if (!EntryId.IsMatch(id))
        {
            errors.Add(string.Format(CultureInfo.InvariantCulture, "carriers: invalid file class id '{0}' (kebab-case)", id));
        }
        IDictionary entry = value as IDictionary;
        if (entry == null)
        {
            errors.Add(string.Format(CultureInfo.InvariantCulture, "carriers['{0}'] must be a mapping {{ carrier, ... }}", id));
            return null;
        }
        foreach (object k in entry.Keys)
        {
            string key = Text(k);
            if (Array.IndexOf(AllowedEntryKeys, key) < 0)
            {
                errors.Add(string.Format(CultureInfo.InvariantCulture, "carriers['{0}']: unknown key '{1}' (allowed: {2})", id, key, string.Join(", ", AllowedEntryKeys)));
            }
        }

        string[] files = ReadStrings(id, "files", entry, errors);

        CarrierKind carrier = CarrierKind.None;
        if (!Has(entry, "carrier"))
        {
            errors.Add(string.Format(CultureInfo.InvariantCulture, "carriers['{0}'] needs a carrier (one of: {1})", id, Names<CarrierKind>()));
        }
        else if (!TryParseKebab(Text(entry["carrier"]), out carrier))
        {
            errors.Add(string.Format(CultureInfo.InvariantCulture, "carriers['{0}']: unknown carrier '{1}' (one of: {2})", id, Text(entry["carrier"]), Names<CarrierKind>()));
        }

        Catzc.Base.CodeMeta.HeadAnchor anchor = DefaultAnchor;
        if (Has(entry, "anchor") && !TryParseKebab(Text(entry["anchor"]), out anchor))
        {
            errors.Add(string.Format(CultureInfo.InvariantCulture, "carriers['{0}']: unknown anchor '{1}' (one of: {2})", id, Text(entry["anchor"]), Names<Catzc.Base.CodeMeta.HeadAnchor>()));
        }

        string line = Has(entry, "line") ? Text(entry["line"]) : null;
        string[] block = ReadStrings(id, "block", entry, errors);
        string[] strip = ReadStrings(id, "strip", entry, errors);
        string keyPath = Has(entry, "key") ? Text(entry["key"]) : (carrier == CarrierKind.FrontMatter ? DefaultKey : null);
        string property = Has(entry, "property") ? Text(entry["property"]) : null;
        string sidecar = Has(entry, "sidecar") ? Text(entry["sidecar"]) : null;
        string reason = Has(entry, "reason") ? Text(entry["reason"]).Trim() : null;
        int preambleLines = 0;
        if (Has(entry, "preamble_lines") && !int.TryParse(Text(entry["preamble_lines"]), NumberStyles.None, CultureInfo.InvariantCulture, out preambleLines))
        {
            errors.Add(string.Format(CultureInfo.InvariantCulture, "carriers['{0}']: preamble_lines must be a whole number", id));
        }

        Dictionary<string, string> exclude = ReadExclude(id, entry, errors);

        if (errors.Count > before) { return null; }

        Require(errors, id, carrier == CarrierKind.CommentHead || (line == null && block.Length == 0), "line and block belong to a comment-head carrier");
        Require(errors, id, carrier != CarrierKind.CommentHead || (line == null) != (block.Length == 0), "a comment head needs exactly one of line and block");
        Require(errors, id, line == null || (line.Length > 0 && !line.Any(char.IsWhiteSpace)), "line must be a non-empty comment prefix without spaces");
        Require(errors, id, block.Length == 0 || (block.Length == 2 && block.All(b => b.Length > 0)), "block must be the opening and the closing delimiter");
        Require(errors, id, carrier == CarrierKind.CommentHead || !entry.Contains("anchor"), "anchor belongs to a comment-head carrier");
        Require(errors, id, carrier == CarrierKind.CommentHead || carrier == CarrierKind.Property || strip.Length == 0, "strip belongs to a comment-head or property carrier");
        Require(errors, id, strip.All(opener => opener.Length > 0 && opener.Trim() == opener), "strip lists the beginning of each old head, without surrounding spaces");
        Require(errors, id, anchor == Catzc.Base.CodeMeta.HeadAnchor.AfterPreamble ? preambleLines > 0 : preambleLines == 0, "preamble_lines is required, and only allowed, with anchor after-preamble");
        Require(errors, id, carrier == CarrierKind.FrontMatter || keyPath == null, "key belongs to a front-matter carrier");
        Require(errors, id, keyPath == null || Catzc.Base.MarkdownMeta.MarkdownDocument.IsKeyPath(keyPath), "key is a dotted path of plain keys ending in " + DefaultKey + " (e.g. metadata." + DefaultKey + ")");
        Require(errors, id, carrier == CarrierKind.Property ? !string.IsNullOrEmpty(property) : property == null, "property is required, and only allowed, for a property carrier");
        Require(errors, id, carrier == CarrierKind.Sidecar ? (sidecar != null && (sidecar.Contains("{base}") || sidecar.Contains("{stem}"))) : sidecar == null, "sidecar is required, and only allowed, for a sidecar carrier, and names {base} or {stem}");
        Require(errors, id, carrier == CarrierKind.None ? !string.IsNullOrEmpty(reason) : reason == null, "reason is required, and only allowed, when the carrier is none");
        Require(errors, id, carrier != CarrierKind.Sidecar || files.Length > 0, "a sidecar carrier selects its files with files");
        if (errors.Count > before) { return null; }

        return new FileCarrier(id, files, carrier, line, block, anchor, preambleLines, property, sidecar, reason, exclude, strip, keyPath);
    }

    // A map of glob to the reason its files carry no block, so a gap in the coverage is a visible, reviewed entry.
    private static Dictionary<string, string> ReadExclude(string id, IDictionary entry, List<string> errors)
    {
        var exclude = new Dictionary<string, string>(StringComparer.Ordinal);
        if (!Has(entry, "exclude")) { return exclude; }
        IDictionary map = entry["exclude"] as IDictionary;
        if (map == null)
        {
            errors.Add(string.Format(CultureInfo.InvariantCulture, "carriers['{0}']: exclude must be a map of glob to the reason its files carry no block", id));
            return exclude;
        }
        foreach (DictionaryEntry pair in map)
        {
            string glob = Text(pair.Key);
            string why = Text(pair.Value).Trim();
            if (glob.Length == 0 || why.Length == 0)
            {
                errors.Add(string.Format(CultureInfo.InvariantCulture, "carriers['{0}']: exclude '{1}' needs a glob and a reason", id, glob));
                continue;
            }
            exclude[glob] = why;
        }
        return exclude;
    }

    private static void Require(List<string> errors, string id, bool condition, string message)
    {
        if (!condition) { errors.Add(string.Format(CultureInfo.InvariantCulture, "carriers['{0}']: {1}", id, message)); }
    }

    private static string[] ReadStrings(string id, string key, IDictionary entry, List<string> errors)
    {
        if (!Has(entry, key)) { return Array.Empty<string>(); }
        IList list = entry[key] as IList;
        if (list == null)
        {
            errors.Add(string.Format(CultureInfo.InvariantCulture, "carriers['{0}']: {1} must be a list of strings", id, key));
            return Array.Empty<string>();
        }
        List<string> items = new List<string>();
        foreach (object item in list)
        {
            string text = Text(item);
            if (text.Length == 0)
            {
                errors.Add(string.Format(CultureInfo.InvariantCulture, "carriers['{0}']: {1} has an empty entry", id, key));
            }
            else if (key == "files" && items.Contains(text))
            {
                errors.Add(string.Format(CultureInfo.InvariantCulture, "carriers['{0}']: duplicate files entry '{1}'", id, text));
            }
            else
            {
                items.Add(text);
            }
        }
        return items.ToArray();
    }
}
