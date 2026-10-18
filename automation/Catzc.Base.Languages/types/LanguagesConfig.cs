/*
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.Languages/types/LanguagesConfig.cs
    folder: types
    name: languages-config
    filetype: cs
    kind: type
    language: csharp
    track: automation
    tracktype: modules
    module: Catzc.Base.Languages
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    page: docs/references/automation/catzc-base-languages/types/LanguagesConfig.cs.md
    test: automation/Catzc.Base.Languages/tests/types/LanguagesConfig.Tests.ps1
    cites:
      - ADR-AUTO-DEFAULT#6
      - ADR-AUTO-MODULE#2
      - ADR-AUTO-TYPES#8
      - ADR-DSGN-TRACK#6
      - ADR-PRIN-CONFIG#{1,2,4}
      - ADR-REPO-FORMAT#8
---
*/

using System;
using System.Collections;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Text.RegularExpressions;

namespace Catzc.Base.Languages;

// Rests on [ADR-AUTO-MODULE#2](/docs/adr/automation/module-model.md#rule-adr-auto-module2).
public sealed class LanguagesConfig : Catzc.Base.Objects.DictionaryRecord
{
    private const string Failed = "languages config validation failed:\n";
    private static readonly string[] AllowedKeys = { "formatters", "imprint", "steps", "languages" };
    private static readonly string[] AllowedEntryKeys = { "extensions", "formatter", "no_formatter", "vscode_language", "adr_folder", "checks", "imprint", "layout", "tests" };
    private static readonly string[] AllowedTestsKeys = { "runner", "tools", "executable", "engine" };
    private static readonly Regex CommandName = new Regex("^[A-Z][a-z]+-[A-Z][A-Za-z0-9]*$");
    private static readonly Regex ParameterName = new Regex("^[A-Z][A-Za-z0-9]*$");
    private static readonly string[] AllowedLayoutKeys = { "folder", "role", "extensions", "live", "shipped" };
    private static readonly Regex LayoutFolder = new Regex("^(\\.|[a-z][a-z0-9]*(-[a-z0-9]+)*)$");
    private static readonly Regex LayoutRole = new Regex("^[a-z][a-z0-9]*(-[a-z0-9]+)*$");
    private static readonly string[] AllowedStepKeys = { "settings" };
    private static readonly Regex CheckName = new Regex("^Test-[A-Z][A-Za-z0-9]*$");
    private static readonly string[] AllowedEngineKeys = { "vscode_extension", "settings" };
    // A settings entry is a repository-relative file, or `<file>#<key>` for one top-level key of a YAML file.
    private static readonly Regex SettingsPath = new Regex("^[A-Za-z0-9_.-]+(/[A-Za-z0-9_.-]+)*(#[A-Za-z0-9_]+)?$");
    private static readonly Regex LanguageName = new Regex("^[a-z][a-z0-9]*(-[a-z0-9]+)*$");
    private static readonly Regex Extension = new Regex("^\\.[a-z0-9]+$");
    private static readonly Regex AdrFolder = new Regex("^[A-Za-z0-9_-][A-Za-z0-9._-]*(/[A-Za-z0-9_-][A-Za-z0-9._-]*)*$");
    private static readonly Regex VscodeLanguage = new Regex("^[a-z][a-z0-9-]*$");
    private static readonly Regex VscodeExtension = new Regex("^[A-Za-z0-9][A-Za-z0-9-]*\\.[A-Za-z0-9][A-Za-z0-9-]*$");

    private readonly Dictionary<string, FileLanguage> byExtension = new Dictionary<string, FileLanguage>(StringComparer.Ordinal);
    private readonly Dictionary<string, string> claimedBy = new Dictionary<string, string>(StringComparer.Ordinal);

    private static readonly string[] Engines = { "prettier", "gofmt", "ruff", "psscriptanalyzer", "dotnet-format", "bicep" };
    public static IReadOnlyList<string> FormatterEngines => Engines;

    // A new imprint step is new mechanism too: its Format-Code adapter and its name here must land together.
    private static readonly string[] StepNames = { "file-meta", "csharp-namespace", "comments", "ps-help" };
    public static IReadOnlyList<string> ImprintSteps => StepNames;

