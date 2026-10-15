/*
---
catzc:
  derived:
    path: automation/Catzc.Base.Maps/types/PdfFont.cs
    kind: type
    module: Catzc.Base.Maps
    adrs: []
---
*/

// Base-14 fonts need no embedded font program, so the output stays small and deterministic, at the price of WinAnsi-only text.
// [comment:1](/docs/references/automation/catzc-base-maps/types/PdfFont.cs.md#comment1)

namespace Catzc.Base.Maps;

public enum PdfFont
{
    Helvetica,
    HelveticaBold,
}
