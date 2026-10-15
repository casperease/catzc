/*
---
catzc:
  derived:
    path: automation/Catzc.Base.Globs/types/GlobsConfig.cs
    kind: type
    module: Catzc.Base.Globs
    adrs:
      - ADR-FLOW-CD-GLOBS
      - ADR-FLOW-CD-GLOBS#7
      - ADR-FLOW-CD-GLOBS#8
      - ADR-REPO-PROTGLOB
---
*/

// Construction validates the whole registry and collects every error before throwing, so one run shows all faults.
// [ADR-FLOW-CD-GLOBS#7](/docs/adr/flow/durable-sha-globs.md#rule-adr-flow-cd-globs7),
// [ADR-FLOW-CD-GLOBS#8](/docs/adr/flow/durable-sha-globs.md#rule-adr-flow-cd-globs8),
// [ADR-FLOW-CD-GLOBS](/docs/adr/flow/durable-sha-globs.md)
// [comment:1](/docs/references/automation/catzc-base-globs/types/GlobsConfig.cs.md#comment1)

using System;
using System.Collections;
using System.Collections.Generic;

namespace Catzc.Base.Globs;

public sealed class GlobsConfig
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    // The config's own repo-relative path (named in lookup errors).
    public const string ConfigPath = "automation/Catzc.Base.Globs/configs/globs.yml";

    // Declared and derived sets share one name space, so a declared set may not take a reserved name.
    // [ADR-REPO-PROTGLOB](/docs/adr/repository/protected-globs.md)
    // [comment:2](/docs/references/automation/catzc-base-globs/types/GlobsConfig.cs.md#comment2)
    public static readonly string[] ReservedNames = { "internal", "vendor", "compiled", "scriptanalyzer" };

    // Every globset, in registry order.
    public IReadOnlyList<GlobSet> globsets { get; }

    private readonly Dictionary<string, GlobSet> byName;

    public GlobsConfig(IDictionary raw)
    {
        List<string> errors = new List<string>();

        if (raw == null || !raw.Contains("globsets"))
        {
            throw new ArgumentException("globs config requires a non-empty 'globsets' map");
        }
        foreach (object key in raw.Keys)
        {
            string top = key == null ? null : key.ToString();
            if (top != "globsets")
            {
                errors.Add(string.Format("unknown top-level key '{0}' (allowed: globsets)", top));
            }
        }

        IDictionary setsMap = raw["globsets"] as IDictionary;
        if (setsMap == null || setsMap.Count == 0)
        {
            throw new ArgumentException("globs config requires a non-empty 'globsets' map");
        }

        List<GlobSet> sets = new List<GlobSet>();
        Dictionary<string, GlobSet> map = new Dictionary<string, GlobSet>(StringComparer.Ordinal);

        foreach (object nameKey in setsMap.Keys)
        {
            string name = nameKey == null ? null : nameKey.ToString();
            IDictionary entry = setsMap[nameKey] as IDictionary;
            if (entry == null)
            {
                errors.Add(string.Format("globset '{0}' must be a mapping with description/include", name));
                continue;
            }
            foreach (object entryKey in entry.Keys)
            {
                string field = entryKey == null ? null : entryKey.ToString();
                if (field != "description" && field != "layer" && field != "include" && field != "exclude"
                    && field != "compose" && field != "verify" && field != "pipeline")
                {
                    errors.Add(string.Format("globset '{0}': unknown key '{1}' (allowed: description, layer, include, exclude, compose, verify, pipeline)", name, field));
                }
            }

            if (Array.IndexOf(ReservedNames, name) >= 0)
            {
                errors.Add(string.Format("globset name '{0}' is reserved for a derived infra set (ADR-REPO-PROTGLOB); pick another name", name));
                continue;
            }
            if (ReadStr(entry, "layer") == "module")
            {
                errors.Add(string.Format("globset '{0}': the 'module' layer is derived-only (ADR-FLOW-CD-GLOBS#7, ADR-REPO-PROTGLOB) — the folder is the registration; declared layers: {1}", name, string.Join(", ", GlobSet.DeclaredLayers)));
                continue;
            }

            string[] verifyModules = null;
            int verifyLevel = -1;
            if (entry.Contains("verify"))
            {
                IDictionary verify = entry["verify"] as IDictionary;
                if (verify == null)
                {
                    errors.Add(string.Format("globset '{0}': verify must be a mapping with modules and level", name));
                    continue;
                }
                bool verifyOk = true;
                foreach (object verifyKey in verify.Keys)
                {
                    string field = verifyKey == null ? null : verifyKey.ToString();
                    if (field != "modules" && field != "level")
                    {
                        errors.Add(string.Format("globset '{0}': unknown verify key '{1}' (allowed: modules, level)", name, field));
                        verifyOk = false;
                    }
                }
                verifyModules = ReadList(verify, "modules");
                if (verifyModules == null || verifyModules.Length == 0)
                {
                    errors.Add(string.Format("globset '{0}': verify requires at least one module", name));
                    verifyOk = false;
                }
                string levelText = ReadStr(verify, "level");
                if (!int.TryParse(levelText, out verifyLevel) || verifyLevel < 0 || verifyLevel > 3)
                {
                    errors.Add(string.Format("globset '{0}': verify level '{1}' must be 0-3", name, levelText));
                    verifyOk = false;
                }
                if (!verifyOk) { continue; }
            }

            GlobSet set;
            try
            {
                set = new GlobSet(name, ReadStr(entry, "description"), ReadStr(entry, "layer"),
                    ReadList(entry, "include"), ReadList(entry, "exclude"), ReadList(entry, "compose"),
                    verifyModules, verifyLevel, ReadStr(entry, "pipeline"));
            }
            catch (ArgumentException ex)
            {
                errors.Add(ex.Message);
                continue;
            }
            sets.Add(set);
            map[set.Name] = set;
        }

        // Effective membership is the union through the references, so each must name another declared set, acyclically.
        // [ADR-FLOW-CD-GLOBS#8](/docs/adr/flow/durable-sha-globs.md#rule-adr-flow-cd-globs8)
        // [comment:3](/docs/references/automation/catzc-base-globs/types/GlobsConfig.cs.md#comment3)
        foreach (GlobSet set in sets)
        {
            List<GlobSet> resolved = new List<GlobSet>();
            foreach (string reference in set.Compose)
            {
                GlobSet target;
                if (reference == set.Name)
                {
                    errors.Add(string.Format("globset '{0}' composes itself (ADR-FLOW-CD-GLOBS#8)", set.Name));
                }
                else if (!map.TryGetValue(reference, out target))
                {
                    errors.Add(string.Format("globset '{0}' composes unknown set '{1}' — compose references declared sets only (ADR-FLOW-CD-GLOBS#8)", set.Name, reference));
                }
                else
                {
                    resolved.Add(target);
                }
            }
            set.ResolveCompose(resolved);
        }
        foreach (GlobSet set in sets)
        {
            string cycle = FindComposeCycle(set, map, new List<string>());
            if (cycle != null)
            {
                errors.Add(string.Format("compose cycle: {0} (ADR-FLOW-CD-GLOBS#8)", cycle));
                break;
            }
        }

        // A cycle would make Matches recurse forever, so fail here, before any set is exposed, with every error collected.
        // [comment:4](/docs/references/automation/catzc-base-globs/types/GlobsConfig.cs.md#comment4)
        if (errors.Count > 0)
        {
            throw new ArgumentException("globs config validation failed:\n" + string.Join("\n", errors));
        }

        globsets = sets;
        byName = map;
    }

    public GlobSet Get(string name)
    {
        GlobSet set;
        if (name == null || !byName.TryGetValue(name, out set))
        {
            throw new ArgumentException(string.Format("no globset named '{0}' is defined in {1}", name, ConfigPath));
        }
        return set;
    }

    public bool Contains(string name)
    {
        return name != null && byName.ContainsKey(name);
    }

    public IReadOnlyList<string> Names
    {
        get
        {
            List<string> names = new List<string>();
            foreach (GlobSet set in globsets) { names.Add(set.Name); }
            return names;
        }
    }

    // Walks the name map only, so a reference that did not resolve (already reported) cannot throw here.
    // [comment:5](/docs/references/automation/catzc-base-globs/types/GlobsConfig.cs.md#comment5)
    private static string FindComposeCycle(GlobSet set, Dictionary<string, GlobSet> map, List<string> path)
    {
        if (path.Contains(set.Name))
        {
            path.Add(set.Name);
            return string.Join(" -> ", path.GetRange(path.IndexOf(set.Name), path.Count - path.IndexOf(set.Name)));
        }
        path.Add(set.Name);
        foreach (string reference in set.Compose)
        {
            GlobSet target;
            if (map.TryGetValue(reference, out target))
            {
                string cycle = FindComposeCycle(target, map, path);
                if (cycle != null) { return cycle; }
            }
        }
        path.RemoveAt(path.Count - 1);
        return null;
    }

    private static string ReadStr(IDictionary d, string key)
    {
        object v = d.Contains(key) ? d[key] : null;
        return v == null ? null : v.ToString();
    }

    private static string[] ReadList(IDictionary d, string key)
    {
        object v = d.Contains(key) ? d[key] : null;
        if (v == null) { return null; }
        if (v is string) { return new[] { (string)v }; }
        IEnumerable seq = v as IEnumerable;
        if (seq == null) { return new[] { v.ToString() }; }
        List<string> list = new List<string>();
        foreach (object item in seq) { if (item != null) { list.Add(item.ToString()); } }
        return list.ToArray();
    }
}
