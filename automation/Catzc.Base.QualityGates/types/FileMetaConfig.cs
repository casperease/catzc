/*
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/types/FileMetaConfig.cs
    kind: csharp-type
    module: Catzc.Base.QualityGates
    adrs:
      - ADR-CONF-LOADING#4
      - ADR-REPO-FILEMETA#2
---
*/

// The meta-kind registry (file-meta.yml): which kinds of derived fact and of config contribution exist is data, never a list in an engine.
// [comment:1](/docs/references/automation/catzc-base-qualitygates/types/FileMetaConfig.cs.md#comment1)

using System;
using System.Collections;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;

namespace Catzc.Base.QualityGates;

public sealed class FileMetaConfig
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    public IReadOnlyList<FileMetaKind> kinds { get; }

    public FileMetaConfig(IDictionary raw)
    {
        var list = new List<FileMetaKind>();
        if (raw != null)
        {
            foreach (object key in raw.Keys)
            {
                string name = Convert.ToString(key, CultureInfo.InvariantCulture);
                if (name != "kinds")
                {
                    throw new ArgumentException(string.Format(CultureInfo.InvariantCulture,
                        "file-meta config: unknown key '{0}' (allowed: kinds)", name));
                }
            }
            if (raw.Contains("kinds") && raw["kinds"] != null)
            {
                if (!(raw["kinds"] is IDictionary map))
                {
                    throw new ArgumentException("file-meta config: kinds must be a map of kind id to its entry");
                }
                foreach (DictionaryEntry entry in map)
                {
                    string id = Convert.ToString(entry.Key, CultureInfo.InvariantCulture);
                    if (entry.Value != null && !(entry.Value is IDictionary))
                    {
                        throw new ArgumentException("file-meta config: kind '" + id + "' must be a map (or empty to take every default)");
                    }
                    list.Add(new FileMetaKind(id, entry.Value as IDictionary));
                }
            }
        }

        // A derived key belongs to one imprint kind, so two kinds never write the same key.
        var owner = new Dictionary<string, string>(StringComparer.Ordinal);
        foreach (FileMetaKind kind in list.Where(k => k.direction == FileMetaDirection.Imprint))
        {
            foreach (string key in kind.keys)
            {
                if (owner.TryGetValue(key, out string first))
                {
                    throw new ArgumentException(string.Format(CultureInfo.InvariantCulture,
                        "file-meta config: derived key '{0}' is owned by both '{1}' and '{2}'", key, first, kind.id));
                }
                owner[key] = kind.id;
            }
        }
        kinds = list;
    }

    // The imprint kinds in registry order: the order their facts are written.
    public IReadOnlyList<FileMetaKind> Imprint() => kinds.Where(k => k.direction == FileMetaDirection.Imprint).ToList();

    // The gather kinds that feed one config.
    public IReadOnlyList<FileMetaKind> GatherFor(string config) =>
        kinds.Where(k => k.direction == FileMetaDirection.Gather && string.Equals(k.target, config, StringComparison.Ordinal)).ToList();
}
