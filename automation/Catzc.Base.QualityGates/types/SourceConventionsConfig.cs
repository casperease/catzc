/*
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/types/SourceConventionsConfig.cs
    kind: type
    language: csharp
    filekind: cs
    track: automation
    module: Catzc.Base.QualityGates
    relatives:
      page: docs/references/automation/catzc-base-qualitygates/types/SourceConventionsConfig.cs.md
      test: automation/Catzc.Base.QualityGates/tests/types/SourceConventionsConfig.Tests.ps1
    adrs:
      - ADR-AUTO-DEFAULT#6
      - ADR-AUTO-ENGINE#1
      - ADR-AUTO-TEST#3
      - ADR-AUTO-TYPES#8
---
*/

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
