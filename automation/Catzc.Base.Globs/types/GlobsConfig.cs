// The globset registry (configs/globs.yml) and its validity rules: a non-empty 'globsets' map of
// kebab-case name -> { description, include: [...], [exclude: [...]] }, each entry a valid GlobSet, no
// unknown keys anywhere (strict-config discipline), and the self-exclusion rule — no globset may have a
// trigger file as a member (ADR-GLOBS:6; trigger files are outputs of the hash, never inputs), asserted by
// probing every declared trigger path plus a canary trigger path against every set's membership. The config
// itself is an ordinary tracked file and may be a member. Constructing an instance validates the whole
// registry (collecting all errors) and exposes the sets in registry order.
// See docs/adr/pipelines/durable-sha-globs.md.

using System;
using System.Collections;
using System.Collections.Generic;

namespace Catzc.Base.Globs;

public sealed class GlobsConfig
{
    // The config's own repo-relative path — a forbidden member of every globset (ADR-GLOBS:6).
    public const string ConfigPath = "automation/Catzc.Base.Globs/configs/globs.yml";

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
                if (field != "description" && field != "include" && field != "exclude")
                {
                    errors.Add(string.Format("globset '{0}': unknown key '{1}' (allowed: description, include, exclude)", name, field));
                }
            }

            GlobSet set;
            try
            {
                set = new GlobSet(name, ReadStr(entry, "description"), ReadList(entry, "include"), ReadList(entry, "exclude"));
            }
            catch (ArgumentException ex)
            {
                errors.Add(ex.Message);
                continue;
            }
            sets.Add(set);
            map[set.Name] = set;
        }

        // ---- self-exclusion (ADR-GLOBS:6): trigger files are outputs of the hash, never members.
        //      Probes: every declared trigger path, plus a canary trigger path that catches catch-alls
        //      like '**' or '.triggers/**' regardless of the declared names. ----
        List<string> probes = new List<string>();
        foreach (GlobSet set in sets) { probes.Add(set.TriggerPath); }
        probes.Add(".triggers/canary.sha256");

        foreach (GlobSet set in sets)
        {
            foreach (string probe in probes)
            {
                if (set.Matches(probe))
                {
                    errors.Add(string.Format("globset '{0}' matches '{1}' — trigger files are outputs of the hash, never members (ADR-GLOBS:6); add an exclude", set.Name, probe));
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
