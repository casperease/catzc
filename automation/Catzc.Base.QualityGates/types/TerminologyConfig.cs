// The terminology registry (configs/terminology.yml) and its validity rules: a non-empty 'categories' map
// (each category documented with a description) and a non-empty 'terms' map that groups entries under those
// category keys (terms: <category>: [ {term, meaning, [expands_to]}, ... ]). Every group key must be a
// defined category, every entry a valid TerminologyTerm, and no term duplicated across groups. Constructing
// an instance validates the registry (throwing on the first malformed shape) and exposes the parsed
// categories and the flattened terms (each carrying its group's category) to the generator
// (Build-TerminologyDictionary) and gate (Test-Terminology). The 'categories' map is the single source of the
// category set. See docs/adr/automation/spell-out-names.md (ADR-SPELL:5-ADR-SPELL:8).

using System;
using System.Collections;
using System.Collections.Generic;

namespace Catzc.Base.QualityGates;

public sealed class TerminologyConfig
{
    // The defined category names, in registry order — one generated dictionary per category.
    public IReadOnlyList<string> categories { get; }

    // Every approved-vocabulary entry, in registry order.
    public IReadOnlyList<TerminologyTerm> terms { get; }

    public TerminologyConfig(IDictionary raw)
    {
        List<string> errors = new List<string>();

        // ---- categories: a non-empty map of category name -> description ----
        IDictionary categoryMap = (raw != null && raw.Contains("categories")) ? raw["categories"] as IDictionary : null;
        if (categoryMap == null || categoryMap.Count == 0)
        {
            throw new ArgumentException("terminology config requires a non-empty 'categories' map");
        }

        List<string> categoryNames = new List<string>();
        HashSet<string> categorySet = new HashSet<string>(StringComparer.OrdinalIgnoreCase);
        foreach (object key in categoryMap.Keys)
        {
            string name = key == null ? null : key.ToString();
            object description = categoryMap[key];
            if (string.IsNullOrWhiteSpace(name))
            {
                errors.Add("a category name must be non-empty");
                continue;
            }
            if (description == null || string.IsNullOrWhiteSpace(description.ToString()))
            {
                errors.Add(string.Format("category '{0}': a description is required", name));
            }
            if (!categorySet.Add(name))
            {
                errors.Add(string.Format("duplicate category '{0}'", name));
                continue;
            }
            categoryNames.Add(name);
        }

        // ---- terms: a non-empty map of category -> list of entries; each valid, unique, under a defined
        //      category. The group key IS the category, so entries carry no category field. ----
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
        terms = list;
    }
}
