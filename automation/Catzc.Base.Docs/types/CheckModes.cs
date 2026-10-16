/*
---
catzc:
  derived:
    path: automation/Catzc.Base.Docs/types/CheckModes.cs
    kind: csharp-type
    language: csharp
    track: automation
    module: Catzc.Base.Docs
    relatives:
      page: docs/references/automation/catzc-base-docs/types/CheckModes.cs.md
      test: automation/Catzc.Base.Docs/tests/types/CheckModes.Tests.ps1
    adrs:
      - ADR-AUTO-DEFAULT#6
      - ADR-PRIN-ONELIVE#1
---
*/

using System;
using System.Collections;
using System.Globalization;

namespace Catzc.Base.Docs;

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
