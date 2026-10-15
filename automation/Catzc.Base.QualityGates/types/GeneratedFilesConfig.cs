/*
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/types/GeneratedFilesConfig.cs
    kind: type
    module: Catzc.Base.QualityGates
    adrs: []
---
*/

// The registry of writers Test-GeneratedFiles checks; the generators of the managed root files come from the root-config registry, not from here.

using System;
using System.Collections;
using System.Collections.Generic;
using System.Collections.Specialized;

namespace Catzc.Base.QualityGates;

public sealed class GeneratedFilesConfig : Catzc.Base.Objects.DictionaryRecord
{
    private const string Failed = "generated-files configuration validation failed:\n";

    // Writer command name -> GeneratedWriter, in declaration order; read-only.
    public OrderedDictionary writers { get; }

    public GeneratedFilesConfig(IDictionary raw)
    {
        List<string> errors = new List<string>();
        if (raw == null) { throw new ArgumentException(Failed + "the configuration must be a mapping"); }

        foreach (object k in raw.Keys)
        {
            string key = k == null ? null : k.ToString();
            if (key != "writers") { errors.Add(string.Format("unknown top-level key '{0}' (allowed: writers)", key)); }
        }

        OrderedDictionary map = new OrderedDictionary(StringComparer.Ordinal);
        IDictionary source = raw.Contains("writers") ? raw["writers"] as IDictionary : null;
        if (source == null || source.Count == 0)
        {
            errors.Add("'writers' must be a non-empty map of <Verb-Noun>: { [check], [result_path] }");
        }
        else
        {
            foreach (object k in source.Keys)
            {
                string name = k == null ? "" : k.ToString();
                try { map[name] = new GeneratedWriter(name, source[k]); }
                catch (ArgumentException ex) { errors.Add(ex.Message); }
            }
        }

        if (errors.Count > 0) { throw new ArgumentException(Failed + string.Join("\n", errors)); }
        writers = map.AsReadOnly();
    }
}
