// adr-checks.yml — the settings of the ADR checks over the rule registries, and the single declaration of their sensible defaults
// ([ADR-AUTO-DEFAULT#6](/docs/adr/automation/sensible-defaults.md#rule-adr-auto-default6)). Every key is optional: an omitted key
// behaves exactly like its default, so the file states only what deviates
// ([ADR-PRIN-CONFIG#3](/docs/adr/principles/configure-not-program.md#rule-adr-prin-config3)). Registered in
// Catzc.Base.Config/configs/configs.yml (type: Catzc.Base.Docs.AdrChecksConfig), so Get-Config -Config adr-checks returns this typed
// record ([ADR-CONF-LOADING#4](/docs/adr/configuration/module-config-loading.md#rule-adr-conf-loading4)). Mirrors the YAML mapping
// (snake_case, [ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)).
//   engine_neutrality — AdrNeutralityCheck, read by Test-AdrEngineNeutrality
//   citation_graph    — AdrCheck, read by Test-AdrRegistry
//   dora_coverage     — AdrDoraCheck, read by Test-AdrRegistry
// Each check's mode is one setting, never a branch per check in code
// ([ADR-PRIN-CONFIG#1](/docs/adr/principles/configure-not-program.md#rule-adr-prin-config1)); its default is CheckMode's, Gate,
// because every repository check is a quality gate ([ADR-AUTO-TEST#35](/docs/adr/automation/test-automation.md#rule-adr-auto-test35)).
// Constructing an instance validates the file, collecting every violation into one ArgumentException.

using System;
using System.Collections;
using System.Collections.Generic;

namespace Catzc.Base.Docs;

public sealed class AdrChecksConfig
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    private static readonly string[] AllowedKeys = { "engine_neutrality", "citation_graph", "dora_coverage" };

    public AdrNeutralityCheck engine_neutrality { get; }
    public AdrCheck citation_graph { get; }
    public AdrDoraCheck dora_coverage { get; }

    public AdrChecksConfig(IDictionary raw)
    {
        List<string> errors = new List<string>();
        if (raw != null) { CheckKeys(raw, AllowedKeys, "adr-checks", errors); }

        engine_neutrality = new AdrNeutralityCheck(Section(raw, "engine_neutrality", errors), "engine_neutrality", errors);
        citation_graph = new AdrCheck(Section(raw, "citation_graph", errors), "citation_graph", errors);
        dora_coverage = new AdrDoraCheck(Section(raw, "dora_coverage", errors), "dora_coverage", errors);

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
