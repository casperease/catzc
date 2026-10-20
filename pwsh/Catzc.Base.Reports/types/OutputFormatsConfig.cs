/*
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.Reports/types/OutputFormatsConfig.cs
    folder: types
    name: output-formats-config
    filetype: cs
    role: type
    language: csharp
    track: pwsh
    tracktype: modules
    module: Catzc.Base.Reports
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    test: pwsh/Catzc.Base.Reports/tests/types/OutputFormatsConfig.Tests.ps1
    docs: "[OutputFormatsConfig.cs.md](docs/references/pwsh/catzc-base-reports/types/OutputFormatsConfig.cs.md)"
    cites:
      - ADR-AUTO-TYPES-SNAKECASEMIRRORSYAML
      - ADR-REPO-OUTFMT-OUTPUTFORMAT
---
*/

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
            List<KeyValuePair<string, OutputPattern>> seen = new List<KeyValuePair<string, OutputPattern>>();
            foreach (object k in source.Keys)
            {
                string formatId = k == null ? "" : k.ToString();
                OutputFormat format;
                try { format = new OutputFormat(formatId, source[k]); }
                catch (ArgumentException ex) { errors.Add(ex.Message); continue; }
                map[formatId] = format;

                foreach (string text in format.patterns)
                {
                    OutputPattern pattern = OutputPattern.Parse(text);
                    foreach (KeyValuePair<string, OutputPattern> earlier in seen)
                    {
                        if (earlier.Key != formatId && pattern.Overlaps(earlier.Value))
                        {
                            errors.Add(string.Format(
                                "pattern '{0}' of '{1}' and pattern '{2}' of '{3}' can match the same path (a file belongs to one format)",
                                earlier.Value.Text, earlier.Key, text, formatId));
                        }
                    }
                    seen.Add(new KeyValuePair<string, OutputPattern>(formatId, pattern));
                }
            }
        }

        if (errors.Count > 0) { throw new ArgumentException(Failed + string.Join("\n", errors)); }
        formats = map.AsReadOnly();
    }
}
