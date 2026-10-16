/*
---
catzc:
  derived:
    path: automation/Catzc.Base.Variants/types/VariantTrack.cs
    kind: csharp-type
    module: Catzc.Base.Variants
    relatives:
      page: docs/references/automation/catzc-base-variants/types/VariantTrack.cs.md
    adrs:
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

    // The closed set of track classes ([ADR-DSGN-TRACK#2](/docs/adr/design/tracks.md#rule-adr-dsgn-track2)).
    public static readonly string[] Classes = { "core", "adapter", "external-port", "verification", "unordered" };

    // The track's name: its key in the `tracks` map (e.g. automation).
    public string name { get; }

    // The root folder the track maps onto: one repository-relative segment (e.g. automation, .github).
    public string root { get; }

    // The track's class: one of Classes.
    public string @class { get; }

    public IReadOnlyList<string> languages { get; }

    public VariantTrack(string name, string root, string trackClass, string[] languages)
    {
        this.name = name;
        this.root = root;
        @class = trackClass;
        this.languages = languages == null ? Array.Empty<string>() : (string[])languages.Clone();
    }
}
