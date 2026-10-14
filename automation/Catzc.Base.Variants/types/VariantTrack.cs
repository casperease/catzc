// One track of the `tracks` variant (configs/variants.yml, [ADR-DSGN-TRACK](/docs/adr/design/tracks.md)): a named
// repository root concern, its root folder, its class from the taxonomy, and the file languages its tech-stack is
// declared as ([ADR-DSGN-TRACK#6](/docs/adr/design/tracks.md#rule-adr-dsgn-track6)). The entry's fields mirror the
// YAML keys, so the properties are snake_case
// ([ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)); `name` is the entry's
// YAML key. VariantsConfig validates the entry and builds one; Get-Track returns them.

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

    // The file-language names of the track's declared tech-stack, in declared order. Empty when the track declares
    // none. The names are not resolved here: the file-language registry lives in Catzc.Base.Languages.
    public IReadOnlyList<string> languages { get; }

    public VariantTrack(string name, string root, string trackClass, string[] languages)
    {
        this.name = name;
        this.root = root;
        @class = trackClass;
        this.languages = languages == null ? Array.Empty<string>() : (string[])languages.Clone();
    }
}
