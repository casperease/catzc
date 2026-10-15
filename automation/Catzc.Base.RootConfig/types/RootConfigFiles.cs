/*
---
catzc:
  derived:
    path: automation/Catzc.Base.RootConfig/types/RootConfigFiles.cs
    kind: type
    module: Catzc.Base.RootConfig
    adrs:
      - ADR-CONF-LOADING
      - ADR-REPO-ROOTCFG
---
*/

// Every malformed entry is collected into one error, so a bad registry reports all its faults at once.
// [ADR-CONF-LOADING](/docs/adr/configuration/module-config-loading.md), [ADR-REPO-ROOTCFG](/docs/adr/repository/generated-root-configs.md)
// [comment:1](/docs/references/automation/catzc-base-rootconfig/types/RootConfigFiles.cs.md#comment1)

using System;
using System.Collections;
using System.Collections.Generic;

namespace Catzc.Base.RootConfig;

public sealed class RootConfigFiles
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    // Managed root-file entries, in registry order.
    public IReadOnlyList<RootConfigFile> files { get; }

    private static readonly string[] AllowedKeys = { "files" };

    public RootConfigFiles(IDictionary raw)
    {
        List<string> errors = new List<string>();
        if (raw != null)
        {
            foreach (object key in raw.Keys)
            {
                string topKey = key == null ? string.Empty : key.ToString();
                if (Array.IndexOf(AllowedKeys, topKey) < 0)
                {
                    errors.Add(string.Format("unknown top-level key '{0}' (allowed: {1})", topKey, string.Join(", ", AllowedKeys)));
                }
            }
        }
        List<RootConfigFile> list = new List<RootConfigFile>();
        HashSet<string> seen = new HashSet<string>(StringComparer.OrdinalIgnoreCase);

        object obj = (raw != null && raw.Contains("files")) ? raw["files"] : null;
        IEnumerable seq = obj as IEnumerable;
        if (seq == null || obj is string)
        {
            errors.Add("'files' must be a list with at least one entry");
        }
        else
        {
            foreach (object item in seq)
            {
                IDictionary entry = item as IDictionary;
                if (entry == null) { errors.Add("each 'files' entry must be a mapping"); continue; }

                RootConfigFile f;
                try { f = new RootConfigFile(entry); }
                catch (ArgumentException ex) { errors.Add(ex.Message); continue; }

                if (!seen.Add(f.target)) { errors.Add(string.Format("duplicate target '{0}'", f.target)); continue; }
                list.Add(f);
            }
            if (errors.Count == 0 && list.Count == 0)
            {
                errors.Add("'files' must be a list with at least one entry");
            }
        }

        if (errors.Count > 0)
        {
            throw new ArgumentException("rootconfig config validation failed:\n" + string.Join("\n", errors));
        }
        files = list;
    }
}
