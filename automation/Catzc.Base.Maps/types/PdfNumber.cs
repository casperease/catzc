/*
---
catzc:
  derived:
    path: automation/Catzc.Base.Maps/types/PdfNumber.cs
    kind: type
    module: Catzc.Base.Maps
---
*/

// Invariant culture and no exponent, so the same value gives the same bytes in any session; a PDF number has no exponent form.
// [comment:1](/docs/references/automation/catzc-base-maps/types/PdfNumber.cs.md#comment1)

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
