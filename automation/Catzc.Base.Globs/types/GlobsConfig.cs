// The globset registry (configs/globs.yml) and its validity rules: a non-empty 'globsets' map of
// kebab-case name -> { description, layer (deployable-unit | loose-fileset — 'module' is derived-only and
// rejected here, ADR-GLOBS:7), [include: [...]], [exclude: [...]], [compose: [...]],
// [verify: { modules, level }], [pipeline] }, each entry a valid GlobSet, no unknown keys anywhere
// (strict-config discipline), compose references resolving to declared sets acyclically (ADR-GLOBS:8),
// and the self-exclusion rule — no globset may have a sha-marker file as an effective member (ADR-GLOBS:6;
// marker files are outputs of the hash, never inputs), asserted by probing every declared marker path plus
// a canary marker path against every set's effective membership. The config itself is an ordinary tracked
// file and may be a member. Constructing an instance validates the whole registry (collecting all errors)
// and exposes the sets in registry order.
// See docs/adr/pipelines/durable-sha-globs.md.

using System;
using System.Collections;
using System.Collections.Generic;

namespace Catzc.Base.Globs;

public sealed class GlobsConfig
{
    // The config's own repo-relative path (named in lookup errors).
    public const string ConfigPath = "automation/Catzc.Base.Globs/configs/globs.yml";

    // Names reserved for the DERIVED globsets (ADR-PROTGLOB): the infra scopes every module's tests depend
    // on. Module folders derive their own sets by convention (Get-ModuleGlobSet); a declared set may not
    // shadow a reserved name — the declared registry and the derived sets share one name space.
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
                errors.Add(string.Format("unknown top-level key '{0}' (only 'globsets' is allowed)", top));
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
                errors.Add(string.Format("globset name '{0}' is reserved for a derived infra set (ADR-PROTGLOB); pick another name", name));
                continue;
            }
            if (ReadStr(entry, "layer") == "module")
            {
                errors.Add(string.Format("globset '{0}': the 'module' layer is derived-only (ADR-GLOBS:7, ADR-PROTGLOB) — the folder is the registration; declared layers: {1}", name, string.Join(", ", GlobSet.DeclaredLayers)));
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

        // ---- compose resolution (ADR-GLOBS:8): every reference names a declared set, never itself, and
        //      the reference graph is acyclic; effective membership is the union through the references. ----
        foreach (GlobSet set in sets)
        {
            List<GlobSet> resolved = new List<GlobSet>();
            foreach (string reference in set.Compose)
            {
                GlobSet target;
                if (reference == set.Name)
                {
                    errors.Add(string.Format("globset '{0}' composes itself (ADR-GLOBS:8)", set.Name));
                }
                else if (!map.TryGetValue(reference, out target))
                {
                    errors.Add(string.Format("globset '{0}' composes unknown set '{1}' — compose references declared sets only (ADR-GLOBS:8)", set.Name, reference));
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
                errors.Add(string.Format("compose cycle: {0} (ADR-GLOBS:8)", cycle));
                break;
            }
        }

        // A broken compose graph makes Matches() unsafe (a cycle would recurse forever), so the
        // self-exclusion probes below cannot run — fail now with everything collected so far.
        if (errors.Count > 0)
        {
            throw new ArgumentException("globs config validation failed:\n" + string.Join("\n", errors));
        }

        // ---- self-exclusion (ADR-GLOBS:6): sha-marker files are outputs of the hash, never members.
        //      Probes: every declared marker path, plus a canary marker path that catches catch-alls
        //      like '**' or '.sha-markers/**' regardless of the declared names. ----
        List<string> probes = new List<string>();
        foreach (GlobSet set in sets) { probes.Add(set.MarkerPath); }
        probes.Add(".sha-markers/canary.yml");

        foreach (GlobSet set in sets)
        {
            foreach (string probe in probes)
            {
                if (set.Matches(probe))
                {
                    errors.Add(string.Format("globset '{0}' matches '{1}' — sha-marker files are outputs of the hash, never members (ADR-GLOBS:6); add an exclude", set.Name, probe));
                    break;
                }
            }
        }

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

    // Depth-first walk of the compose references; returns the cycle path when one exists, else null.
    // Guarded against unresolved references (already reported) by walking the name map only.
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
