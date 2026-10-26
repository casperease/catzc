using System.Collections;
using System.Collections.Generic;

using Catzc.Base.Reports;

namespace Catzc.Base.Drs;

// One drs-checks.yml check that needs nothing beyond its mode: the rule summaries' citation graph, checked by Test-DrsRegistry.
public sealed class DrsCheck
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    private static readonly string[] AllowedKeys = { "mode", "exempt" };

    public CheckMode mode { get; }

    // The domains whose own citations the check does not hold to their dependencies, each with its reason.
    public IReadOnlyDictionary<string, string> exempt { get; }

    internal DrsCheck(IDictionary raw, string where, List<string> errors)
    {
        mode = default(CheckMode);
        Dictionary<string, string> exemptMap = new Dictionary<string, string>(System.StringComparer.Ordinal);
        exempt = exemptMap;
        if (raw == null) { return; }
        DrsChecksConfig.CheckKeys(raw, AllowedKeys, where, errors);
        mode = DrsChecksConfig.ParseMode(raw, where, errors);

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
