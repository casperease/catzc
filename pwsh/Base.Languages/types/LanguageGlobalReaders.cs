using System;
using System.Collections;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Text.RegularExpressions;
using static Catzc.Base.Languages.LanguagesConfig;

namespace Catzc.Base.Languages;

public static class LanguageGlobalReaders
{
    private static readonly string[] AllowedGlobalNamingKeys = { "exempt_folders", "normal_form" };
    // A normal form renders every other case from its words, so it is a case whose split and join lose nothing.
    private static readonly string[] NormalFormCases = { "snake", "kebab", "pascal" };
    private static readonly Regex FolderName = new Regex("^\\.?[A-Za-z0-9_-]+(\\.[A-Za-z0-9_-]+)*$");
    private static readonly string[] AllowedStepKeys = { "settings" };
    private static readonly string[] AllowedEngineKeys = { "vscode_extension", "settings" };
    private static readonly Regex VscodeExtension = new Regex("^[A-Za-z0-9][A-Za-z0-9-]*\\.[A-Za-z0-9][A-Za-z0-9-]*$");

    internal static List<string> ReadGlobalNaming(object value, List<string> errors, ref string normalForm)
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

    // A list of known step names, each once.
    internal static List<string> ReadStepNames(string where, object value, List<string> errors)
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

    internal static void ReadSteps(object value, Dictionary<string, ImprintStep> stepMap, List<string> errors)
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

    internal static void ReadEngines(object value, Dictionary<string, FormatterEngine> engineMap, List<string> errors)
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
            if (Array.IndexOf(LanguagesConfig.Engines, name) < 0)
            {
                errors.Add(string.Format(CultureInfo.InvariantCulture, "formatters: unknown formatter engine '{0}' (one of: {1})", name, string.Join(", ", LanguagesConfig.Engines)));
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
}
