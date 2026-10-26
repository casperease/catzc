/*
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-languages/types/LanguageEntryReaders.cs.md"
  header: "generated"
---
*/

using System;
using System.Collections;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Text.RegularExpressions;
using static Catzc.Base.Languages.LanguagesConfig;

namespace Catzc.Base.Languages;

public static class LanguageEntryReaders
{
    private static readonly string[] AllowedNamingKeys = { "folder", "file", "function", "type", "exempt" };
    private static readonly string[] AllowedTestsKeys = { "runner", "tools", "executable_parameter", "engine", "pattern" };
    // A test-file pattern is one file glob, matched against file names under a test folder, never a path.
    private static readonly Regex TestPattern = new Regex("^[A-Za-z0-9_*.-]+$");
    private static readonly Regex CommandName = new Regex("^[A-Z][a-z]+-[A-Z][A-Za-z0-9]*$");
    private static readonly Regex ParameterName = new Regex("^[A-Z][A-Za-z0-9]*$");
    private static readonly string[] AllowedLayoutKeys = { "folder", "role", "extensions", "live", "shipped" };
    private static readonly Regex LayoutFolder = new Regex("^(\\.|[a-z][a-z0-9]*(-[a-z0-9]+)*)$");
    private static readonly Regex LayoutRole = new Regex("^[a-z][a-z0-9]*(-[a-z0-9]+)*$");
    private static readonly Regex CheckName = new Regex("^Test-[A-Z][A-Za-z0-9]*$");
    private static readonly Regex ScopeAddress = new Regex("^global(\\.[A-Za-z0-9_-]+){2,}$");
    private static readonly Regex Extension = new Regex("^(\\.[a-z0-9]+)+$");

    internal static LanguageNaming ReadNaming(string name, List<string> languageExtensions, object value, List<string> errors)
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

    internal static List<string> ReadCases(string where, object value, List<string> errors)
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

    internal static List<LayoutRow> ReadLayout(string name, List<string> languageExtensions, object value, List<string> errors)
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

    internal static bool ReadFlag(string name, IDictionary row, string key, List<string> errors)
    {
        if (!row.Contains(key) || row[key] == null) { return true; }
        if (row[key] is bool) { return (bool)row[key]; }
        errors.Add(string.Format(CultureInfo.InvariantCulture, "languages['{0}'].layout: {1} must be true or false", name, key));
        return true;
    }

    internal static LanguageTestRunner ReadTests(string name, object value, List<string> errors)
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

    // The ordered regular expressions a diagram label is matched against (whole label) to name this language's snippets.
    internal static List<string> ReadShapes(string name, object value, List<string> errors)
    {
        List<string> shapes = new List<string>();
        if (value == null) { return shapes; }
        IList list = value as IList;
        if (list == null)
        {
            errors.Add(string.Format(CultureInfo.InvariantCulture, "languages['{0}']: shapes must be a list of regular expressions", name));
            return shapes;
        }
        foreach (object item in list)
        {
            string pattern = Text(item);
            try
            {
                new System.Text.RegularExpressions.Regex(pattern);
                shapes.Add(pattern);
            }
            catch (ArgumentException)
            {
                errors.Add(string.Format(CultureInfo.InvariantCulture, "languages['{0}']: shapes entry '{1}' is not a valid regular expression", name, pattern));
            }
        }
        return shapes;
    }

    internal static List<string> ReadChecks(string name, object value, List<string> errors)
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

    internal static Dictionary<string, string> ReadCheckScopes(string name, List<string> checks, object value, List<string> errors)
    {
        Dictionary<string, string> scopes = new Dictionary<string, string>();
        if (value == null) { return scopes; }
        IDictionary map = value as IDictionary;
        if (map == null)
        {
            errors.Add(string.Format(CultureInfo.InvariantCulture, "languages['{0}']: check_scopes must be a map of check name to config address (e.g. Test-Plans: global.plans.folder)", name));
            return scopes;
        }
        foreach (DictionaryEntry pair in map)
        {
            string check = Text(pair.Key);
            string address = Text(pair.Value);
            if (!checks.Contains(check))
            {
                errors.Add(string.Format(CultureInfo.InvariantCulture, "languages['{0}']: check_scopes names '{1}', which is not one of the language's checks", name, check));
            }
            else if (!ScopeAddress.IsMatch(address))
            {
                errors.Add(string.Format(CultureInfo.InvariantCulture, "languages['{0}']: invalid check_scopes address '{1}' for '{2}' (a global config address to a folder, e.g. global.plans.folder)", name, address, check));
            }
            else
            {
                scopes[check] = address;
            }
        }
        return scopes;
    }

    internal static List<string> ReadExtensions(string name, object value, Dictionary<string, string> claimedBy, List<string> errors)
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
