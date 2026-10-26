// The registry of writers Test-GeneratedFiles checks; the generators of the managed root files come from the root-config registry, not from here.

using System;
using System.Collections;
using System.Collections.Generic;
using System.Collections.Specialized;

namespace Catzc.Base.GeneratedFiles;

public sealed class GeneratedFilesConfig : Catzc.Base.Objects.DictionaryRecord
{
    private const string Failed = "generated-files configuration validation failed:\n";

    // Writer command name -> GeneratedWriter, in declaration order; read-only.
    public OrderedDictionary writers { get; }

    // How deep the walk for a writer's '**' input glob goes below the glob's literal folder.
    public const int DefaultInputDepth = 16;
    public int input_depth { get; }

    public GeneratedFilesConfig(IDictionary raw)
    {
        List<string> errors = new List<string>();
        if (raw == null) { throw new ArgumentException(Failed + "the configuration must be a mapping"); }

        foreach (object k in raw.Keys)
        {
            string key = k == null ? null : k.ToString();
            if (key != "writers" && key != "input_depth") { errors.Add(string.Format("unknown top-level key '{0}' (allowed: writers, input_depth)", key)); }
        }

        int depth = DefaultInputDepth;
        if (raw.Contains("input_depth") && !(int.TryParse(Convert.ToString(raw["input_depth"], System.Globalization.CultureInfo.InvariantCulture), out depth) && depth > 0))
        {
            errors.Add("'input_depth' must be a positive whole number");
        }
        input_depth = depth;

        OrderedDictionary map = new OrderedDictionary(StringComparer.Ordinal);
        IDictionary source = raw.Contains("writers") ? raw["writers"] as IDictionary : null;
        if (source == null || source.Count == 0)
        {
            errors.Add("'writers' must be a non-empty map of <Verb-Noun>: { [check], [result_path], [inputs], [outputs] }");
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
