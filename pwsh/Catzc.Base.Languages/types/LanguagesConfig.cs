/*
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-languages/types/LanguagesConfig.cs.md"
  header: "generated"
---
*/

using System;
using System.Collections;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Text.RegularExpressions;
using static Catzc.Base.Languages.LanguageEntryReaders;
using static Catzc.Base.Languages.LanguageGlobalReaders;

namespace Catzc.Base.Languages;

// Rests on [ADR-AUTO-MODULE-EXISTSBYLAYOUT](/docs/drs/automation/module-model.md#rule-adr-auto-module-existsbylayout).
public sealed class LanguagesConfig : Catzc.Base.Objects.DictionaryRecord
{
    private const string Failed = "languages config validation failed:\n";
    private static readonly string[] AllowedKeys = { "formatters", "imprint", "steps", "naming", "languages" };
    private static readonly string[] AllowedEntryKeys = { "extensions", "formatter", "no_formatter", "vscode_language", "adr_folder", "checks", "check_scopes", "imprint", "layout", "tests", "executable", "naming", "tag", "shapes" };
    // The repository normal form when the file names none; rests on [ADR-AUTO-IDIOM-NORMALFORM](/docs/drs/automation/idiomatic-names.md#rule-adr-auto-idiom-normalform).
    private const string DefaultNormalForm = "snake";
    // A settings entry is a repository-relative file, or `<file>#<key>` for one top-level key of a YAML file.
    internal static readonly Regex SettingsPath = new Regex("^[A-Za-z0-9_.-]+(/[A-Za-z0-9_.-]+)*(#[A-Za-z0-9_]+)?$");
    internal static readonly Regex LanguageName = new Regex("^[a-z][a-z0-9]*(-[a-z0-9]+)*$");
    private static readonly Regex AdrFolder = new Regex("^[A-Za-z0-9_-][A-Za-z0-9._-]*(/[A-Za-z0-9_-][A-Za-z0-9._-]*)*$");
    private static readonly Regex VscodeLanguage = new Regex("^[a-z][a-z0-9-]*$");

    private readonly Dictionary<string, FileLanguage> byExtension = new Dictionary<string, FileLanguage>(StringComparer.Ordinal);
    private readonly Dictionary<string, string> claimedBy = new Dictionary<string, string>(StringComparer.Ordinal);

    internal static readonly string[] Engines = { "prettier", "gofmt", "ruff", "psscriptanalyzer", "dotnet-format", "bicep" };
    public static IReadOnlyList<string> FormatterEngines => Engines;

    // A new imprint step is new mechanism too: its Format-Code adapter and its name here must land together.
    internal static readonly string[] StepNames = { "file-meta", "bcl-namespace", "comments", "ps-help", "plan-counts" };
    public static IReadOnlyList<string> ImprintSteps => StepNames;

    // The imprint steps Format-Code runs after every language's formatter, over every language. Empty when the file lists none.
    public IReadOnlyList<string> imprint { get; }

    // Every step the file lists, globally or for a language, with the files its cache stamp reads (none unless the file says).
    public IReadOnlyDictionary<string, ImprintStep> steps { get; }

    // The file languages in declared order. Empty when the file declares none.
    public IReadOnlyList<FileLanguage> languages { get; }

    public IReadOnlyDictionary<string, FormatterEngine> formatters { get; }

    // The extensions of every language whose checks name the gate, once each, in declared order (e.g. the files Test-Spelling reads).
    public IReadOnlyList<string> ExtensionsCheckedBy(string check) =>
        languages.Where(l => l.checks.Contains(check)).SelectMany(l => l.extensions).Distinct(StringComparer.OrdinalIgnoreCase).ToArray();

    // Folders whose files no language's naming judges, at any depth (e.g. assets, named by their source); empty when the file lists none.
    public IReadOnlyList<string> naming_exempt_folders { get; }

    // The case every name has under its language's idiom, for the places that name a thing for more than one language.
    public string naming_normal_form { get; }

    // One finding per file name and per folder that breaks its language's naming, each folder once per language, in path order; rests on [ADR-AUTO-IDIOM-LANGUAGEIDIOM](/docs/drs/automation/idiomatic-names.md#rule-adr-auto-idiom-languageidiom).
    public IReadOnlyList<string> MisnamedPaths(IEnumerable<string> paths) => MisnamedPathRenames(paths).Select(r => r.Finding()).ToArray();