    // The imprint steps Format-Code runs after every language's formatter, over every language. Empty when the file lists none.
    public IReadOnlyList<string> imprint { get; }

    // Every step the file lists, globally or for a language, with the files its cache stamp reads (none unless the file says).
    public IReadOnlyDictionary<string, ImprintStep> steps { get; }

    // The file languages in declared order. Empty when the file declares none.
    public IReadOnlyList<FileLanguage> languages { get; }

    public IReadOnlyDictionary<string, FormatterEngine> formatters { get; }

    // The one layout: every language's rows in declared order, then the shared rows. No folder is named twice.
    public IReadOnlyList<LayoutRow> layout { get; }

    // The globs, relative to a module root, that place the live files: the live rows' patterns.
    public IReadOnlyList<string> LivePatterns() => layout.Where(r => r.live).SelectMany(r => r.Patterns()).ToArray();

    public LayoutRow PlaceOf(string relativePath)
    {
        if (string.IsNullOrEmpty(relativePath)) { return null; }
        int slash = relativePath.IndexOf('/');
        if (slash < 0)
        {
            string extension = ExtensionOf(relativePath);
            return extension == null ? null : layout.FirstOrDefault(r => r.folder == LayoutRow.Root && r.extensions.Contains(extension));
        }
        string folder = relativePath.Substring(0, slash);
        return layout.FirstOrDefault(r => r.folder == folder);
    }

    // The module subfolders the layout names (never the root), in layout order.
    public IReadOnlyList<string> LayoutFolders() => layout.Where(r => r.folder != LayoutRow.Root).Select(r => r.folder).ToArray();

    // The module subfolders a build ships verbatim.
    public IReadOnlyList<string> ShippedFolders() => layout.Where(r => r.shipped && r.folder != LayoutRow.Root).Select(r => r.folder).ToArray();

