using System;
using System.Collections.Generic;

namespace Catzc.Base.Maps;

// The highlight section: the reviewed pins that light a cell, the exceptions that keep one dark, and the citation excludes.
public sealed class MapsHighlight
{
    // The session logs and the plans are about the system, not the system, so a citation in them lights nothing.
    public static readonly IReadOnlyList<string> DefaultCitationExclude =
        Array.AsReadOnly(new[] { ".claude/hindsight/**", ".claude/learnings/**", ".claude/plans/**", "docs/**/.assets/**", "docs/explanation/**", "python/diagrams/**" });

    // The cells an ADR always lights, in declared order. Empty by default.
    public IReadOnlyList<MapsPin> pins { get; }

    // The cells an ADR never lights, in declared order. Empty by default.
    public IReadOnlyList<MapsPin> exceptions { get; }

    // The repo-relative globs of the files whose citations light nothing. Default: DefaultCitationExclude.
    public IReadOnlyList<string> citation_exclude { get; }

    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    public MapsHighlight(MapsPin[] pins, MapsPin[] exceptions, string[] citationExclude)
    {
        this.pins = pins == null ? Array.Empty<MapsPin>() : (MapsPin[])pins.Clone();
        this.exceptions = exceptions == null ? Array.Empty<MapsPin>() : (MapsPin[])exceptions.Clone();
        citation_exclude = citationExclude == null ? Array.Empty<string>() : (string[])citationExclude.Clone();
    }
}
