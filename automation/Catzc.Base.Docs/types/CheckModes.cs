// catzc:
//   path: automation/Catzc.Base.Docs/types/CheckModes.cs
//   module: Catzc.Base.Docs

// One parser keeps one accepted spelling and one error text for every check config, and an omitted mode means Gate.
// [ADR-PRIN-ONELIVE#1](/docs/adr/principles/one-living-version.md#rule-adr-prin-onelive1),
// [ADR-AUTO-DEFAULT#6](/docs/adr/automation/sensible-defaults.md#rule-adr-auto-default6)
// [comment:1](/docs/references/automation/catzc-base-docs/types/CheckModes.cs.md#comment1)

using System;
using System.Collections;
using System.Globalization;

namespace Catzc.Base.Docs;

public static class CheckModes
{
    // An unknown mode name does not throw: it yields Gate and sets error, so the caller reports the one message itself.
    // [comment:2](/docs/references/automation/catzc-base-docs/types/CheckModes.cs.md#comment2)
    public static CheckMode Parse(IDictionary raw, out string error)
    {
        error = null;
        if (raw == null || !raw.Contains("mode") || raw["mode"] == null) { return default(CheckMode); }
        string value = Convert.ToString(raw["mode"], CultureInfo.InvariantCulture);
        foreach (CheckMode candidate in Enum.GetValues(typeof(CheckMode)))
        {
            if (string.Equals(candidate.ToString(), value, StringComparison.OrdinalIgnoreCase)) { return candidate; }
        }
        error = string.Format(CultureInfo.InvariantCulture, "mode '{0}' is not one of: {1}", value,
            string.Join(", ", Enum.GetNames(typeof(CheckMode))).ToLowerInvariant());
        return default(CheckMode);
    }
}
