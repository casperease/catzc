/*
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-maps/types/MapPlacement.cs.md"
  header: "generated"
---
*/

using System;
using System.Collections.Generic;

namespace Catzc.Base.Maps;

// Where one tracked file sits on the world map, exactly by root folder and extension, and what lights it.
[Catzc.Base.Objects.ConsoleDisplay(nameof(Path), nameof(Track), nameof(FileLanguage), nameof(Basis))]
public sealed class MapPlacement
{
    // The file of an ADR (the registry maps the code to it): it lights for its own code only.
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

    // False for a test file, a vendored file, a verification track's file, and a file under no track.
    public bool Live { get; }

    // True when the file is live, has an extension, and its file language is not one its track declares.
    public bool StackViolation { get; }

    // The step that produced the highlight relation: one of the Basis constants.
    public string Basis { get; }

    // The ADR code whose file this is (ADR-<CODE>); null for every other file.
    public string Adr { get; }

    // The ADR citations that light the file, canonical (ADR-<CODE> or ADR-<CODE>#n), distinct, in ordinal order.
    public IReadOnlyList<string> Citations { get; }

    // Where those citations sit: in the file itself, or in its owner's or globset's files; empty when nothing lights it.
    public IReadOnlyList<CitationSite> Sites { get; }

    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    public MapPlacement(string path, string track, string fileLanguage, bool live, bool stackViolation, string basis, string adr,
        string[] citations, CitationSite[] sites = null)
    {
        Path = path;
        Track = track;
        FileLanguage = fileLanguage;
        Live = live;
        StackViolation = stackViolation;
        Basis = basis;
        Adr = adr;
        Citations = citations == null ? Array.Empty<string>() : (string[])citations.Clone();
        Sites = sites == null ? Array.Empty<CitationSite>() : (CitationSite[])sites.Clone();
    }
}
