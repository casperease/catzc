// The source checks Test-SourceConventions runs beside its naming and one-function conventions
// (configs/source-conventions.yml), and the single declaration of their sensible defaults
// ([ADR-AUTO-DEFAULT#6](/docs/adr/automation/sensible-defaults.md#rule-adr-auto-default6)):
//   engine_set    — the engine set is never restated: no literal engine list in code, no partial or miscounted engine
//                   set in prose ([ADR-AUTO-ENGINE#1](/docs/adr/automation/execution-engines.md#rule-adr-auto-engine1));
//                   an EngineSetCheck
//   neutral_codes — a logic (L0) test's fixture data uses neutral ADR codes, never a code the ADR index declares
//                   ([ADR-AUTO-TEST#3](/docs/adr/automation/test-automation.md#rule-adr-auto-test3)); a SourceCheck
// An omitted check takes every default of its type: gate mode, nothing exempt, no phrases. Property names mirror the
// YAML keys (snake_case, [ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)).

using System;
using System.Collections;
using System.Globalization;

namespace Catzc.Base.QualityGates;

public sealed class SourceConventionsConfig
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    public EngineSetCheck engine_set { get; }
    public SourceCheck neutral_codes { get; }

    public SourceConventionsConfig(IDictionary raw)
    {
        if (raw != null)
        {
            foreach (object key in raw.Keys)
            {
                string name = Convert.ToString(key, CultureInfo.InvariantCulture);
                if (name != "engine_set" && name != "neutral_codes")
                {
                    throw new ArgumentException(string.Format(CultureInfo.InvariantCulture,
                        "source-conventions config: unknown key '{0}' (allowed: engine_set, neutral_codes)", name));
                }
            }
        }
        engine_set = new EngineSetCheck(Section(raw, "engine_set"));
        neutral_codes = new SourceCheck("neutral_codes", Section(raw, "neutral_codes"));
    }

    static IDictionary Section(IDictionary raw, string key)
    {
        if (raw == null || !raw.Contains(key) || raw[key] == null) { return null; }
        return raw[key] as IDictionary ?? throw new ArgumentException(string.Format(CultureInfo.InvariantCulture,
            "source-conventions config: {0} must be a map (mode, exempt, …)", key));
    }
}
