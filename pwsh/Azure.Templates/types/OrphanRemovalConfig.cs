// What Remove-BicepOrphanResources leaves alone in a resource group's listing; every default is declared once here ([ADR-AUTO-DEFAULT-ONERESOLUTIONORDER](/docs/drs/automation/sensible-defaults.md#rule-adr-auto-default-oneresolutionorder)).
using System;
using System.Collections;
using System.Collections.Generic;
using System.Globalization;

namespace Catzc.Azure.Templates;

public sealed class OrphanRemovalConfig : Catzc.Base.Objects.DictionaryRecord
{
    private const string Failed = "orphan-removal configuration validation failed:\n";
    private static readonly string[] AllowedKeys = { "azure_created" };

    public IReadOnlyList<string> azure_created { get; } = new[]
    {
        "Microsoft.Sql/servers/databases/master",                               // every SQL server's system database
    };

    public OrphanRemovalConfig(IDictionary raw)
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
        if (raw.Contains("azure_created")) { azure_created = Entries(raw["azure_created"], errors) ?? azure_created; }
        if (errors.Count > 0) { throw new ArgumentException(Failed + string.Join("\n", errors)); }
    }

    // Whether a listed resource is one Azure created: its type and the last segment of its name match an entry, without regard to case.
    public bool IsAzureCreated(string type, string name)
    {
        if (string.IsNullOrEmpty(type) || string.IsNullOrEmpty(name)) { return false; }
        string last = name.Substring(name.LastIndexOf('/') + 1);
        string key = type + "/" + last;
        foreach (string entry in azure_created)
        {
            if (string.Equals(entry, key, StringComparison.OrdinalIgnoreCase)) { return true; }
        }
        return false;
    }

    // A list of '<namespace>/<type>/…/<name>' entries: a type of at least one child segment, then a name.
    private static IReadOnlyList<string> Entries(object raw, List<string> errors)
    {
        if (!(raw is IEnumerable list) || raw is string || raw is IDictionary)
        {
            errors.Add("azure_created must be a list of '<resource type>/<name>' entries");
            return null;
        }
        var entries = new List<string>();
        int index = 0;
        foreach (object item in list)
        {
            string entry = item == null ? string.Empty : item.ToString();
            string[] segments = entry.Split('/');
            if (segments.Length < 4 || Array.Exists(segments, string.IsNullOrWhiteSpace) || segments[0].IndexOf('.') < 0)
            {
                errors.Add(string.Format(CultureInfo.InvariantCulture, "azure_created[{0}]: '{1}' must be a child resource type and a name, such as Microsoft.Sql/servers/databases/master", index, entry));
            }
            else { entries.Add(entry); }
            index++;
        }
        return entries.ToArray();
    }
}
