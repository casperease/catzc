/*
---
catzc:
  immutable:
    with_body_sha: c397c563d19d
  edges:
    test: pwsh/Catzc.Base.Languages/tests/types/LanguagesConfig.Tests.ps1
    docs: "[LanguagesConfig.cs.md](docs/references/pwsh/catzc-base-languages/types/LanguagesConfig.cs.md)"
    cites:
      - ADR-AUTO-DEFAULT-ONERESOLUTIONORDER
      - ADR-AUTO-IDIOM-LANGUAGEIDIOM
      - ADR-AUTO-IDIOM-NORMALFORM
      - ADR-AUTO-MODULE-EXISTSBYLAYOUT
      - ADR-BCL-TYPES-SNAKECASEMIRRORSYAML
      - ADR-REPO-FORMAT-CONFIGUREDFORMATTERS
      - DDR-TRACK-FILELANGUAGE
      - PDR-CONFIG-VARYINGBEHAVIOURISCONFIG
      - PDR-CONFIG-NEWINSTANCEISCONFIGCHANGE
      - PDR-CONFIG-EXCEPTIONISCONFIGENTRY
---
*/

using System;
using System.Collections;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Text.RegularExpressions;

namespace Catzc.Base.Languages;

// Rests on [ADR-AUTO-MODULE-EXISTSBYLAYOUT](/docs/adr/automation/module-model.md#rule-adr-auto-module-existsbylayout).
public sealed class LanguagesConfig : Catzc.Base.Objects.DictionaryRecord
{
    private const string Failed = "languages config validation failed:\n";
    private static readonly string[] AllowedKeys = { "formatters", "imprint", "steps", "naming", "languages" };
    private static readonly string[] AllowedEntryKeys = { "extensions", "formatter", "no_formatter", "vscode_language", "adr_folder", "checks", "imprint", "layout", "tests", "executable", "naming" };
    private static readonly string[] AllowedNamingKeys = { "folder", "file", "function", "type", "exempt" };
    private static readonly string[] AllowedGlobalNamingKeys = { "exempt_folders", "normal_form" };
    // The repository normal form when the file names none; rests on [ADR-AUTO-IDIOM-NORMALFORM](/docs/adr/automation/idiomatic-names.md#rule-adr-auto-idiom-normalform).
    private const string DefaultNormalForm = "snake";
    // A normal form renders every other case from its words, so it is a case whose split and join lose nothing.
    private static readonly string[] NormalFormCases = { "snake", "kebab", "pascal" };
    private static readonly Regex FolderName = new Regex("^\\.?[A-Za-z0-9_-]+(\\.[A-Za-z0-9_-]+)*$");
    private static readonly string[] AllowedTestsKeys = { "runner", "tools", "executable_parameter", "engine", "pattern" };
    // A test-file pattern is one file glob, matched against file names under a test folder, never a path.
    private static readonly Regex TestPattern = new Regex("^[A-Za-z0-9_*.-]+$");
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
    private static readonly Regex Extension = new Regex("^(\\.[a-z0-9]+)+$");
    private static readonly Regex AdrFolder = new Regex("^[A-Za-z0-9_-][A-Za-z0-9._-]*(/[A-Za-z0-9_-][A-Za-z0-9._-]*)*$");
    private static readonly Regex VscodeLanguage = new Regex("^[a-z][a-z0-9-]*$");
    private static readonly Regex VscodeExtension = new Regex("^[A-Za-z0-9][A-Za-z0-9-]*\\.[A-Za-z0-9][A-Za-z0-9-]*$");

    private readonly Dictionary<string, FileLanguage> byExtension = new Dictionary<string, FileLanguage>(StringComparer.Ordinal);
    private readonly Dictionary<string, string> claimedBy = new Dictionary<string, string>(StringComparer.Ordinal);

    private static readonly string[] Engines = { "prettier", "gofmt", "ruff", "psscriptanalyzer", "dotnet-format", "bicep" };
    public static IReadOnlyList<string> FormatterEngines => Engines;

    // A new imprint step is new mechanism too: its Format-Code adapter and its name here must land together.
    private static readonly string[] StepNames = { "file-meta", "bcl-namespace", "comments", "ps-help" };
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

    // One finding per file name and per folder that breaks its language's naming, each folder once per language, in path order; rests on [ADR-AUTO-IDIOM-LANGUAGEIDIOM](/docs/adr/automation/idiomatic-names.md#rule-adr-auto-idiom-languageidiom).
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

    private static List<string> ReadGlobalNaming(object value, List<string> errors, ref string normalForm)
    {
        List<string> folders = new List<string>();
        IDictionary map = value as IDictionary;
        if (map == null)
        {
            errors.Add("naming must be a mapping { exempt_folders, normal_form }");
            return folders;
        }
        foreach (object k in map.Keys)
        {
            if (Array.IndexOf(AllowedGlobalNamingKeys, Text(k)) < 0)
            {
                errors.Add(string.Format(CultureInfo.InvariantCulture, "naming: unknown key '{0}' (allowed: {1})", Text(k), string.Join(", ", AllowedGlobalNamingKeys)));
            }
        }
        if (map.Contains("normal_form") && map["normal_form"] != null)
        {
            string form = Text(map["normal_form"]);
            if (Array.IndexOf(NormalFormCases, form) < 0)
            {
                errors.Add(string.Format(CultureInfo.InvariantCulture, "naming: normal_form '{0}' is not a case every name renders from (one of: {1})", form, string.Join(", ", NormalFormCases)));
            }
            else
            {
                normalForm = form;
            }
        }
        if (!map.Contains("exempt_folders") || map["exempt_folders"] == null) { return folders; }
        IList list = map["exempt_folders"] as IList;
        if (list == null)
        {
            errors.Add("naming: exempt_folders must be a list of folder names (e.g. [assets])");
            return folders;
        }
        foreach (object item in list)
        {
            string folder = Text(item);
            if (!FolderName.IsMatch(folder))
            {
                errors.Add(string.Format(CultureInfo.InvariantCulture, "naming: invalid exempt folder '{0}' (one folder name, never a path)", folder));
            }
            else if (folders.Contains(folder))
            {
                errors.Add(string.Format(CultureInfo.InvariantCulture, "naming: duplicate exempt folder '{0}'", folder));
            }
            else
            {
                folders.Add(folder);
            }
        }
        return folders;
    }

