/*
---
catzc:
  immutable:
    with_body_sha: "271d5e67268d"
  edges:
    test: pwsh/Catzc.Base.Docs/tests/types/AdrChecksConfig.Tests.ps1
    docs: "[AdrChecksConfig.cs.md](docs/references/pwsh/catzc-base-docs/types/AdrChecksConfig.cs.md)"
    cites:
      - ADR-AUTO-DEFAULT-ONERESOLUTIONORDER
      - ADR-AUTO-TEST-QUALITYGATE
      - ADR-BCL-TYPES-SNAKECASEMIRRORSYAML
      - ADR-CONF-LOADING-CSHARPCONFIGTYPE
      - PDR-CONFIG-VARYINGBEHAVIOURISCONFIG
      - PDR-CONFIG-DEFAULTDECLAREDONCE
---
*/

using System;
using System.Collections;
using System.Collections.Generic;

namespace Catzc.Base.Docs;

public sealed class AdrChecksConfig
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    private static readonly string[] AllowedKeys = { "engine_neutrality", "citation_graph", "dora_coverage", "code_language" };

    public AdrNeutralityCheck engine_neutrality { get; }
    public AdrCheck citation_graph { get; }
    public AdrDoraCheck dora_coverage { get; }
    public AdrCheck code_language { get; }

    public AdrChecksConfig(IDictionary raw)
    {
        List<string> errors = new List<string>();
        if (raw != null) { CheckKeys(raw, AllowedKeys, "adr-checks", errors); }

        engine_neutrality = new AdrNeutralityCheck(Section(raw, "engine_neutrality", errors), "engine_neutrality", errors);
        citation_graph = new AdrCheck(Section(raw, "citation_graph", errors), "citation_graph", errors);
        dora_coverage = new AdrDoraCheck(Section(raw, "dora_coverage", errors), "dora_coverage", errors);
        code_language = new AdrCheck(Section(raw, "code_language", errors), "code_language", errors);

        if (errors.Count > 0)
        {
            throw new ArgumentException("adr-checks.yml is invalid:\n  - " + string.Join("\n  - ", errors));
        }
    }

    // A check's mode, parsed by the one CheckModes parser; its error is prefixed with the check's key, like every error here.
    internal static CheckMode ParseMode(IDictionary raw, string where, List<string> errors)
    {
        CheckMode mode = CheckModes.Parse(raw, out string error);
        if (error != null) { errors.Add(where + ": " + error); }
        return mode;
    }

    internal static void CheckKeys(IDictionary map, string[] allowed, string where, List<string> errors)
    {
        foreach (object key in map.Keys)
        {
            string k = key == null ? string.Empty : key.ToString();
            if (Array.IndexOf(allowed, k) < 0)
            {
                errors.Add(string.Format("{0}: unknown key '{1}' (allowed: {2})", where, k, string.Join(", ", allowed)));
            }
        }
    }

    private static IDictionary Section(IDictionary raw, string key, List<string> errors)
    {
        if (raw == null || !raw.Contains(key) || raw[key] == null) { return null; }
        IDictionary section = raw[key] as IDictionary;
        if (section == null) { errors.Add(string.Format("{0}: must be a mapping", key)); }
        return section;
    }
}
