// The output-format catalogue, configs/output-formats.yml: every kind of file a producer writes under the output
// root, declared once ([ADR-REPO-OUTFMT#1](/docs/adr/repository/output-formats.md#rule-adr-repo-outfmt1)).
// Constructing an instance MAPS and VALIDATES the parsed YAML, collecting every violation into one throw.
// Registered in Catzc.Base.Config/configs/configs.yml (type: Catzc.Base.Reports.OutputFormatsConfig), so
// Get-Config -Config output-formats returns this typed model. Mirrors the YAML mapping (snake_case keys,
// [ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)).
//
// Load-time rules:
//   - only the top-level key 'formats' (required, a non-empty map of id -> OutputFormat);
//   - each entry well-formed (OutputFormat);
//   - no pattern appears in two formats, so a file's format is never decided by declaration order.
// Which format a file on disk belongs to, and whether it is whole, is Test-OutputFormats' job, not load's.

using System;
using System.Collections;
using System.Collections.Generic;
using System.Collections.Specialized;

namespace Catzc.Base.Reports;

public sealed class OutputFormatsConfig : Catzc.Base.Objects.DictionaryRecord
{
    private const string Failed = "output-formats configuration validation failed:\n";

    // Format id -> OutputFormat, in declaration order; read-only.
    public OrderedDictionary formats { get; }

    public OutputFormatsConfig(IDictionary raw)
    {
        List<string> errors = new List<string>();
        if (raw == null) { throw new ArgumentException(Failed + "the configuration must be a mapping"); }

        foreach (object k in raw.Keys)
        {
            string key = k == null ? null : k.ToString();
            if (key != "formats") { errors.Add(string.Format("unknown top-level key '{0}' (allowed: formats)", key)); }
        }

        OrderedDictionary map = new OrderedDictionary(StringComparer.Ordinal);
        IDictionary source = (raw.Contains("formats") ? raw["formats"] : null) as IDictionary;
        if (source == null || source.Count == 0)
        {
            errors.Add("'formats' is required: a non-empty map of <kebab-case id>: { patterns, producer, audience, validator [, target, limits] }");
        }
        else
        {
            Dictionary<string, string> owner = new Dictionary<string, string>(StringComparer.Ordinal);
            foreach (object k in source.Keys)
            {
                string formatId = k == null ? "" : k.ToString();
                OutputFormat format;
                try { format = new OutputFormat(formatId, source[k]); }
                catch (ArgumentException ex) { errors.Add(ex.Message); continue; }
                map[formatId] = format;

                foreach (string pattern in format.patterns)
                {
                    string first;
                    if (owner.TryGetValue(pattern, out first))
                    {
                        errors.Add(string.Format("pattern '{0}' is declared by both '{1}' and '{2}' (a pattern belongs to one format)", pattern, first, formatId));
                    }
                    else { owner[pattern] = formatId; }
                }
            }
        }

        if (errors.Count > 0) { throw new ArgumentException(Failed + string.Join("\n", errors)); }
        formats = map.AsReadOnly();
    }
}
