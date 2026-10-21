/*
---
catzc:
  immutable:
    with_body_sha: bcdf726db869
  edges:
    docs: "[MapsHighlight.cs.md](docs/references/pwsh/catzc-base-maps/types/MapsHighlight.cs.md)"
    cites:
      - ADR-AUTO-DEFAULT-ONERESOLUTIONORDER
      - ADR-BCL-TYPES-SNAKECASEMIRRORSYAML
---
*/

using System;
using System.Collections.Generic;

namespace Catzc.Base.Maps;

public sealed class MapsHighlight
{
    public static readonly IReadOnlyList<string> DefaultCitationExclude =
        Array.AsReadOnly(new[] { "docs/.assets/**", "docs/explanation/**", "python/catzc_diagrams/**" });

    // The cells an ADR always lights, in declared order. Empty by default.
    public IReadOnlyList<MapsPin> pins { get; }

    // The cells an ADR never lights, in declared order. Empty by default.
    public IReadOnlyList<MapsPin> exceptions { get; }

    public IReadOnlyList<string> citation_exclude { get; }

    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    public MapsHighlight(MapsPin[] pins, MapsPin[] exceptions, string[] citationExclude)
    {
        this.pins = pins == null ? Array.Empty<MapsPin>() : (MapsPin[])pins.Clone();
        this.exceptions = exceptions == null ? Array.Empty<MapsPin>() : (MapsPin[])exceptions.Clone();
        citation_exclude = citationExclude == null ? Array.Empty<string>() : (string[])citationExclude.Clone();
    }
}
