// One reviewed highlight entry of configs/maps.yml (an item of `highlight.pins` or `highlight.exceptions`): an ADR code
// (optionally one rule of it, the code followed by #n), the cell it names (a track and a file language), and why it was reviewed. A pin
// lights the cell for the ADR; an exception keeps the cell dark although the ADR's citations would light it (a passing
// mention). The properties mirror the YAML keys, so they are snake_case
// ([ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)). MapsConfig validates
// the shape; whether the track and the file language exist is checked against their registries where the map is
// built.

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