    private static LanguageNaming ReadNaming(string name, List<string> languageExtensions, object value, List<string> errors)
    {
        if (value == null) { return null; }
        string where = string.Format(CultureInfo.InvariantCulture, "languages['{0}'].naming", name);
        IDictionary map = value as IDictionary;
        if (map == null)
        {
            errors.Add(where + ": must be a mapping { folder, file, function, type, exempt }");
            return null;
        }
        int before = errors.Count;
        foreach (object k in map.Keys)
        {
            if (Array.IndexOf(AllowedNamingKeys, Text(k)) < 0)
            {
                errors.Add(string.Format(CultureInfo.InvariantCulture, "{0}: unknown key '{1}' (allowed: {2})", where, Text(k), string.Join(", ", AllowedNamingKeys)));
            }
        }
        List<string> folder = ReadCases(where + ".folder", map.Contains("folder") ? map["folder"] : null, errors);
        List<string> file = ReadCases(where + ".file", map.Contains("file") ? map["file"] : null, errors);
        List<string> function = ReadCases(where + ".function", map.Contains("function") ? map["function"] : null, errors);
        List<string> type = ReadCases(where + ".type", map.Contains("type") ? map["type"] : null, errors);
        if (folder.Count == 0 && file.Count == 0 && function.Count == 0 && type.Count == 0)
        {
            errors.Add(where + ": names the cases of its folders, its files, its functions or its types");
        }
        List<string> exempt = new List<string>();
        if (map.Contains("exempt") && map["exempt"] != null)
        {
            IList list = map["exempt"] as IList;
            if (list == null)
            {
                errors.Add(where + ": exempt must be a list of repository-relative files");
            }
            else
            {
                foreach (object item in list)
                {
                    string path = Text(item);
                    bool dotSegment = Array.Exists(path.Split('/'), s => s == "." || s == "..");
                    if (!SettingsPath.IsMatch(path) || path.Contains('#') || dotSegment || !languageExtensions.Contains(ExtensionOf(path) ?? ""))
                    {
                        errors.Add(string.Format(CultureInfo.InvariantCulture, "{0}: invalid exempt file '{1}' (a '/'-separated repository-relative file of the language)", where, path));
                    }
                    else
                    {
                        exempt.Add(path);
                    }
                }
            }
        }
        if (errors.Count > before) { return null; }
        return new LanguageNaming(folder.ToArray(), file.ToArray(), exempt.ToArray(), function.ToArray(), type.ToArray());
    }

    private static List<string> ReadCases(string where, object value, List<string> errors)
    {
        List<string> cases = new List<string>();
        if (value == null) { return cases; }
        IList list = value as IList;
        if (list == null) { list = new object[] { value }; }
        foreach (object item in list)
        {
            string name = Text(item);
            if (!Catzc.Base.Objects.NameCase.IsCase(name))
            {
                errors.Add(string.Format(CultureInfo.InvariantCulture, "{0}: unknown case '{1}' (one of: {2})", where, name, string.Join(", ", Catzc.Base.Objects.NameCase.Cases)));
            }
            else if (cases.Contains(name))
            {
                errors.Add(string.Format(CultureInfo.InvariantCulture, "{0}: duplicate case '{1}'", where, name));
            }
            else
            {
                cases.Add(name);
            }
        }
        return cases;
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

        if (errors.Count > before) { return null; }
        FileLanguage language = new FileLanguage(name, extensions.ToArray(), formatter, noFormatter, vscodeLanguage, adrFolder, checks.ToArray(), ownSteps.ToArray(), layoutRows.ToArray(), tests, executable, naming);
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
            errors.Add(where + ": must be a map of runner, pattern, tools, executable_parameter and engine");
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
        string executableParameter = map.Contains("executable_parameter") ? Text(map["executable_parameter"]) : "";
        if (!ParameterName.IsMatch(executableParameter))
        {
            errors.Add(string.Format(CultureInfo.InvariantCulture, "{0}: executable_parameter '{1}' is not a parameter name (e.g. GoExecutable)", where, executableParameter));
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
        string pattern = map.Contains("pattern") ? Text(map["pattern"]) : "";
        if (!TestPattern.IsMatch(pattern) || !pattern.Contains('*'))
        {
            errors.Add(string.Format(CultureInfo.InvariantCulture, "{0}: pattern '{1}' is not a test-file glob (one file name pattern with a '*', e.g. test_*.py)", where, pattern));
        }
        if (errors.Count > before) { return null; }
        return new LanguageTestRunner(runner, tools.ToArray(), executableParameter, engine, pattern);
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
                errors.Add(string.Format(CultureInfo.InvariantCulture, "languages['{0}']: invalid extension '{1}' (one or more parts, each a dot, then lowercase letters and digits)", name, extension));
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
