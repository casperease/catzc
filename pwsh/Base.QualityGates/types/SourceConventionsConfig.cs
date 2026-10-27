using System;
using System.Collections;
using System.Globalization;

namespace Catzc.Base.QualityGates;

// The source checks beside naming and one-function, with their defaults declared once.
public sealed class SourceConventionsConfig
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    public EngineSetCheck engine_set { get; }
    public SourceCheck neutral_codes { get; }

    // The files that may spell the modules track's place; NoTrackRootLiteral reads it.
    public SourceCheck track_root_literal { get; }

    // The test files a module keeps for a subject that is no one function (a template, a feature, a carrier file), each with its reason.
    public SourceCheck test_file_name { get; }

    public SourceConventionsConfig(IDictionary raw)
    {
        if (raw != null)
        {
            foreach (object key in raw.Keys)
            {
                string name = Convert.ToString(key, CultureInfo.InvariantCulture);
                if (name != "engine_set" && name != "neutral_codes" && name != "track_root_literal" && name != "test_file_name")
                {
                    throw new ArgumentException(string.Format(CultureInfo.InvariantCulture,
                        "source-conventions config: unknown key '{0}' (allowed: engine_set, neutral_codes, track_root_literal, test_file_name)", name));
                }
            }
        }
        engine_set = new EngineSetCheck(Section(raw, "engine_set"));
        neutral_codes = new SourceCheck("neutral_codes", Section(raw, "neutral_codes"));
        track_root_literal = new SourceCheck("track_root_literal", Section(raw, "track_root_literal"));
        test_file_name = new SourceCheck("test_file_name", Section(raw, "test_file_name"));
    }

    static IDictionary Section(IDictionary raw, string key)
    {
        if (raw == null || !raw.Contains(key) || raw[key] == null) { return null; }
        return raw[key] as IDictionary ?? throw new ArgumentException(string.Format(CultureInfo.InvariantCulture,
            "source-conventions config: {0} must be a map (mode, exempt, …)", key));
    }
}
