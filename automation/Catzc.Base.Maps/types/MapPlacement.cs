// Where one tracked file sits on the world map, and what lights it. The cell is exact: the root folder gives the track
// and the extension gives the file language. The highlight relation follows the fixed order per artifact kind that
// WorldMapBuilder applies: an ADR file carries its domain; every other file carries ADR citations, and Basis names the
// step that produced them. A result type, so the properties are PascalCase
// ([ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)).

using System;
using System.Collections.Generic;

namespace Catzc.Base.Maps;

[Catzc.Base.Objects.ConsoleDisplay(nameof(Path), nameof(Track), nameof(FileLanguage), nameof(Basis))]
public sealed class MapPlacement
{
    // An ADR file under docs/adr/: it lights for every code of its domain.
    public const string BasisAdrFile = "adr-file";

    // The file's own citations.
    public const string BasisCitations = "citations";

    // A repository-root file: the citations of the module files.yml names as its owner.
    public const string BasisFilesYml = "files.yml";

    // A pipeline that cites nothing: the citations of the files of the globset whose pipeline key names it.
    public const string BasisGlobSet = "globset";

    // Nothing lights the file.
    public const string BasisNone = "none";

    // The repository-relative, '/'-separated path, as the git index lists it.
    public string Path { get; }

    // The row: a track name, or WorldMap.NoTrack.
    public string Track { get; }

    // The column: a file-language name, or WorldMap.NoFileLanguage.
    public string FileLanguage { get; }

    // True when the file is in its track's live aspect; false for a test file, a vendored file, a file of a
    // verification track, and a file under no track.
    public bool Live { get; }

    // True when the file is live, has an extension, and its file language is not one its track declares.
    public bool StackViolation { get; }

    // The step that produced the highlight relation: one of the Basis constants.
    public string Basis { get; }

    // The ADR domain an ADR file belongs to; null for every other file.
    public string Domain { get; }

    // The ADR citations that light the file, canonical (ADR-<CODE> or ADR-<CODE>#n), distinct, in ordinal order.
    public IReadOnlyList<string> Citations { get; }

    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    public MapPlacement(string path, string track, string fileLanguage, bool live, bool stackViolation, string basis, string domain,
        string[] citations)
    {
        Path = path;
        Track = track;
        FileLanguage = fileLanguage;
        Live = live;
        StackViolation = stackViolation;
        Basis = basis;
        Domain = domain;
        Citations = citations == null ? Array.Empty<string>() : (string[])citations.Clone();
    }
}
