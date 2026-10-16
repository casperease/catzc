/*
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.Docs/types/AdrDoraCheck.cs
    folder: types
    name: adr-dora-check
    filetype: cs
    kind: type
    language: csharp
    track: automation
    tracktype: modules
    module: Catzc.Base.Docs
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    page: docs/references/automation/catzc-base-docs/types/AdrDoraCheck.cs.md
    cites:
      - ADR-AUTO-TYPES#8
      - ADR-PRIN-CONFIG#4
---
*/

using System.Collections;
using System.Collections.Generic;

namespace Catzc.Base.Docs;

public sealed class AdrDoraCheck
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    public const string DefaultFile = "dora-explains.md";

    private static readonly string[] AllowedKeys = { "mode", "file", "exempt", "exempt_folders" };

    public CheckMode mode { get; }
    public string file { get; }
    public IReadOnlyDictionary<string, string> exempt { get; }
    public IReadOnlyDictionary<string, string> exempt_folders { get; }

    // True when an ADR's path under docs/adr/ lies in an exempt folder.
    public bool IsExemptPath(string adrRelative)
    {
        if (string.IsNullOrEmpty(adrRelative)) { return false; }
        foreach (string folder in exempt_folders.Keys)
        {
            if (adrRelative.StartsWith(folder + "/", System.StringComparison.Ordinal)) { return true; }
        }
        return false;
    }

    internal AdrDoraCheck(IDictionary raw, string where, List<string> errors)
    {
        mode = default(CheckMode);
        file = DefaultFile;
        Dictionary<string, string> exemptMap = new Dictionary<string, string>(System.StringComparer.Ordinal);
        exempt = exemptMap;
        Dictionary<string, string> folderMap = new Dictionary<string, string>(System.StringComparer.Ordinal);
        exempt_folders = folderMap;
        if (raw == null) { return; }

        if (raw.Contains("exempt_folders") && raw["exempt_folders"] != null)
        {
            IDictionary folders = raw["exempt_folders"] as IDictionary;
            if (folders == null)
            {
                errors.Add(string.Format("{0}: exempt_folders must be a map of folder under docs/adr/ to reason", where));
            }
            else
            {
                foreach (DictionaryEntry entry in folders)
                {
                    string folder = entry.Key == null ? string.Empty : entry.Key.ToString();
                    string reason = entry.Value == null ? null : entry.Value.ToString();
                    if (folder.Length == 0 || folder.StartsWith("/", System.StringComparison.Ordinal) || folder.EndsWith("/", System.StringComparison.Ordinal)
                        || folder.IndexOf('\\') >= 0 || folder.IndexOf('/') < 0)
                    {
                        errors.Add(string.Format("{0}: exempt folder '{1}' must be a '/'-separated subfolder of a domain, e.g. azure/caf", where, folder));
                        continue;
                    }
                    if (string.IsNullOrWhiteSpace(reason))
                    {
                        errors.Add(string.Format("{0}: exempt folder '{1}' needs a reason", where, folder));
                        continue;
                    }
                    folderMap[folder] = reason.Trim();
                }
            }
        }

        AdrChecksConfig.CheckKeys(raw, AllowedKeys, where, errors);
        mode = AdrChecksConfig.ParseMode(raw, where, errors);

        if (raw.Contains("file") && raw["file"] != null)
        {
            string value = raw["file"].ToString();
            if (!value.EndsWith(".md", System.StringComparison.Ordinal) || value.IndexOfAny(new[] { '/', '\\' }) >= 0)
            {
                errors.Add(string.Format("{0}: file '{1}' must be a markdown file name, with no folder", where, value));
            }
            else
            {
                file = value;
            }
        }

        if (raw.Contains("exempt") && raw["exempt"] != null)
        {
            IDictionary map = raw["exempt"] as IDictionary;
            if (map == null)
            {
                errors.Add(string.Format("{0}: exempt must be a map of domain name to reason", where));
                return;
            }
            foreach (DictionaryEntry entry in map)
            {
                string domain = entry.Key == null ? string.Empty : entry.Key.ToString();
                string reason = entry.Value == null ? null : entry.Value.ToString();
                if (string.IsNullOrWhiteSpace(reason))
                {
                    errors.Add(string.Format("{0}: exempt domain '{1}' needs a reason", where, domain));
                    continue;
                }
                exemptMap[domain] = reason.Trim();
            }
        }
    }
}
