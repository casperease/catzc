// The file-language registry (configs/languages.yml): every file language the repository's tracked files are written
// in, each named by its extensions ([ADR-DSGN-TRACK#6](/docs/adr/design/tracks.md#rule-adr-dsgn-track6)), with the
// formatter engine that formats it and its ADR folder. Registered in Catzc.Base.Config/configs/configs.yml
// (type: Catzc.Base.Languages.LanguagesConfig), so Get-Config -Config languages returns this typed record; Get-FileLanguage
// and Format-Code read it. Property names mirror the YAML keys (snake_case,
// [ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)).
//
// Formatting is configured, not programmed
// ([ADR-PRIN-CONFIG#1](/docs/adr/principles/configure-not-program.md#rule-adr-prin-config1)): an entry names the
// formatter ENGINE that formats its files, one of FormatterEngines below, and Format-Code runs that engine. A language
// with nothing to format states why in 'no_formatter' instead
// ([ADR-PRIN-CONFIG#4](/docs/adr/principles/configure-not-program.md#rule-adr-prin-config4)), so every language
// carries exactly one of the two and a gap is a visible, reviewed entry.
//
// The sensible defaults are declared here, once
// ([ADR-AUTO-DEFAULT#6](/docs/adr/automation/sensible-defaults.md#rule-adr-auto-default6)): an omitted 'languages' is no
// file language, and an omitted 'adr_folder' is none.
//
// Constructing an instance validates the file, collecting every violation into one ArgumentException:
//   - only the key 'languages' at the top, and only 'extensions', 'formatter', 'no_formatter' and 'adr_folder' in an
//     entry — an unknown key (a typo) fails at load;
//   - a language name is kebab-case;
//   - 'extensions' is a non-empty list; each extension starts with its leading dot, is lowercase letters and digits
//     after it (e.g. .ps1), and belongs to exactly one file language (an extension claimed twice is rejected);
//   - exactly one of 'formatter' (an engine in FormatterEngines) and 'no_formatter' (a non-empty reason);
//   - 'adr_folder' is a '/'-separated folder under docs/adr/, no leading or trailing slash, no '.' or '..' segment.

using System;
using System.Collections;
using System.Collections.Generic;
using System.Globalization;
using System.Text.RegularExpressions;

namespace Catzc.Base.Languages;

public sealed class LanguagesConfig : Catzc.Base.Objects.DictionaryRecord
{
    private const string Failed = "languages config validation failed:\n";
    private static readonly string[] AllowedKeys = { "languages" };
    private static readonly string[] AllowedEntryKeys = { "extensions", "formatter", "no_formatter", "adr_folder" };
    private static readonly Regex LanguageName = new Regex("^[a-z][a-z0-9]*(-[a-z0-9]+)*$");
    private static readonly Regex Extension = new Regex("^\\.[a-z0-9]+$");
    private static readonly Regex AdrFolder = new Regex("^[A-Za-z0-9_-][A-Za-z0-9._-]*(/[A-Za-z0-9_-][A-Za-z0-9._-]*)*$");

    private readonly Dictionary<string, FileLanguage> byExtension = new Dictionary<string, FileLanguage>(StringComparer.Ordinal);
    private readonly Dictionary<string, string> claimedBy = new Dictionary<string, string>(StringComparer.Ordinal);

    // The formatter engines a language may name: one Format-Code adapter each. A new engine is new mechanism — its
    // adapter and its name here land together
    // ([ADR-PRIN-CONFIG#2](/docs/adr/principles/configure-not-program.md#rule-adr-prin-config2)).
    private static readonly string[] Engines = { "prettier", "gofmt", "ruff", "psscriptanalyzer" };
    public static IReadOnlyList<string> FormatterEngines => Engines;

    // The file languages in declared order. Empty when the file declares none.
    public IReadOnlyList<FileLanguage> languages { get; }

    public LanguagesConfig(IDictionary raw)
    {
        List<string> errors = new List<string>();
        List<FileLanguage> result = new List<FileLanguage>();

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

            if (raw.Contains("languages") && raw["languages"] != null)
            {
                IDictionary map = raw["languages"] as IDictionary;
                if (map == null)
                {
                    errors.Add("invalid languages (must be a map of language -> { extensions, formatter | no_formatter, adr_folder })");
                }
                else
                {
                    foreach (object nameKey in map.Keys)
                    {
                        FileLanguage language = ReadLanguage(Text(nameKey), map[nameKey], errors);
                        if (language != null) { result.Add(language); }
                    }
                }
            }
        }

