using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text.RegularExpressions;

namespace Catzc.Base.Contracts;

// How a contract group folder is named, and nothing else: contracts are addressed by root, version, group and file
// (ContractLayout), never by a mode set here. A group is the module's track and its folder in the normal form
// (pwsh.base.vs_code for Catzc.Base.VSCode); an exception names one module's group outright, for the rare module the
// rule names wrongly.
public sealed class ContractsConfig
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    // The one group form: the track, a dot, and the module's folder in the normal form.
    public const string TrackModuleForm = "track_module";

    private const string Failed = "contracts configuration validation failed:\n";
    private static readonly string[] AllowedKeys = { "groups" };
    private static readonly string[] GroupKeys = { "form", "exceptions" };
    private static readonly Regex GroupPattern = new Regex(@"^[a-z][a-z0-9_-]*(\.[a-z][a-z0-9_]*)+$", RegexOptions.Compiled);

    public string form { get; } = TrackModuleForm;

    // Module full name -> group, only where the form names a module's group wrongly.
    public IReadOnlyDictionary<string, string> exceptions { get; } = new Dictionary<string, string>(StringComparer.Ordinal);

    public ContractsConfig(IDictionary raw)
    {
        var errors = new List<string>();
        if (raw == null) { raw = new Hashtable(); }
        foreach (object key in raw.Keys)
        {
            if (Array.IndexOf(AllowedKeys, key?.ToString()) < 0)
            {
                errors.Add($"unknown key '{key}' (allowed: {string.Join(", ", AllowedKeys)})");
            }
        }
        if (raw.Contains("groups") && raw["groups"] != null)
        {
            if (raw["groups"] is not IDictionary groups)
            {
                errors.Add("groups is a mapping of form and exceptions");
            }
            else
            {
                foreach (object key in groups.Keys)
                {
                    if (Array.IndexOf(GroupKeys, key?.ToString()) < 0)
                    {
                        errors.Add($"groups: unknown key '{key}' (allowed: {string.Join(", ", GroupKeys)})");
                    }
                }
                if (groups.Contains("form") && groups["form"] != null)
                {
                    form = groups["form"].ToString();
                    if (!string.Equals(form, TrackModuleForm, StringComparison.Ordinal))
                    {
                        errors.Add($"groups.form '{form}' is not a group form (the one form is {TrackModuleForm})");
                    }
                }
                if (groups.Contains("exceptions") && groups["exceptions"] != null)
                {
                    if (groups["exceptions"] is not IDictionary entries)
                    {
                        errors.Add("groups.exceptions is a mapping of module full name to group");
                    }
                    else
                    {
                        var map = new Dictionary<string, string>(StringComparer.Ordinal);
                        foreach (DictionaryEntry entry in entries)
                        {
                            string module = entry.Key?.ToString();
                            string group = entry.Value?.ToString();
                            if (string.IsNullOrEmpty(group) || !GroupPattern.IsMatch(group))
                            {
                                errors.Add($"groups.exceptions: '{module}' names '{group}', which is no group (<track>.<module in the normal form>)");
                                continue;
                            }
                            if (map.ContainsValue(group))
                            {
                                errors.Add($"groups.exceptions: the group '{group}' is named for two modules; one group holds one module's contracts");
                                continue;
                            }
                            map[module] = group;
                        }
                        exceptions = map;
                    }
                }
            }
        }
        if (errors.Count > 0)
        {
            throw new ArgumentException(Failed + string.Join("\n", errors));
        }
    }

    // The group of a module: its exception, else the track and the module's folder in the normal form.
    public string GroupOf(string moduleFullName, string track, string folderInNormalForm) =>
        exceptions.TryGetValue(moduleFullName, out string group) ? group : track + "." + folderInNormalForm;

    // The module an exception names for a group, or null when the group follows the form.
    public string ExceptionModuleOf(string group) =>
        exceptions.Where(pair => string.Equals(pair.Value, group, StringComparison.Ordinal)).Select(pair => pair.Key).FirstOrDefault();
}