    public LanguagesConfig(IDictionary raw)
    {
        List<string> errors = new List<string>();
        List<FileLanguage> result = new List<FileLanguage>();
        Dictionary<string, FormatterEngine> engineMap = new Dictionary<string, FormatterEngine>(StringComparer.Ordinal);
        Dictionary<string, ImprintStep> stepMap = new Dictionary<string, ImprintStep>(StringComparer.Ordinal);
        List<string> globalSteps = new List<string>();

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

            if (raw.Contains("formatters") && raw["formatters"] != null)
            {
                ReadEngines(raw["formatters"], engineMap, errors);
            }

            if (raw.Contains("imprint") && raw["imprint"] != null)
            {
                globalSteps = ReadStepNames("imprint", raw["imprint"], errors);
            }

            if (raw.Contains("steps") && raw["steps"] != null)
            {
                ReadSteps(raw["steps"], stepMap, errors);
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

        // A step both global and a language's own would run twice over that language's files.
        foreach (FileLanguage language in result)
        {
            foreach (string step in language.imprint)
            {
                if (globalSteps.Contains(step))
                {
                    errors.Add(string.Format(CultureInfo.InvariantCulture, "languages['{0}']: imprint lists '{1}', which is already global (top-level imprint)", language.name, step));
                }
            }
        }

        // A subfolder is named by one row of the whole layout; the shared rows count, so a language cannot redeclare assets or tests.
        List<LayoutRow> rows = new List<LayoutRow>();
        foreach (FileLanguage language in result) { rows.AddRange(language.layout); }
        rows.AddRange(LayoutRow.Shared);
        Dictionary<string, string> folderOwner = new Dictionary<string, string>(StringComparer.Ordinal);
        foreach (LayoutRow row in rows)
        {
            if (row.folder == LayoutRow.Root) { continue; }
            string owner = row.language ?? "(shared)";
            string first;
            if (folderOwner.TryGetValue(row.folder, out first))
            {
                errors.Add(string.Format(CultureInfo.InvariantCulture, "layout: folder '{0}' is named twice (by '{1}' and '{2}'); a folder has one row", row.folder, first, owner));
            }
            else
            {
                folderOwner[row.folder] = owner;
            }
        }

        if (errors.Count > 0) { throw new ArgumentException(Failed + string.Join("\n", errors)); }
        layout = rows;
        foreach (string step in globalSteps.Concat(result.SelectMany(l => l.imprint)))
        {
            if (!stepMap.ContainsKey(step)) { stepMap[step] = new ImprintStep(step, null); }
        }
        languages = result;
        formatters = engineMap;
        imprint = globalSteps;
        steps = stepMap;
    }

    // A list of known step names, each once.
    private static List<string> ReadStepNames(string where, object value, List<string> errors)
    {
        List<string> names = new List<string>();
        IList list = value as IList;
        if (list == null)
        {
            errors.Add(string.Format(CultureInfo.InvariantCulture, "{0} must be a list of imprint step names (one of: {1})", where, string.Join(", ", StepNames)));
            return names;
        }
        foreach (object item in list)
        {
            string name = Text(item);
            if (Array.IndexOf(StepNames, name) < 0)
            {
                errors.Add(string.Format(CultureInfo.InvariantCulture, "{0}: unknown imprint step '{1}' (one of: {2})", where, name, string.Join(", ", StepNames)));
            }
            else if (names.Contains(name))
            {
                errors.Add(string.Format(CultureInfo.InvariantCulture, "{0}: duplicate imprint step '{1}'", where, name));
            }
            else
            {
                names.Add(name);
            }
        }
        return names;
    }

    private static void ReadSteps(object value, Dictionary<string, ImprintStep> stepMap, List<string> errors)
    {
        IDictionary map = value as IDictionary;
        if (map == null)
        {
            errors.Add("invalid steps (must be a map of imprint step -> { settings })");
            return;
        }
        foreach (object nameKey in map.Keys)
        {
            string name = Text(nameKey);
            if (Array.IndexOf(StepNames, name) < 0)
            {
                errors.Add(string.Format(CultureInfo.InvariantCulture, "steps: unknown imprint step '{0}' (one of: {1})", name, string.Join(", ", StepNames)));
                continue;
            }
            IDictionary entry = map[nameKey] as IDictionary;
            if (entry == null)
            {
                errors.Add(string.Format(CultureInfo.InvariantCulture, "steps['{0}'] must be a mapping {{ settings }}", name));
                continue;
            }
            foreach (object k in entry.Keys)
            {
                if (Array.IndexOf(AllowedStepKeys, Text(k)) < 0)
                {
                    errors.Add(string.Format(CultureInfo.InvariantCulture, "steps['{0}']: unknown key '{1}' (allowed: {2})", name, Text(k), string.Join(", ", AllowedStepKeys)));
                }
            }
            List<string> settings = new List<string>();
            if (entry.Contains("settings") && entry["settings"] != null)
            {
                IList list = entry["settings"] as IList;
                if (list == null)
                {
                    errors.Add(string.Format(CultureInfo.InvariantCulture, "steps['{0}']: invalid settings (a list of repository-relative files)", name));
                    continue;
                }
                foreach (object item in list)
                {
                    string path = Text(item);
                    bool dotSegment = Array.Exists(path.Split('/'), s => s == "." || s == "..");
                    if (!SettingsPath.IsMatch(path) || dotSegment)
                    {
                        errors.Add(string.Format(CultureInfo.InvariantCulture, "steps['{0}']: invalid settings file '{1}' (a '/'-separated repository-relative path)", name, path));
                    }
                    else
                    {
                        settings.Add(path);
                    }
                }
            }
            stepMap[name] = new ImprintStep(name, settings.ToArray());
        }
    }

    public IReadOnlyDictionary<string, string> EditorFormatters()
    {
        Dictionary<string, string> result = new Dictionary<string, string>(StringComparer.Ordinal);
        foreach (FileLanguage language in languages)
        {
            FormatterEngine engine;
            if (language.formatter != null && formatters.TryGetValue(language.formatter, out engine) && engine.vscode_extension != null)
            {
                result[language.vscode_language] = engine.vscode_extension;
            }
        }
        return result;
    }

    private static void ReadEngines(object value, Dictionary<string, FormatterEngine> engineMap, List<string> errors)
    {
        IDictionary map = value as IDictionary;
        if (map == null)
        {
            errors.Add("invalid formatters (must be a map of formatter -> { vscode_extension, settings })");
            return;
        }
        foreach (object nameKey in map.Keys)
        {
            string name = Text(nameKey);
            if (Array.IndexOf(Engines, name) < 0)
            {
                errors.Add(string.Format(CultureInfo.InvariantCulture, "formatters: unknown formatter engine '{0}' (one of: {1})", name, string.Join(", ", Engines)));
                continue;
            }
            IDictionary entry = map[nameKey] as IDictionary;
            if (entry == null)
            {
                errors.Add(string.Format(CultureInfo.InvariantCulture, "formatters['{0}'] must be a mapping {{ vscode_extension, settings }}", name));
                continue;
            }
            foreach (object k in entry.Keys)
            {
                if (Array.IndexOf(AllowedEngineKeys, Text(k)) < 0)
                {
                    errors.Add(string.Format(CultureInfo.InvariantCulture, "formatters['{0}']: unknown key '{1}' (allowed: {2})", name, Text(k), string.Join(", ", AllowedEngineKeys)));
                }
            }
            int before = errors.Count;
            string extension = entry.Contains("vscode_extension") && entry["vscode_extension"] != null ? Text(entry["vscode_extension"]) : null;
            if (extension != null && !VscodeExtension.IsMatch(extension))
            {
                errors.Add(string.Format(CultureInfo.InvariantCulture, "formatters['{0}']: invalid vscode_extension '{1}' (a publisher.name extension id)", name, extension));
            }
            List<string> settings = new List<string>();
            if (entry.Contains("settings") && entry["settings"] != null)
            {
                IList list = entry["settings"] as IList;
                if (list == null)
                {
                    errors.Add(string.Format(CultureInfo.InvariantCulture, "formatters['{0}']: invalid settings (a list of repository-relative files)", name));
                }
                else
                {
                    foreach (object item in list)
                    {
                        string path = Text(item);
                        bool dotSegment = Array.Exists(path.Split('/'), s => s == "." || s == "..");
                        if (!SettingsPath.IsMatch(path) || dotSegment)
                        {
                            errors.Add(string.Format(CultureInfo.InvariantCulture, "formatters['{0}']: invalid settings file '{1}' (a '/'-separated repository-relative path)", name, path));
                        }
                        else
                        {
                            settings.Add(path);
                        }
                    }
                }
            }
            if (errors.Count > before) { continue; }
            engineMap[name] = new FormatterEngine(name, extension, settings.ToArray());
        }
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
                errors.Add(string.Format(CultureInfo.InvariantCulture, "languages['{0}']: invalid adr_folder '{1}' (a '/'-separated folder under docs/adr/, e.g. pwsh)", name, adrFolder));
            }
        }