        if (errors.Count > 0) { throw new ArgumentException(Failed + string.Join("\n", errors)); }
        languages = result;
    }

    // The file language an extension names (with or without its leading dot, any case), or null when none does.
    public FileLanguage ForExtension(string extension)
    {
        if (string.IsNullOrEmpty(extension)) { return null; }
        string key = extension.StartsWith(".", StringComparison.Ordinal) ? extension : "." + extension;
        FileLanguage language;
        return byExtension.TryGetValue(key.ToLowerInvariant(), out language) ? language : null;
    }

    // The file language of a file path, by its extension, or null when the extension names none or the file has none.
    public FileLanguage ForPath(string path) => ForExtension(ExtensionOf(path));

    // The extension of a file path, lowercase with its leading dot, or null when it has none. A dotfile whose only dot
    // is its first character (.gitkeep, .editorconfig) has no extension.
    public static string ExtensionOf(string path)
    {
        if (string.IsNullOrEmpty(path)) { return null; }
        string normalized = path.Replace('\\', '/');
        string fileName = normalized.Substring(normalized.LastIndexOf('/') + 1);
        int dot = fileName.LastIndexOf('.');
        if (dot <= 0 || dot == fileName.Length - 1) { return null; }
        return fileName.Substring(dot).ToLowerInvariant();
    }

    private static string Text(object value) => value == null ? "" : Convert.ToString(value, CultureInfo.InvariantCulture);

    private FileLanguage ReadLanguage(string name, object value, List<string> errors)
    {
        int before = errors.Count;
        if (!LanguageName.IsMatch(name))
        {
            errors.Add(string.Format(CultureInfo.InvariantCulture, "languages: invalid language name '{0}' (kebab-case)", name));
        }
        IDictionary entry = value as IDictionary;
        if (entry == null)
        {
            errors.Add(string.Format(CultureInfo.InvariantCulture, "languages['{0}'] must be a mapping {{ extensions, formatter | no_formatter, adr_folder }}", name));
            return null;
        }
        foreach (object k in entry.Keys)
        {
            string key = Text(k);
            if (Array.IndexOf(AllowedEntryKeys, key) < 0)
            {
                errors.Add(string.Format(CultureInfo.InvariantCulture, "languages['{0}']: unknown key '{1}' (allowed: {2})", name, key, string.Join(", ", AllowedEntryKeys)));
            }
        }

        List<string> extensions = ReadExtensions(name, entry.Contains("extensions") ? entry["extensions"] : null, errors);

        string formatter = null;
        if (entry.Contains("formatter") && entry["formatter"] != null)
        {
            formatter = Text(entry["formatter"]);
            if (Array.IndexOf(Engines, formatter) < 0)
            {
                errors.Add(string.Format(CultureInfo.InvariantCulture, "languages['{0}']: unknown formatter engine '{1}' (one of: {2})", name, formatter, string.Join(", ", FormatterEngines)));
            }
        }

        string noFormatter = null;
        if (entry.Contains("no_formatter") && entry["no_formatter"] != null)
        {
            noFormatter = Text(entry["no_formatter"]).Trim();
            if (noFormatter.Length == 0) { noFormatter = null; }
        }
        if (formatter == null && noFormatter == null)
        {
            errors.Add(string.Format(CultureInfo.InvariantCulture, "languages['{0}'] needs a formatter engine (formatter: one of {1}) or the reason it has none (no_formatter: <reason>)", name, string.Join(", ", FormatterEngines)));
        }
        else if (formatter != null && noFormatter != null)
        {
            errors.Add(string.Format(CultureInfo.InvariantCulture, "languages['{0}'] names both a formatter and no_formatter; keep one", name));
        }

        string adrFolder = null;
        if (entry.Contains("adr_folder") && entry["adr_folder"] != null)
        {
            adrFolder = Text(entry["adr_folder"]);
            bool dotSegment = Array.Exists(adrFolder.Split('/'), s => s == "." || s == "..");
            if (!AdrFolder.IsMatch(adrFolder) || dotSegment)
            {
                errors.Add(string.Format(CultureInfo.InvariantCulture, "languages['{0}']: invalid adr_folder '{1}' (a '/'-separated folder under docs/adr/, e.g. automation/powershell)", name, adrFolder));
            }
        }

        if (errors.Count > before) { return null; }
        FileLanguage language = new FileLanguage(name, extensions.ToArray(), formatter, noFormatter, adrFolder);
        foreach (string extension in extensions) { byExtension[extension] = language; }
        return language;
    }

    private List<string> ReadExtensions(string name, object value, List<string> errors)
    {
        List<string> extensions = new List<string>();
        IList list = value as IList;
        if (value != null && list == null) { list = new object[] { value }; }
        if (list == null || list.Count == 0)
        {
            errors.Add(string.Format(CultureInfo.InvariantCulture, "languages['{0}'] needs at least one extension", name));
            return extensions;
        }
        foreach (object item in list)
        {
            string extension = Text(item);
            if (!extension.StartsWith(".", StringComparison.Ordinal))
            {
                errors.Add(string.Format(CultureInfo.InvariantCulture, "languages['{0}']: extension '{1}' needs its leading dot (e.g. .{1})", name, extension));
            }
            else if (!Extension.IsMatch(extension))
            {
                errors.Add(string.Format(CultureInfo.InvariantCulture, "languages['{0}']: invalid extension '{1}' (a dot, then lowercase letters and digits)", name, extension));
            }
            else if (extensions.Contains(extension))
            {
                errors.Add(string.Format(CultureInfo.InvariantCulture, "languages['{0}']: duplicate extension '{1}'", name, extension));
            }
            else if (claimedBy.ContainsKey(extension))
            {
                errors.Add(string.Format(CultureInfo.InvariantCulture, "languages['{0}']: extension '{1}' is already claimed by '{2}' (an extension belongs to one file language)", name, extension, claimedBy[extension]));
            }
            else
            {
                claimedBy[extension] = name;
                extensions.Add(extension);
            }
        }
        return extensions;
    }
}
