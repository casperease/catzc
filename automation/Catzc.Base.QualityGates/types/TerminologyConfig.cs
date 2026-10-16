/*
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/types/TerminologyConfig.cs
    kind: csharp-type
    language: csharp
    track: automation
    module: Catzc.Base.QualityGates
    relatives:
      page: docs/references/automation/catzc-base-qualitygates/types/TerminologyConfig.cs.md
      test: automation/Catzc.Base.QualityGates/tests/types/TerminologyConfig.Tests.ps1
    adrs:
      - ADR-AUTO-SPELL
---
*/

using System;
using System.Collections;
using System.Collections.Generic;

namespace Catzc.Base.QualityGates;

public sealed class TerminologyConfig
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    // The defined category names, in registry order — one generated dictionary per category.
    public IReadOnlyList<string> categories { get; }

    public IReadOnlyDictionary<string, IReadOnlyList<string>> categoryScopes { get; }

    // Every approved-vocabulary entry, in registry order.
    public IReadOnlyList<TerminologyTerm> terms { get; }

    private static readonly string[] AllowedKeys = { "categories", "terms" };

    public TerminologyConfig(IDictionary raw)
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

        // ---- categories: a non-empty map of category name -> { description, [scope] } ----
        IDictionary categoryMap = (raw != null && raw.Contains("categories")) ? raw["categories"] as IDictionary : null;
        if (categoryMap == null || categoryMap.Count == 0)
        {
            throw new ArgumentException("terminology config requires a non-empty 'categories' map");
        }

        List<string> categoryNames = new List<string>();
        HashSet<string> categorySet = new HashSet<string>(StringComparer.OrdinalIgnoreCase);
        Dictionary<string, IReadOnlyList<string>> scopes = new Dictionary<string, IReadOnlyList<string>>(StringComparer.OrdinalIgnoreCase);
        foreach (object key in categoryMap.Keys)
        {
            string name = key == null ? null : key.ToString();
            if (string.IsNullOrWhiteSpace(name))
            {
                errors.Add("a category name must be non-empty");
                continue;
            }

            // Each category is a mapping: a required 'description' and an optional 'scope' list; no other keys.
            IDictionary entry = categoryMap[key] as IDictionary;
            if (entry == null)
            {
                errors.Add(string.Format("category '{0}': must be a mapping with a 'description' (and optional 'scope')", name));
                continue;
            }
            foreach (object entryKey in entry.Keys)
            {
                string ek = entryKey == null ? null : entryKey.ToString();
                if (ek != "description" && ek != "scope")
                {
                    errors.Add(string.Format("category '{0}': unknown key '{1}' (only 'description' and 'scope' are allowed)", name, ek));
                }
            }

            object description = entry.Contains("description") ? entry["description"] : null;
            if (description == null || string.IsNullOrWhiteSpace(description.ToString()))
            {
                errors.Add(string.Format("category '{0}': a description is required", name));
            }

            List<string> scopeGlobs = new List<string>();
            if (entry.Contains("scope"))
            {
                IEnumerable scopeSeq = entry["scope"] as IEnumerable;
                if (scopeSeq == null || entry["scope"] is string)
                {
                    errors.Add(string.Format("category '{0}': 'scope' must be a list of glob strings", name));
                }
                else
                {
                    foreach (object g in scopeSeq)
                    {
                        string glob = g == null ? null : g.ToString();
                        if (string.IsNullOrWhiteSpace(glob))
                        {
                            errors.Add(string.Format("category '{0}': a scope glob must be non-empty", name));
                            continue;
                        }
                        if (glob.IndexOf('\\') >= 0)
                        {
                            errors.Add(string.Format("category '{0}': scope glob '{1}' must be '/'-separated (no backslash)", name, glob));
                            continue;
                        }
                        scopeGlobs.Add(glob);
                    }
                }
            }

            if (!categorySet.Add(name))
            {
                errors.Add(string.Format("duplicate category '{0}'", name));
                continue;
            }
            categoryNames.Add(name);
            scopes[name] = scopeGlobs;
        }

        object termsObj = (raw != null && raw.Contains("terms")) ? raw["terms"] : null;
        IDictionary termsMap = termsObj as IDictionary;
        if (termsMap == null || termsMap.Count == 0)
        {
            throw new ArgumentException("terminology config requires a non-empty 'terms' map");
        }

        List<TerminologyTerm> list = new List<TerminologyTerm>();
        HashSet<string> seen = new HashSet<string>(StringComparer.OrdinalIgnoreCase);

        foreach (object groupKey in termsMap.Keys)
        {
            string category = groupKey == null ? null : groupKey.ToString();
            if (string.IsNullOrWhiteSpace(category))
            {
                errors.Add("a terms group name must be non-empty");
                continue;
            }
            if (!categorySet.Contains(category))
            {
                errors.Add(string.Format("terms group '{0}' is not a defined category (add it under 'categories')", category));
                continue;
            }
            IEnumerable groupSeq = termsMap[groupKey] as IEnumerable;
            if (groupSeq == null || termsMap[groupKey] is string)
            {
                errors.Add(string.Format("terms group '{0}' must be a list of entries", category));
                continue;
            }
            foreach (object item in groupSeq)
            {
                IDictionary entry = item as IDictionary;
                if (entry == null) { errors.Add(string.Format("each entry in terms group '{0}' must be a mapping", category)); continue; }

                TerminologyTerm t;
                try { t = new TerminologyTerm(entry, category); }
                catch (ArgumentException ex) { errors.Add(ex.Message); continue; }

                if (!seen.Add(t.term)) { errors.Add(string.Format("duplicate term '{0}'", t.term)); continue; }
                list.Add(t);
            }
        }

        if (errors.Count == 0 && list.Count == 0)
        {
            errors.Add("terminology config requires a non-empty 'terms' map");
        }
        if (errors.Count > 0)
        {
            throw new ArgumentException("terminology config validation failed:\n" + string.Join("\n", errors));
        }

        categories = categoryNames;
        categoryScopes = scopes;
        terms = list;
    }
}