        string vscodeLanguage = name;
        if (entry.Contains("vscode_language") && entry["vscode_language"] != null)
        {
            vscodeLanguage = Text(entry["vscode_language"]);
            if (!VscodeLanguage.IsMatch(vscodeLanguage))
            {
                errors.Add(string.Format(CultureInfo.InvariantCulture, "languages['{0}']: invalid vscode_language '{1}' (a VS Code language id, e.g. azure-pipelines)", name, vscodeLanguage));
            }
        }

        List<string> checks = ReadChecks(name, entry.Contains("checks") ? entry["checks"] : null, errors);

        List<string> ownSteps = entry.Contains("imprint") && entry["imprint"] != null
            ? ReadStepNames(string.Format(CultureInfo.InvariantCulture, "languages['{0}'].imprint", name), entry["imprint"], errors)
            : new List<string>();

        List<LayoutRow> layoutRows = ReadLayout(name, extensions, entry.Contains("layout") ? entry["layout"] : null, errors);

        LanguageTestRunner tests = ReadTests(name, entry.Contains("tests") ? entry["tests"] : null, errors);

        if (errors.Count > before) { return null; }
        FileLanguage language = new FileLanguage(name, extensions.ToArray(), formatter, noFormatter, vscodeLanguage, adrFolder, checks.ToArray(), ownSteps.ToArray(), layoutRows.ToArray(), tests);
        foreach (string extension in extensions) { byExtension[extension] = language; }
        return language;
    }

    private static List<LayoutRow> ReadLayout(string name, List<string> languageExtensions, object value, List<string> errors)
    {
        List<LayoutRow> rows = new List<LayoutRow>();
        if (value == null) { return rows; }
        IList list = value as IList;
        if (list == null)
        {
            errors.Add(string.Format(CultureInfo.InvariantCulture, "languages['{0}']: layout must be a list of rows {{ folder, role, extensions, live, shipped }}", name));
            return rows;
        }
        HashSet<string> seen = new HashSet<string>(StringComparer.Ordinal);
        HashSet<string> rootExtensions = new HashSet<string>(StringComparer.Ordinal);
        foreach (object item in list)
        {
            IDictionary row = item as IDictionary;
            if (row == null)
            {
                errors.Add(string.Format(CultureInfo.InvariantCulture, "languages['{0}']: a layout row must be a mapping {{ folder, role, extensions, live, shipped }}", name));
                continue;
            }
            int before = errors.Count;
            foreach (object k in row.Keys)
            {
                if (Array.IndexOf(AllowedLayoutKeys, Text(k)) < 0)
                {
                    errors.Add(string.Format(CultureInfo.InvariantCulture, "languages['{0}'].layout: unknown key '{1}' (allowed: {2})", name, Text(k), string.Join(", ", AllowedLayoutKeys)));
                }
            }
            string folder = row.Contains("folder") && row["folder"] != null ? Text(row["folder"]) : null;
            if (folder == null || !LayoutFolder.IsMatch(folder))
            {
                errors.Add(string.Format(CultureInfo.InvariantCulture, "languages['{0}'].layout: invalid folder '{1}' (\".\" for the module root, or one lowercase folder name)", name, folder));
            }
            else if (folder != LayoutRow.Root && !seen.Add(folder))
            {
                errors.Add(string.Format(CultureInfo.InvariantCulture, "languages['{0}'].layout: folder '{1}' is named twice", name, folder));
            }
            string role = row.Contains("role") && row["role"] != null ? Text(row["role"]) : null;
            if (role == null || !LayoutRole.IsMatch(role))
            {
                errors.Add(string.Format(CultureInfo.InvariantCulture, "languages['{0}'].layout: invalid role '{1}' (kebab-case, e.g. public-function)", name, role));
            }
            List<string> rowExtensions = new List<string>();
            if (row.Contains("extensions") && row["extensions"] != null)
            {
                IList extensionList = row["extensions"] as IList;
                if (extensionList == null)
                {
                    errors.Add(string.Format(CultureInfo.InvariantCulture, "languages['{0}'].layout: extensions must be a list", name));
                }
                else
                {
                    foreach (object e in extensionList)
                    {
                        string extension = Text(e);
                        if (!languageExtensions.Contains(extension))
                        {
                            errors.Add(string.Format(CultureInfo.InvariantCulture, "languages['{0}'].layout: extension '{1}' is not one of the language's own", name, extension));
                        }
                        else if (folder == LayoutRow.Root && !rootExtensions.Add(extension))
                        {
                            errors.Add(string.Format(CultureInfo.InvariantCulture, "languages['{0}'].layout: extension '{1}' is placed by two root rows", name, extension));
                        }
                        else
                        {
                            rowExtensions.Add(extension);
                        }
                    }
                }
            }
            if (folder == LayoutRow.Root && rowExtensions.Count == 0)
            {
                errors.Add(string.Format(CultureInfo.InvariantCulture, "languages['{0}'].layout: the root row must list the extensions it places", name));
            }
            else if (folder != null && folder != LayoutRow.Root && rowExtensions.Count > 0)
            {
                errors.Add(string.Format(CultureInfo.InvariantCulture, "languages['{0}'].layout: only the root row lists extensions; folder '{1}' places every file in it", name, folder));
            }
            bool live = ReadFlag(name, row, "live", errors);
            bool shipped = ReadFlag(name, row, "shipped", errors);
            if (errors.Count > before) { continue; }
            rows.Add(new LayoutRow(name, folder, role, rowExtensions.ToArray(), live, shipped));
        }
        return rows;
    }

    private static bool ReadFlag(string name, IDictionary row, string key, List<string> errors)
    {
        if (!row.Contains(key) || row[key] == null) { return true; }
        if (row[key] is bool) { return (bool)row[key]; }
        errors.Add(string.Format(CultureInfo.InvariantCulture, "languages['{0}'].layout: {1} must be true or false", name, key));
        return true;
    }

    private static LanguageTestRunner ReadTests(string name, object value, List<string> errors)
    {
        if (value == null) { return null; }
        IDictionary map = value as IDictionary;
        string where = string.Format(CultureInfo.InvariantCulture, "languages['{0}'].tests", name);
        if (map == null)
        {
            errors.Add(where + ": must be a map of runner, tools, executable and engine");
            return null;
        }
        int before = errors.Count;
        foreach (object key in map.Keys)
        {
            if (Array.IndexOf(AllowedTestsKeys, Text(key)) < 0)
            {
                errors.Add(string.Format(CultureInfo.InvariantCulture, "{0}: unknown key '{1}' (allowed: {2})", where, Text(key), string.Join(", ", AllowedTestsKeys)));
            }
        }
        string runner = map.Contains("runner") ? Text(map["runner"]) : "";
        if (!CommandName.IsMatch(runner))
        {
            errors.Add(string.Format(CultureInfo.InvariantCulture, "{0}: runner '{1}' is not a command name (Verb-Noun)", where, runner));
        }
        string executable = map.Contains("executable") ? Text(map["executable"]) : "";
        if (!ParameterName.IsMatch(executable))
        {
            errors.Add(string.Format(CultureInfo.InvariantCulture, "{0}: executable '{1}' is not a parameter name (e.g. GoExecutable)", where, executable));
        }
        List<string> tools = new List<string>();
        if (map.Contains("tools") && map["tools"] != null)
        {
            IList list = map["tools"] as IList;
            if (list == null)
            {
                errors.Add(where + ": tools must be a list of tool names (e.g. [uv, python])");
            }
            else
            {
                foreach (object item in list)
                {
                    string tool = Text(item);
                    if (!LanguageName.IsMatch(tool) && !System.Text.RegularExpressions.Regex.IsMatch(tool, "^[a-z][a-z0-9_]*$"))
                    {
                        errors.Add(string.Format(CultureInfo.InvariantCulture, "{0}: invalid tool '{1}'", where, tool));
                    }
                    else if (tools.Contains(tool))
                    {
                        errors.Add(string.Format(CultureInfo.InvariantCulture, "{0}: duplicate tool '{1}'", where, tool));
                    }
                    else
                    {
                        tools.Add(tool);
                    }
                }
            }
        }
        string engine = map.Contains("engine") && map["engine"] != null ? Text(map["engine"]) : null;
        if (engine != null && !LanguageName.IsMatch(engine))
        {
            errors.Add(string.Format(CultureInfo.InvariantCulture, "{0}: invalid engine '{1}'", where, engine));
        }
        if ((engine == null) == (tools.Count == 0))
        {
            errors.Add(where + ": names either the tools that must resolve or the one engine the tests run under, never both and never neither");
        }
        if (errors.Count > before) { return null; }
        return new LanguageTestRunner(runner, tools.ToArray(), executable, engine);
    }

    private static List<string> ReadChecks(string name, object value, List<string> errors)
    {
        List<string> checks = new List<string>();
        if (value == null) { return checks; }
        IList list = value as IList;
        if (list == null)
        {
            errors.Add(string.Format(CultureInfo.InvariantCulture, "languages['{0}']: checks must be a list of quality-gate names (e.g. [Test-Spelling])", name));
            return checks;
        }
        foreach (object item in list)
        {
            string check = Text(item);
            if (!CheckName.IsMatch(check))
            {
                errors.Add(string.Format(CultureInfo.InvariantCulture, "languages['{0}']: invalid check '{1}' (a quality-gate command, Test-<Noun>)", name, check));
            }
            else if (checks.Contains(check))
            {
                errors.Add(string.Format(CultureInfo.InvariantCulture, "languages['{0}']: duplicate check '{1}'", name, check));
            }
            else
            {
                checks.Add(check);
            }
        }
        return checks;
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
