/*
---
catzc:
  derived:
    path: automation/Catzc.Base.Maps/types/HighlightReason.cs
    kind: type
    language: csharp
    filetype: cs
    track: automation
    module: Catzc.Base.Maps
    moduletype: pwsh-folder-module
    bundle: azure
    relatives:
      page: docs/references/automation/catzc-base-maps/types/HighlightReason.cs.md
    adrs:
      - ADR-AUTO-TYPES#8
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
