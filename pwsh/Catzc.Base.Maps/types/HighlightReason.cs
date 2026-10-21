/*
---
catzc:
  immutable:
    with_body_sha: "0cee3657a4da"
  edges:
    docs: "[HighlightReason.cs.md](../../../docs/references/pwsh/catzc-base-maps/types/HighlightReason.cs.md)"
    cites:
      - ADR-BCL-TYPES-SNAKECASEMIRRORSYAML
---
*/

using System;
using System.Collections.Generic;

namespace Catzc.Base.Maps;

[Catzc.Base.Objects.ConsoleDisplay(nameof(Path), nameof(Basis), nameof(Requested), nameof(Mention))]
public sealed class HighlightReason
{
    // The lit file; null for a cell a pin alone lights.
    public string Path { get; }

    // A MapPlacement basis, HighlightedCell.SourcePath or HighlightedCell.SourcePin.
    public string Basis { get; }

    // The requested citation that lights the file (the request's own form); null for a requested file.
    public string Requested { get; }

    // The citation sites the request covers, in path then line order; empty for an ADR file, a requested file and a pin.
    public IReadOnlyList<CitationSite> Sites { get; }

    // The reviewed reason of a pin; null otherwise.
    public string Note { get; }

    // True when every covered site is a passing mention (CitationSite.Mention); false when there is no site.
    public bool Mention
    {
        get
        {
            if (Sites.Count == 0) { return false; }
            foreach (CitationSite site in Sites)
            {
                if (!site.Mention) { return false; }
            }
            return true;
        }
    }

    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    public HighlightReason(string path, string basis, string requested, CitationSite[] sites, string note)
    {
        Path = path;
        Basis = basis;
        Requested = requested;
        Sites = sites == null ? Array.Empty<CitationSite>() : (CitationSite[])sites.Clone();
        Note = note;
    }
}
