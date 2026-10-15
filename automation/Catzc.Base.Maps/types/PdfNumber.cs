/*
---
catzc:
  derived:
    path: automation/Catzc.Base.Maps/types/PdfNumber.cs
    kind: csharp-type
    module: Catzc.Base.Maps
    relatives:
      page: docs/references/automation/catzc-base-maps/types/PdfNumber.cs.md
      test: automation/Catzc.Base.Maps/tests/types/PdfNumber.Tests.ps1
---
*/

using System;
using System.Globalization;

namespace Catzc.Base.Maps;

public static class PdfNumber
{
    // The text of a finite number, rounded to three decimals. NaN and the infinities have no PDF form and throw.
    public static string Format(double value)
    {
        if (double.IsNaN(value) || double.IsInfinity(value))
        {
            throw new ArgumentOutOfRangeException(nameof(value), value, "A PDF number must be finite.");
        }
        double rounded = Math.Round(value, 3, MidpointRounding.AwayFromZero);
        if (rounded == 0) { rounded = 0; }
        return rounded.ToString("0.###", CultureInfo.InvariantCulture);
    }
}
