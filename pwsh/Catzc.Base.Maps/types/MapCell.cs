/*
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.Maps/types/MapCell.cs
    folder: types
    name: map-cell
    filetype: cs
    role: type
    language: csharp
    track: pwsh
    tracktype: modules
    module: Catzc.Base.Maps
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    docs: "[MapCell.cs.md](docs/references/pwsh/catzc-base-maps/types/MapCell.cs.md)"
    cites:
      - ADR-BCL-TYPES-SNAKECASEMIRRORSYAML
      - ADR-DSGN-TRACK-TRACKISPLACEDCLUSTER
      - ADR-DSGN-TRACK-ONETECHSTACK
      - ADR-DSGN-TRACK-FILELANGUAGE
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
