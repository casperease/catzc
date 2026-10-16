/*
---
catzc:
  immutable:
    path: automation/Catzc.Base.Variants/types/VariantTrack.cs
    folder: types
    name: variant-track
    filetype: cs
    kind: type
    language: csharp
    track: automation
    module: Catzc.Base.Variants
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    page: docs/references/automation/catzc-base-variants/types/VariantTrack.cs.md
    cites:
      - ADR-AUTO-TYPES#8
      - ADR-DSGN-TRACK
---
*/

using System;
using System.Collections.Generic;

namespace Catzc.Base.Variants;

public sealed class VariantTrack
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    // The track's name: its key in the `tracks` map (e.g. automation).
    public string name { get; }

    // The places the track covers: repository-relative paths with '/' separators (e.g. automation, .github/workflows).
    public IReadOnlyList<string> places { get; }

    // The track's type: the id of a track type of the track-types registry ([ADR-DSGN-TRACKTYPE#1](/docs/adr/design/track-types.md#rule-adr-dsgn-tracktype1)).
    public string type { get; }

    // The vendor that reads the track's files, or null when the track has none.
    public string vendor { get; }

    public IReadOnlyList<string> languages { get; }

    public VariantTrack(string name, string[] places, string type, string vendor, string[] languages)
    {
        this.name = name;
        this.places = places == null ? Array.Empty<string>() : (string[])places.Clone();
        this.type = type;
        this.vendor = string.IsNullOrEmpty(vendor) ? null : vendor;
        this.languages = languages == null ? Array.Empty<string>() : (string[])languages.Clone();
    }

    // The length of the longest place that contains a '/'-separated repository-relative path, or -1 when none does.
    public int PlaceLengthOf(string path)
    {
        int best = -1;
        foreach (string place in places)
        {
            bool contains = path == place || path.StartsWith(place + "/", StringComparison.Ordinal);
            if (contains && place.Length > best) { best = place.Length; }
        }
        return best;
    }
}
