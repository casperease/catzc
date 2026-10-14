// The one parser of a check's mode setting (CheckMode), shared by every check config: adr-checks.yml in Catzc.Base.Docs, and
// links.yml and source-conventions.yml in Catzc.Base.QualityGates. One parser keeps one accepted spelling and one error text
// ([ADR-PRIN-ONELIVE#1](/docs/adr/principles/one-living-version.md#rule-adr-prin-onelive1)). An omitted mode is
// default(CheckMode), Gate, the default CheckMode declares once
// ([ADR-AUTO-DEFAULT#6](/docs/adr/automation/sensible-defaults.md#rule-adr-auto-default6)).

using System;
using System.Collections;
using System.Globalization;

namespace Catzc.Base.Docs;

public static class CheckModes
{
    // The mode under the 'mode' key of a check's settings map, matched by name, case-insensitively; raw may be null. An
    // omitted or null mode is default(CheckMode). A value that names no mode returns default(CheckMode) and sets error to
    // the one message for it; otherwise error is null.
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
