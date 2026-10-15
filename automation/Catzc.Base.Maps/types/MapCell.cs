/*
---
catzc:
  derived:
    path: automation/Catzc.Base.Maps/types/MapCell.cs
    kind: type
    module: Catzc.Base.Maps
---
*/

// The cell only carries the stack-violation result: WorldMapBuilder decides it per file, never the cell itself.
// [ADR-DSGN-TRACK#1](/docs/adr/design/tracks.md#rule-adr-dsgn-track1), [ADR-DSGN-TRACK#6](/docs/adr/design/tracks.md#rule-adr-dsgn-track6),
// [ADR-DSGN-TRACK#3](/docs/adr/design/tracks.md#rule-adr-dsgn-track3),
// [ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)
// [comment:1](/docs/references/automation/catzc-base-maps/types/MapCell.cs.md#comment1)

namespace Catzc.Base.Maps;

[Catzc.Base.Objects.ConsoleDisplay(nameof(Track), nameof(FileLanguage), nameof(FileCount), nameof(StackViolation))]
public sealed class MapCell
{
    // The row: a track name, or WorldMap.NoTrack for the files under no track.
    public string Track { get; }

    // The column: a file-language name, or WorldMap.NoFileLanguage for the files no file language names.
    public string FileLanguage { get; }

    // The tracked files placed in the cell. Zero for an empty cell of the grid.
    public int FileCount { get; }

    // True when at least one live file of the cell is outside its track's declared file languages.
    public bool StackViolation { get; }

    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    public MapCell(string track, string fileLanguage, int fileCount, bool stackViolation)
    {
        Track = track;
        FileLanguage = fileLanguage;
        FileCount = fileCount;
        StackViolation = stackViolation;
    }
}
