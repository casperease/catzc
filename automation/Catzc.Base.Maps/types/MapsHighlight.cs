/*
---
catzc:
  derived:
    path: automation/Catzc.Base.Maps/types/MapsHighlight.cs
    kind: type
    module: Catzc.Base.Maps
    adrs:
      - ADR-AUTO-DEFAULT#6
      - ADR-AUTO-TYPES#8
---
*/

// An excluded file still sits in its world-map cell; only its citations are ignored, so file counts stay true.
// [comment:1](/docs/references/automation/catzc-base-maps/types/MapsHighlight.cs.md#comment1)

using System;
using System.Collections.Generic;

namespace Catzc.Base.Maps;

public sealed class MapsHighlight
{
    // Slide minimaps light the repository's citations of an ADR, never the words of the slides or the tool that drew them.
    // [comment:2](/docs/references/automation/catzc-base-maps/types/MapsHighlight.cs.md#comment2)
    public static readonly IReadOnlyList<string> DefaultCitationExclude =
        Array.AsReadOnly(new[] { "docs/.assets/**", "docs/explanation/**", ".claude/drawio/**" });

    // The cells an ADR always lights, in declared order. Empty by default.
    public IReadOnlyList<MapsPin> pins { get; }

    // The cells an ADR never lights, in declared order. Empty by default.
    public IReadOnlyList<MapsPin> exceptions { get; }

    // Left unset it is DefaultCitationExclude; setting it replaces that list, it does not extend it.
    // [comment:3](/docs/references/automation/catzc-base-maps/types/MapsHighlight.cs.md#comment3)
    public IReadOnlyList<string> citation_exclude { get; }

    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    public MapsHighlight(MapsPin[] pins, MapsPin[] exceptions, string[] citationExclude)
    {
        this.pins = pins == null ? Array.Empty<MapsPin>() : (MapsPin[])pins.Clone();
        this.exceptions = exceptions == null ? Array.Empty<MapsPin>() : (MapsPin[])exceptions.Clone();
        citation_exclude = citationExclude == null ? Array.Empty<string>() : (string[])citationExclude.Clone();
    }
}
