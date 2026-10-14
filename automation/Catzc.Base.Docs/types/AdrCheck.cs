// One ADR check's settings in configs/adr-checks.yml that need nothing beyond their mode: the citation graph of the rule
// summaries, checked by Test-AdrRegistry. Mirrors the YAML mapping (snake_case,
// [ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)); built and validated by AdrChecksConfig.
//   mode — report | gate; default AdrChecksConfig.DefaultMode

using System.Collections;
using System.Collections.Generic;

namespace Catzc.Base.Docs;

public sealed class AdrCheck
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    private static readonly string[] AllowedKeys = { "mode" };

    public AdrCheckMode mode { get; }

    internal AdrCheck(IDictionary raw, string where, List<string> errors)
    {
        mode = AdrChecksConfig.DefaultMode;
        if (raw == null) { return; }
        AdrChecksConfig.CheckKeys(raw, AllowedKeys, where, errors);
        mode = AdrChecksConfig.ParseMode(raw, where, errors);
    }
}
