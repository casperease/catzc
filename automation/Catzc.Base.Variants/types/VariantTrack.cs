/*
---
catzc:
  derived:
    path: automation/Catzc.Base.Variants/types/VariantTrack.cs
    kind: type
    module: Catzc.Base.Variants
    adrs:
      - ADR-AUTO-TYPES#8
      - ADR-DSGN-TRACK
      - ADR-DSGN-TRACK#2
      - ADR-DSGN-TRACK#6
---
*/

// Fields mirror the YAML keys, so the properties are snake_case; name is the entry's own YAML key.
// [comment:1](/docs/references/automation/catzc-base-variants/types/VariantTrack.cs.md#comment1)

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

    // Empty when none are declared; names are not resolved here, the registry lives in Catzc.Base.Languages.
    // [comment:2](/docs/references/automation/catzc-base-variants/types/VariantTrack.cs.md#comment2)
    public IReadOnlyList<string> languages { get; }

    public VariantTrack(string name, string root, string trackClass, string[] languages)
    {
        this.name = name;
        this.root = root;
        @class = trackClass;
        this.languages = languages == null ? Array.Empty<string>() : (string[])languages.Clone();
    }
}
