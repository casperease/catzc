using System;
using System.Collections;
using System.Collections.Generic;

namespace Catzc.Base.Docs;

// The authored text of the ADR index: the preamble above the generated code tables and the authoring conventions below them, both Markdown that Build-AdrIndex reflows ([ADR-PRIN-CONFIG#1](/docs/adr/principles/configure-not-program.md#rule-adr-prin-config1)).
public sealed class AdrIndexConfig
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    private static readonly string[] AllowedKeys = { "preamble", "conventions" };

    public string preamble { get; }
    public string conventions { get; }

    public AdrIndexConfig(IDictionary raw)
    {
        List<string> errors = new List<string>();
        if (raw == null) { throw new ArgumentException("adr-index.yml is invalid:\n  - the configuration must be a mapping with preamble and conventions"); }
        AdrChecksConfig.CheckKeys(raw, AllowedKeys, "adr-index", errors);
        preamble = Text(raw, "preamble", errors);
        conventions = Text(raw, "conventions", errors);
        if (errors.Count > 0)
        {
            throw new ArgumentException("adr-index.yml is invalid:\n  - " + string.Join("\n  - ", errors));
        }
    }

    // Both texts are required: the index has no sensible text of its own to fall back to.
    private static string Text(IDictionary raw, string key, List<string> errors)
    {
        string text = raw.Contains(key) && raw[key] != null ? raw[key].ToString() : null;
        if (string.IsNullOrWhiteSpace(text)) { errors.Add(string.Format("adr-index: {0} is required, the Markdown text of that part of the index", key)); }
        return text;
    }
}
