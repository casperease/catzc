/*
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-quality-gates/types/EditRemindersConfig.cs.md"
  header: "generated"
---
*/

using System;
using System.Collections;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.Text.Json;
using System.Text.RegularExpressions;

namespace Catzc.Base.QualityGates;

public sealed class EditRemindersConfig
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    // Where the config sits under the modules folder, so the hook finds it without a PowerShell session.
    public const string ConfigModulePath = "Base.QualityGates/configs/edit-reminders.yml";

    private const string Failed = "edit-reminders configuration validation failed:\n";
    private static readonly string[] AllowedKeys = { "reminders" };
    private static readonly string[] EntryKeys = { "paths", "say" };

    // Each entry: the path patterns (`*` within a folder, `**` across folders) and the reminder said after an edit of a matching file.
    public IReadOnlyList<EditReminder> reminders { get; } = Array.Empty<EditReminder>();

    public EditRemindersConfig(IDictionary raw)
    {
        List<string> errors = new List<string>();
        if (raw == null) { raw = new Hashtable(); }
        foreach (object k in raw.Keys)
        {
            string key = k == null ? null : k.ToString();
            if (Array.IndexOf(AllowedKeys, key) < 0)
            {
                errors.Add(string.Format(CultureInfo.InvariantCulture, "unknown top-level key '{0}' (allowed: {1})", key, string.Join(", ", AllowedKeys)));
            }
        }
        if (raw.Contains("reminders") && raw["reminders"] != null)
        {
            List<EditReminder> entries = new List<EditReminder>();
            if (!(raw["reminders"] is IList list) || raw["reminders"] is string)
            {
                errors.Add("reminders must be a list of { paths, say } entries");
            }
            else
            {
                int index = 0;
                foreach (object item in list)
                {
                    string name = string.Format(CultureInfo.InvariantCulture, "reminders[{0}]", index);
                    index++;
                    if (!(item is IDictionary entry))
                    {
                        errors.Add(name + " must be a map of paths and say");
                        continue;
                    }
                    foreach (object k in entry.Keys)
                    {
                        if (Array.IndexOf(EntryKeys, k == null ? null : k.ToString()) < 0)
                        {
                            errors.Add(string.Format(CultureInfo.InvariantCulture, "{0}: unknown key '{1}' (allowed: {2})", name, k, string.Join(", ", EntryKeys)));
                        }
                    }
                    List<string> paths = new List<string>();
                    if (entry["paths"] is IList pathList && !(entry["paths"] is string))
                    {
                        foreach (object p in pathList)
                        {
                            string pattern = p == null ? null : p.ToString();
                            if (string.IsNullOrWhiteSpace(pattern) || pattern.IndexOf('\\') >= 0 || pattern.StartsWith("/", StringComparison.Ordinal))
                            {
                                errors.Add(string.Format(CultureInfo.InvariantCulture, "{0}: path '{1}' must be a repository-relative, '/'-separated pattern", name, pattern));
                            }
                            else { paths.Add(pattern); }
                        }
                    }
                    if (paths.Count == 0) { errors.Add(name + ": paths must name at least one pattern"); }
                    string say = entry["say"] == null ? null : entry["say"].ToString().Trim();
                    if (string.IsNullOrEmpty(say)) { errors.Add(name + ": say is required"); }
                    if (paths.Count > 0 && !string.IsNullOrEmpty(say)) { entries.Add(new EditReminder(paths, say)); }
                }
            }
            reminders = entries;
        }
        if (errors.Count > 0) { throw new ArgumentException(Failed + string.Join("\n", errors)); }
    }

    // The reminders owed by an edit of a repository-relative file, in the config's order; empty when none matches.
    public IReadOnlyList<string> For(string repoRelativePath)
    {
        List<string> said = new List<string>();
        if (string.IsNullOrEmpty(repoRelativePath)) { return said; }
        string path = repoRelativePath.Replace('\\', '/');
        foreach (EditReminder reminder in reminders)
        {
            if (reminder.Matches(path)) { said.Add(reminder.say); }
        }
        return said;
    }

    // The PostToolUse hook output that hands the reminders to the session as context, or null when there is nothing to say.
    public static string HookOutput(IReadOnlyList<string> said)
    {
        if (said == null || said.Count == 0) { return null; }
        using (MemoryStream buffer = new MemoryStream())
        {
            using (Utf8JsonWriter writer = new Utf8JsonWriter(buffer))
            {
                writer.WriteStartObject();
                writer.WriteStartObject("hookSpecificOutput");
                writer.WriteString("hookEventName", "PostToolUse");
                writer.WriteString("additionalContext", string.Join("\n", said));
                writer.WriteEndObject();
                writer.WriteEndObject();
            }
            return System.Text.Encoding.UTF8.GetString(buffer.ToArray());
        }
    }

    // The config file under the one top-level folder of the repository that holds it.
    public static string FindConfig(string repositoryRoot)
    {
        if (string.IsNullOrEmpty(repositoryRoot)) { throw new ArgumentNullException("repositoryRoot"); }
        foreach (string folder in Directory.GetDirectories(repositoryRoot))
        {
            string candidate = Path.Combine(folder, ConfigModulePath);
            if (File.Exists(candidate)) { return candidate; }
        }
        return null;
    }
}

public sealed class EditReminder
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    readonly Regex[] matchers;

    public IReadOnlyList<string> paths { get; }
    public string say { get; }

    public EditReminder(IReadOnlyList<string> paths, string say)
    {
        this.paths = paths;
        this.say = say;
        matchers = new Regex[paths.Count];
        for (int i = 0; i < paths.Count; i++) { matchers[i] = new Regex(ToRegex(paths[i]), RegexOptions.CultureInvariant); }
    }

    public bool Matches(string repoRelativePath)
    {
        foreach (Regex matcher in matchers)
        {
            if (matcher.IsMatch(repoRelativePath)) { return true; }
        }
        return false;
    }

    // `**` spans folders, `*` stays within one, everything else is literal.
    static string ToRegex(string pattern)
    {
        string escaped = Regex.Escape(pattern).Replace(@"\*\*", "\u0001").Replace(@"\*", "[^/]*").Replace("\u0001", ".*");
        return "^" + escaped + "$";
    }
}
