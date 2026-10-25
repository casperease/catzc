using System;
using System.Collections;
using System.Collections.Generic;
using System.Text.RegularExpressions;

namespace Catzc.Base.VSCode;

// Rests on [ADR-AUTO-DEFAULT-ONERESOLUTIONORDER](/docs/drs/automation/sensible-defaults.md#rule-adr-auto-default-oneresolutionorder).
public sealed class FileIconsConfig : Catzc.Base.Objects.DictionaryRecord
{
    private const string Failed = "file-icons config validation failed:\n";
    private static readonly string[] AllowedKeys = { "file", "folder", "icons" };
    private static readonly Regex Hex = new Regex("^#[0-9a-fA-F]{6}$", RegexOptions.CultureInvariant);

    // The colour of a file no icon marks, and of a folder; file-icons.yml overrides them, never restates them.
    public const string DefaultFile = "#8c8c8c";
    public const string DefaultFolder = "#8fa3bd";

    public string file { get; }

    public string folder { get; }

    // Every icon, in authored order.
    public IReadOnlyList<FileIcon> icons { get; }

    public FileIconsConfig(IDictionary raw)
    {
        List<string> errors = new List<string>();
        if (raw == null) { throw new ArgumentException(Failed + "the registry must be a mapping"); }
        foreach (object k in raw.Keys)
        {
            string key = k == null ? null : k.ToString();
            if (Array.IndexOf(AllowedKeys, key) < 0) { errors.Add(string.Format("unknown top-level key '{0}' (allowed: {1})", key, string.Join(", ", AllowedKeys))); }
        }

        file = Colour(raw, "file", DefaultFile, errors);
        folder = Colour(raw, "folder", DefaultFolder, errors);

        List<FileIcon> list = new List<FileIcon>();
        object value = raw.Contains("icons") ? raw["icons"] : null;
        IDictionary map = value as IDictionary;
        if (value != null && map == null) { errors.Add("'icons' must be a mapping of icon -> entry"); }
        Dictionary<string, string> claimed = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase);
        if (map != null)
        {
            foreach (DictionaryEntry pair in map)
            {
                FileIcon icon = new FileIcon(pair.Key == null ? null : pair.Key.ToString(), pair.Value, errors);
                foreach (string match in Matches(icon))
                {
                    string owner;
                    if (claimed.TryGetValue(match, out owner)) { errors.Add(string.Format("'{0}' is marked by both '{1}' and '{2}'", match, owner, icon.name)); }
                    else { claimed[match] = icon.name; }
                }
                list.Add(icon);
            }
        }
        icons = list.AsReadOnly();
        if (errors.Count > 0) { throw new ArgumentException(Failed + string.Join("\n", errors)); }
    }

    private static IEnumerable<string> Matches(FileIcon icon)
    {
        foreach (string extension in icon.extensions) { yield return "*." + extension; }
        foreach (string name in icon.names) { yield return name; }
        foreach (string id in icon.language_ids) { yield return "language id " + id; }
        if (icon.language != null) { yield return "language " + icon.language; }
    }

    private static string Colour(IDictionary raw, string key, string fallback, List<string> errors)
    {
        if (!raw.Contains(key) || raw[key] == null) { return fallback; }
        string value = raw[key] as string;
        if (value == null || !Hex.IsMatch(value))
        {
            errors.Add(string.Format("'{0}' must be a six-digit hex colour", key));
            return fallback;
        }
        return value.ToLowerInvariant();
    }
}
