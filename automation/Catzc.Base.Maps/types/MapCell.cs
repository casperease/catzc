/*
---
catzc:
  immutable:
    path: automation/Catzc.Base.Maps/types/MapCell.cs
    folder: types
    name: map-cell
    filetype: cs
    kind: type
    language: csharp
    track: automation
    tracktype: modules
    module: Catzc.Base.Maps
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    page: docs/references/automation/catzc-base-maps/types/MapCell.cs.md
    cites:
      - ADR-AUTO-TYPES#8
      - ADR-DSGN-TRACK#{1,3,6}
---
*/

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
