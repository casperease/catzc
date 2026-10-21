/*
---
catzc:
  immutable:
    with_body_sha: b4a9ecb20874
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
    // The session logs are about the system, not the system, so a citation in them lights nothing.
    public static readonly IReadOnlyList<string> DefaultCitationExclude =
        Array.AsReadOnly(new[] { ".claude/hindsight/**", ".claude/learnings/**", "docs/.assets/**", "docs/explanation/**", "python/catzc_diagrams/**" });

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
