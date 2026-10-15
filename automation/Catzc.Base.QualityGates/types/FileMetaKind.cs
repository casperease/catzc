/*
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/types/FileMetaKind.cs
    kind: csharp-type
    module: Catzc.Base.QualityGates
    adrs:
      - ADR-AUTO-DEFAULT#6
      - ADR-REPO-FILEMETA#2
      - ADR-REPO-FILEMETA#4
---
*/

// One entry of the meta-kind registry; the defaults of an omitted key are declared here, once.
// [comment:1](/docs/references/automation/catzc-base-qualitygates/types/FileMetaKind.cs.md#comment1)

using System;
using System.Collections;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Text.RegularExpressions;

namespace Catzc.Base.QualityGates;

[Catzc.Base.Objects.ConsoleDisplay("id", "direction", "keys", "target")]
public sealed class FileMetaKind
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    public const FileMetaDirection DefaultDirection = FileMetaDirection.Imprint;
    public const string DefaultFiles = "**/*";

    static readonly Regex IdPattern = new Regex("^[a-z][a-z0-9]*(-[a-z0-9]+)*$", RegexOptions.Compiled);
    static readonly Regex KeyPattern = new Regex("^[a-z][a-z0-9_]*$", RegexOptions.Compiled);
    static readonly string[] Allowed = { "direction", "files", "keys", "processor", "target", "settings" };

    public string id { get; }
    public FileMetaDirection direction { get; }
    public IReadOnlyList<string> files { get; }
    public IReadOnlyList<string> keys { get; }
    public string processor { get; }
    public string target { get; }
    public IReadOnlyDictionary<string, object> settings { get; }

    public FileMetaKind(string id, IDictionary raw)
    {
        if (id == null || !IdPattern.IsMatch(id))
        {
            throw new ArgumentException(string.Format(CultureInfo.InvariantCulture,
                "file-meta config: kind id '{0}' must be lowercase words joined by '-'", id));
        }
        this.id = id;
        string where = "file-meta config: kind '" + id + "'";
        direction = DefaultDirection;
        var fileList = new List<string> { DefaultFiles };
        var keyList = new List<string> { id.Replace('-', '_') };
        string explicitProcessor = null;
        string targetConfig = null;
        var settingMap = new Dictionary<string, object>(StringComparer.Ordinal);

        if (raw != null)
        {
            foreach (object key in raw.Keys)
            {
                string name = Convert.ToString(key, CultureInfo.InvariantCulture);
                if (!Allowed.Contains(name))
                {
                    throw new ArgumentException(string.Format(CultureInfo.InvariantCulture,
                        "{0}: unknown key '{1}' (allowed: {2})", where, name, string.Join(", ", Allowed)));
                }
            }
            if (Has(raw, "direction"))
            {
                string value = Convert.ToString(raw["direction"], CultureInfo.InvariantCulture);
                if (!Enum.TryParse(value, true, out FileMetaDirection parsed) || int.TryParse(value, out _))
                {
                    throw new ArgumentException(string.Format(CultureInfo.InvariantCulture,
                        "{0}: direction '{1}' is not one of: {2}", where, value, string.Join(", ", Enum.GetNames(typeof(FileMetaDirection))).ToLowerInvariant()));
                }
                direction = parsed;
            }
            if (Has(raw, "files")) { fileList = Strings(where, "files", raw["files"], null); }
            if (Has(raw, "keys")) { keyList = Strings(where, "keys", raw["keys"], KeyPattern); }
            if (Has(raw, "processor")) { explicitProcessor = Convert.ToString(raw["processor"], CultureInfo.InvariantCulture); }
            if (Has(raw, "target")) { targetConfig = Convert.ToString(raw["target"], CultureInfo.InvariantCulture); }
            if (Has(raw, "settings"))
            {
                if (!(raw["settings"] is IDictionary map))
                {
                    throw new ArgumentException(where + ": settings must be a map");
                }
                foreach (DictionaryEntry entry in map) { settingMap[Convert.ToString(entry.Key, CultureInfo.InvariantCulture)] = entry.Value; }
            }
        }

        if (direction == FileMetaDirection.Gather && string.IsNullOrWhiteSpace(targetConfig))
        {
            throw new ArgumentException(where + ": a gather kind names the config it feeds in 'target'");
        }
        if (direction == FileMetaDirection.Imprint && targetConfig != null)
        {
            throw new ArgumentException(where + ": only a gather kind has a 'target'");
        }
        if (explicitProcessor != null && string.IsNullOrWhiteSpace(explicitProcessor))
        {
            throw new ArgumentException(where + ": processor is empty; omit it to take the function the kind's id names");
        }

        files = fileList;
        keys = keyList;
        target = targetConfig;
        settings = settingMap;
        processor = explicitProcessor ?? ConventionName(id, direction);
    }

    // The function a module subscribes by default: Get-<Id>FileMetaFact, or Get-<Id>MarkdownConfigContribution.
    // [comment:2](/docs/references/automation/catzc-base-qualitygates/types/FileMetaKind.cs.md#comment2)
    public static string ConventionName(string id, FileMetaDirection direction)
    {
        string words = string.Concat(id.Split('-').Select(word => char.ToUpperInvariant(word[0]) + word.Substring(1)));
        return direction == FileMetaDirection.Imprint ? "Get-" + words + "FileMetaFact" : "Get-" + words + "MarkdownConfigContribution";
    }

    static bool Has(IDictionary raw, string key) => raw.Contains(key) && raw[key] != null;

    static List<string> Strings(string where, string name, object value, Regex pattern)
    {
        var items = new List<string>();
        if (value is string single) { items.Add(single); }
        else if (value is IEnumerable list) { foreach (object item in list) { items.Add(Convert.ToString(item, CultureInfo.InvariantCulture)); } }
        else { throw new ArgumentException(where + ": " + name + " must be a list of strings"); }
        if (items.Count == 0) { throw new ArgumentException(where + ": " + name + " must not be empty"); }
        foreach (string item in items)
        {
            if (string.IsNullOrWhiteSpace(item) || (pattern != null && !pattern.IsMatch(item)))
            {
                throw new ArgumentException(string.Format(CultureInfo.InvariantCulture, "{0}: {1} entry '{2}' is not valid", where, name, item));
            }
        }
        if (items.Distinct(StringComparer.Ordinal).Count() != items.Count)
        {
            throw new ArgumentException(where + ": " + name + " lists an entry twice");
        }
        return items;
    }
}
