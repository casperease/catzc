/*
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-quality-gates/types/SourceConventionsConfig.cs.md"
  header: "generated"
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

    public SourceCheck track_root_literal { get; }

    public SourceConventionsConfig(IDictionary raw)
    {
        if (raw != null)
        {
            foreach (object key in raw.Keys)
            {
                string name = Convert.ToString(key, CultureInfo.InvariantCulture);
                if (name != "engine_set" && name != "neutral_codes" && name != "track_root_literal")
                {
                    throw new ArgumentException(string.Format(CultureInfo.InvariantCulture,
                        "source-conventions config: unknown key '{0}' (allowed: engine_set, neutral_codes, track_root_literal)", name));
                }
            }
        }
        engine_set = new EngineSetCheck(Section(raw, "engine_set"));
        neutral_codes = new SourceCheck("neutral_codes", Section(raw, "neutral_codes"));
        track_root_literal = new SourceCheck("track_root_literal", Section(raw, "track_root_literal"));
    }

    static IDictionary Section(IDictionary raw, string key)
    {
        if (raw == null || !raw.Contains(key) || raw[key] == null) { return null; }
        return raw[key] as IDictionary ?? throw new ArgumentException(string.Format(CultureInfo.InvariantCulture,
            "source-conventions config: {0} must be a map (mode, exempt, …)", key));
    }
}
