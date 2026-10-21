/*
---
catzc:
  immutable:
    with_body_sha: a71cabc0828b
  edges:
    test: pwsh/Catzc.Base.Reports/tests/types/CheckModes.Tests.ps1
    docs: "[CheckModes.cs.md](../../../docs/references/pwsh/catzc-base-reports/types/CheckModes.cs.md)"
    cites:
      - ADR-AUTO-DEFAULT-ONERESOLUTIONORDER
      - PDR-ONELIVE-ONEVERSION
---
*/

using System;
using System.Collections;
using System.Globalization;

namespace Catzc.Base.Reports;

public static class CheckModes
{
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