    // Each misnamed folder and file with the idiomatic name its language gives it, in the order MisnamedPaths reports them.
    public IReadOnlyList<PathRename> MisnamedPathRenames(IEnumerable<string> paths)
    {
        List<PathRename> renames = new List<PathRename>();
        HashSet<string> judgedFolders = new HashSet<string>(StringComparer.Ordinal);
        if (paths == null) { return renames; }
        foreach (string raw in paths.Where(p => !string.IsNullOrEmpty(p)).Select(p => p.Replace('\\', '/')).OrderBy(p => p, StringComparer.Ordinal))
        {
            FileLanguage language = JudgedLanguageOf(raw);
            if (language == null) { continue; }
            string[] segments = raw.Split('/');
            string parent = "";
            for (int i = 0; i < segments.Length - 1; i++)
            {
                string folderPath = string.Join("/", segments.Take(i + 1));
                if (!language.naming.IsFolderIdiomatic(segments[i]) && judgedFolders.Add(language.name + "|" + folderPath))
                {
                    string folderName = segments[i];
                    renames.Add(new PathRename(folderPath, "folder", language.name, string.Join(" or ", language.naming.folder),
                        Rendered(parent, () => language.naming.IdiomaticFolder(folderName))));
                }
                parent = folderPath + "/";
            }
            string fileName = segments[segments.Length - 1];
            string extension = ExtensionOf(fileName);
            string stem = fileName.Substring(0, fileName.Length - extension.Length);
            if (!language.naming.IsFileIdiomatic(stem))
            {
                renames.Add(new PathRename(raw, "file", language.name, string.Join(" or ", language.naming.file),
                    Rendered(parent, () => language.naming.IdiomaticFileStem(stem) + extension)));
            }
        }
        return renames;
    }

    // The renamed path, or null when the case has no rendering for the name (a verb-noun stem whose first word is no approved verb).
    private static string Rendered(string parent, Func<string> render)
    {
        try { return parent + render(); }
        catch (ArgumentException) { return null; }
    }

    // The finding for one function or type a file defines, or null when its name is idiomatic and round-trips through the normal form.
    public string MisnamedDefinition(string path, string kind, string name)
    {
        FileLanguage language = JudgedLanguageOf(path);
        if (language == null) { return null; }
        string finding = language.naming.JudgeName(kind, name, naming_normal_form);
        return finding == null ? null : string.Format(CultureInfo.InvariantCulture, "{0}: the {1} '{2}' {3} ({4})", path.Replace('\\', '/'), kind, name, finding, language.name);
    }

    // The language that judges a file's names, or null: it has a naming entry, and neither the file nor a folder on its path is exempt.
    private FileLanguage JudgedLanguageOf(string path)
    {
        if (string.IsNullOrEmpty(path)) { return null; }
        string normalized = path.Replace('\\', '/');
        FileLanguage language = ForPath(normalized);
        if (language == null || language.naming == null || language.naming.exempt.Contains(normalized)) { return null; }
        string[] segments = normalized.Split('/');
        return segments.Take(segments.Length - 1).Any(s => naming_exempt_folders.Contains(s)) ? null : language;
    }

    // The folder a catzc module's tests have under a language's tests/, in that language's folder case.
    public string TestFolderOf(string languageName, string module)
    {
        FileLanguage language = languages.FirstOrDefault(l => l.name == languageName);
        if (language == null || language.naming == null)
        {
            throw new ArgumentException(string.Format(CultureInfo.InvariantCulture, "languages['{0}']: no naming entry names its test folders' case", languageName));
        }
        return language.naming.TestFolderOf(module);
    }

    // The one layout: every language's rows in declared order, then the shared rows. No folder is named twice.
    public IReadOnlyList<LayoutRow> layout { get; }

    // The globs, relative to a module root, that place the live files: the live rows' patterns.
    public IReadOnlyList<string> LivePatterns() => layout.Where(r => r.live).SelectMany(r => r.Patterns()).ToArray();

    public bool IsLaidOut(IEnumerable trackLanguages)
    {
        string primary = null;
        if (trackLanguages != null)
        {
            foreach (object item in trackLanguages) { primary = Convert.ToString(item, CultureInfo.InvariantCulture); break; }
        }
        if (string.IsNullOrEmpty(primary)) { return false; }
        FileLanguage language = languages.FirstOrDefault(l => l.name == primary);
        return language != null && language.layout.Any(r => r.live);
    }

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

    // The module subfolder the layout gives a role (e.g. test, private-function): the one resolver of a folder-name setting (ADR-REPO-FOLDERS-NAMESARESETTINGS).
    public string FolderOf(string role)
    {
        LayoutRow row = layout.FirstOrDefault(r => r.role == role && r.folder != LayoutRow.Root);
        if (row == null) { throw new ArgumentException("languages config: no layout folder has the role '" + role + "'"); }
        return row.folder;
    }

    // The module subfolders a build ships verbatim.
    public IReadOnlyList<string> ShippedFolders() => layout.Where(r => r.shipped && r.folder != LayoutRow.Root).Select(r => r.folder).ToArray();

