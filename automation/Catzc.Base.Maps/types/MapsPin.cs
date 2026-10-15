// One reviewed highlight entry of configs/maps.yml (an item of `highlight.pins` or `highlight.exceptions`): an ADR code (optionally one...
// [ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)
// [comment:1](/docs/references/automation/catzc-base-maps/types/MapsPin.cs.md#comment1)

namespace Catzc.Base.Maps;

[Catzc.Base.Objects.ConsoleDisplay(nameof(adr), nameof(track), nameof(file_language))]
public sealed class MapsPin
{
    // The ADR code, or one rule of it (an index code, or that code with #3 for its third rule).
    public string adr { get; }

    // The cell's track: a key of the `tracks` map in variants.yml (e.g. automation, .github).
    public string track { get; }

    // The cell's file language: a key of the registry in languages.yml (e.g. powershell).
    public string file_language { get; }

    // Why the entry was reviewed: one line, required.
    public string reason { get; }

    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    public MapsPin(string adr, string track, string fileLanguage, string reason)
    {
        this.adr = adr;
        this.track = track;
        file_language = fileLanguage;
        this.reason = reason;
    }
}
