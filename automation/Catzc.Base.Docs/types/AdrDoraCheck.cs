// The DORA-coverage check's settings (configs/adr-checks.yml, dora_coverage), read by Test-AdrRegistry: every rule set of a
// domain has exactly one section linking its ADR in the domain's DORA file (the authoring conventions of the ADR index). Mirrors
// the YAML mapping (snake_case, [ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)); built
// and validated by AdrChecksConfig.
//   mode   — report | gate; default AdrChecksConfig.DefaultMode
//   file   — the DORA file's name inside each domain folder; default DefaultFile
//   exempt — a map of domain name to the reason it keeps no DORA file
//            ([ADR-PRIN-CONFIG#4](/docs/adr/principles/configure-not-program.md#rule-adr-prin-config4)); default none

using System.Collections;
using System.Collections.Generic;

namespace Catzc.Base.Docs;

public sealed class AdrDoraCheck
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    public const string DefaultFile = "dora-explains.md";

    private static readonly string[] AllowedKeys = { "mode", "file", "exempt" };

    public AdrCheckMode mode { get; }
    public string file { get; }
    public IReadOnlyDictionary<string, string> exempt { get; }

    internal AdrDoraCheck(IDictionary raw, string where, List<string> errors)
    {
        mode = AdrChecksConfig.DefaultMode;
        file = DefaultFile;
        Dictionary<string, string> exemptMap = new Dictionary<string, string>(System.StringComparer.Ordinal);
        exempt = exemptMap;
        if (raw == null) { return; }

        AdrChecksConfig.CheckKeys(raw, AllowedKeys, where, errors);
        mode = AdrChecksConfig.ParseMode(raw, where, errors);

        if (raw.Contains("file") && raw["file"] != null)
        {
            string value = raw["file"].ToString();
            if (!value.EndsWith(".md", System.StringComparison.Ordinal) || value.IndexOfAny(new[] { '/', '\\' }) >= 0)
            {
                errors.Add(string.Format("{0}: file '{1}' must be a markdown file name, with no folder", where, value));
            }
            else
            {
                file = value;
            }
        }

        if (raw.Contains("exempt") && raw["exempt"] != null)
        {
            IDictionary map = raw["exempt"] as IDictionary;
            if (map == null)
            {
                errors.Add(string.Format("{0}: exempt must be a map of domain name to reason", where));
                return;
            }
            foreach (DictionaryEntry entry in map)
            {
                string domain = entry.Key == null ? string.Empty : entry.Key.ToString();
                string reason = entry.Value == null ? null : entry.Value.ToString();
                if (string.IsNullOrWhiteSpace(reason))
                {
                    errors.Add(string.Format("{0}: exempt domain '{1}' needs a reason", where, domain));
                    continue;
                }
                exemptMap[domain] = reason.Trim();
            }
        }
    }
}
