// The world-map highlight settings (the `highlight` section of configs/maps.yml): the reviewed pins, which light a cell for an ADR, the...
// [ADR-AUTO-DEFAULT#6](/docs/adr/automation/sensible-defaults.md#rule-adr-auto-default6),
// [ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)
// [comment:1](/docs/references/automation/catzc-base-maps/types/MapsHighlight.cs.md#comment1)

using System;
using System.Collections.Generic;

namespace Catzc.Base.Maps;

public sealed class MapsHighlight
{
    // The files whose citations light nothing by default: the generated slide descriptions and every other asset, the explanation...
    // [comment:2](/docs/references/automation/catzc-base-maps/types/MapsHighlight.cs.md#comment2)
    public static readonly IReadOnlyList<string> DefaultCitationExclude =
        Array.AsReadOnly(new[] { "docs/.assets/**", "docs/explanation/**", ".claude/drawio/**" });

    // The cells an ADR always lights, in declared order. Empty by default.
    public IReadOnlyList<MapsPin> pins { get; }

    // The cells an ADR never lights, in declared order. Empty by default.
    public IReadOnlyList<MapsPin> exceptions { get; }

    // The globs (repository-relative, '/'-separated) of the files whose citations light nothing.
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