    public LanguagesConfig(IDictionary raw)
    {
        List<string> errors = new List<string>();
        List<FileLanguage> result = new List<FileLanguage>();
        Dictionary<string, FormatterEngine> engineMap = new Dictionary<string, FormatterEngine>(StringComparer.Ordinal);
        Dictionary<string, ImprintStep> stepMap = new Dictionary<string, ImprintStep>(StringComparer.Ordinal);
        List<string> globalSteps = new List<string>();
        List<string> exemptFolders = new List<string>();
        string normalForm = DefaultNormalForm;

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

            if (raw.Contains("naming") && raw["naming"] != null)
            {
                exemptFolders = ReadGlobalNaming(raw["naming"], errors, ref normalForm);
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
        naming_exempt_folders = exemptFolders;
        naming_normal_form = normalForm;
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

    // The file language an extension names (with or without its leading dot, any case), or null when none does.
    public FileLanguage ForExtension(string extension)
    {
        if (string.IsNullOrEmpty(extension)) { return null; }
        string key = extension.StartsWith(".", StringComparison.Ordinal) ? extension : "." + extension;
        FileLanguage language;
        return byExtension.TryGetValue(key.ToLowerInvariant(), out language) ? language : null;
    }

    public FileLanguage ForPath(string path)
    {
        if (string.IsNullOrEmpty(path)) { return null; }
        string normalized = path.Replace('\\', '/');
        string fileName = normalized.Substring(normalized.LastIndexOf('/') + 1).ToLowerInvariant();
        for (int dot = fileName.IndexOf('.', 1); dot > 0 && dot < fileName.Length - 1; dot = fileName.IndexOf('.', dot + 1))
        {
            FileLanguage language;
            if (byExtension.TryGetValue(fileName.Substring(dot), out language)) { return language; }
        }
        return null;
    }

    public static string ExtensionOf(string path)
    {
        if (string.IsNullOrEmpty(path)) { return null; }
        string normalized = path.Replace('\\', '/');
        string fileName = normalized.Substring(normalized.LastIndexOf('/') + 1);
        int dot = fileName.LastIndexOf('.');
        if (dot <= 0 || dot == fileName.Length - 1) { return null; }
        return fileName.Substring(dot).ToLowerInvariant();
    }

    internal static string Text(object value) => value == null ? "" : Convert.ToString(value, CultureInfo.InvariantCulture);

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

        List<string> extensions = ReadExtensions(name, entry.Contains("extensions") ? entry["extensions"] : null, claimedBy, errors);

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
                errors.Add(string.Format(CultureInfo.InvariantCulture, "languages['{0}']: invalid adr_folder '{1}' (a '/'-separated folder under the decision records' root, e.g. pwsh)", name, adrFolder));
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
        Dictionary<string, string> checkScopes = ReadCheckScopes(name, checks, entry.Contains("check_scopes") ? entry["check_scopes"] : null, errors);

        List<string> ownSteps = entry.Contains("imprint") && entry["imprint"] != null
            ? ReadStepNames(string.Format(CultureInfo.InvariantCulture, "languages['{0}'].imprint", name), entry["imprint"], errors)
            : new List<string>();

        List<LayoutRow> layoutRows = ReadLayout(name, extensions, entry.Contains("layout") ? entry["layout"] : null, errors);

        LanguageTestRunner tests = ReadTests(name, entry.Contains("tests") ? entry["tests"] : null, errors);

        bool executable = false;
        if (entry.Contains("executable") && entry["executable"] != null)
        {
            if (entry["executable"] is bool)
            {
                executable = (bool)entry["executable"];
            }
            else
            {
                errors.Add(string.Format(CultureInfo.InvariantCulture, "languages['{0}']: executable must be true or false", name));
            }
        }

        LanguageNaming naming = ReadNaming(name, extensions, entry.Contains("naming") ? entry["naming"] : null, errors);

        string tag = null;
        if (entry.Contains("tag") && entry["tag"] != null)
        {
            tag = Text(entry["tag"]).Trim();
            if (tag.Length == 0 || tag.Length > 12 || tag.Contains(" "))
            {
                errors.Add(string.Format(CultureInfo.InvariantCulture, "languages['{0}']: invalid tag '{1}' (one short word of at most 12 characters, as a diagram prints it)", name, tag));
            }
        }

        List<string> shapes = ReadShapes(name, entry.Contains("shapes") ? entry["shapes"] : null, errors);
        if (shapes.Count > 0 && tag == null)
        {
            errors.Add(string.Format(CultureInfo.InvariantCulture, "languages['{0}']: shapes need a tag, the word a diagram prints for the language", name));
        }

        if (errors.Count > before) { return null; }
        FileLanguage language = new FileLanguage(name, extensions.ToArray(), formatter, noFormatter, vscodeLanguage, adrFolder, checks.ToArray(), ownSteps.ToArray(), layoutRows.ToArray(), tests, executable, naming, checkScopes, tag, shapes.ToArray());
        foreach (string extension in extensions) { byExtension[extension] = language; }
        return language;
    }
}
