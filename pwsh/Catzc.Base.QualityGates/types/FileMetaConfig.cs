/*
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-quality-gates/types/FileMetaConfig.cs.md"
  warning: "Generated Header"
---
*/

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

    public FileHeadPolicy head_policy { get; }

    public const string DefaultWarning = "Generated Header";

    // The one line an authored head opens with, naming the command that writes it; a blank value keeps the default.
    public string warning { get; }

    public FileMetaConfig(IDictionary raw)
    {
        var list = new List<FileMetaKind>();
        IDictionary policy = null;
        warning = DefaultWarning;
        if (raw != null)
        {
            foreach (object key in raw.Keys)
            {
                string name = Convert.ToString(key, CultureInfo.InvariantCulture);
                if (name != "kinds" && name != "head_policy" && name != "warning")
                {
                    throw new ArgumentException(string.Format(CultureInfo.InvariantCulture,
                        "file-meta config: unknown key '{0}' (allowed: kinds, head_policy, warning)", name));
                }
            }
            string declared = raw.Contains("warning") ? Convert.ToString(raw["warning"], CultureInfo.InvariantCulture) : null;
            if (!string.IsNullOrWhiteSpace(declared)) { warning = declared; }
            if (raw.Contains("head_policy") && raw["head_policy"] != null)
            {
                policy = raw["head_policy"] as IDictionary;
                if (policy == null)
                {
                    throw new ArgumentException("file-meta config: head_policy must be a map (default, classes)");
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

        // A key belongs to one imprint kind, so two kinds never write the same key.
        var owner = new Dictionary<string, string>(StringComparer.Ordinal);
        foreach (FileMetaKind kind in list.Where(k => k.direction == FileMetaDirection.Imprint))
        {
            foreach (string key in kind.keys)
            {
                if (owner.TryGetValue(key, out string first))
                {
                    throw new ArgumentException(string.Format(CultureInfo.InvariantCulture,
                        "file-meta config: key '{0}' is owned by both '{1}' and '{2}'", key, first, kind.id));
                }
                owner[key] = kind.id;
            }
        }
        kinds = list;
        head_policy = new FileHeadPolicy(policy);
        foreach (FileMetaKind kind in list) { kind.registry = this; }
    }

    public HeadPolicy PolicyFor(string fileClass) => head_policy.For(fileClass);

    public static string[] EngineInputs(string modulesRoot)
    {
        if (string.IsNullOrEmpty(modulesRoot)) { throw new ArgumentException("modulesRoot must not be empty", "modulesRoot"); }
        string qualityGates = System.IO.Path.Combine(modulesRoot, "Catzc.Base.QualityGates");
        string types = System.IO.Path.Combine(qualityGates, "types");
        return new Catzc.Base.Folders.PathSet()
            .AddFile(qualityGates, "configs/file-meta.yml")
            .AddFile(System.IO.Path.Combine(modulesRoot, "Catzc.Base.Languages"), "configs/file-carriers.yml")
            .AddFile(qualityGates, "Format-FileMeta.ps1")
            .AddFile(qualityGates, "private/Invoke-FileMetaEngine.ps1")
            .AddPattern(qualityGates, "Get-*FileMetaFact.ps1")
            .AddPattern(types, "FileMeta*.cs", 1)
            .AddPattern(types, "*HeadPolicy.cs", 1)
            .ToArray();
    }

    public bool Selects(FileMetaKind kind, string fileClass, string language) => kind != null && kind.Selects(fileClass, language);

    // True when any imprint kind applies to the file: the file is in the meta scope.
    public bool SelectsAny(string fileClass, string language) => Imprint().Any(kind => kind.Selects(fileClass, language));

    // The imprint kinds in registry order: the order their facts are written.
    public IReadOnlyList<FileMetaKind> Imprint() => kinds.Where(k => k.direction == FileMetaDirection.Imprint).ToList();

    // The keys the imprint kinds write, in registry order, at the block's first level.
    public IReadOnlyList<string> ImprintKeys() => Imprint().SelectMany(k => k.keys).ToList();

    // The gather kinds that feed one config.
    public IReadOnlyList<FileMetaKind> GatherFor(string config) =>
        kinds.Where(k => k.direction == FileMetaDirection.Gather && string.Equals(k.target, config, StringComparison.Ordinal)).ToList();
}
