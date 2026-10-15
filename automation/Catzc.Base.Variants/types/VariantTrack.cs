// One track of the `tracks` variant (configs/variants.yml, ): a named repository root concern, its root folder, its class from the...
// [ADR-DSGN-TRACK](/docs/adr/design/tracks.md), [ADR-DSGN-TRACK#6](/docs/adr/design/tracks.md#rule-adr-dsgn-track6),
// [ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)
// [comment:1](/docs/references/automation/catzc-base-variants/types/VariantTrack.cs.md#comment1)

using System;
using System.Collections.Generic;

namespace Catzc.Base.Variants;

public sealed class VariantTrack
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    // The closed set of track classes ([ADR-DSGN-TRACK#2](/docs/adr/design/tracks.md#rule-adr-dsgn-track2)).
    public static readonly string[] Classes = { "core", "adapter", "external-port", "verification" };

    // The track's name: its key in the `tracks` map (e.g. automation).
    public string name { get; }

    // The root folder the track maps onto: one repository-relative segment (e.g. automation, .github).
    public string root { get; }

    // The track's class: one of Classes.
    public string @class { get; }

    // The file-language names of the track's declared tech-stack, in declared order.
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
