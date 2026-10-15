/*
---
catzc:
  derived:
    path: automation/Catzc.Base.Maps/types/MapPlacement.cs
    kind: type
    module: Catzc.Base.Maps
    adrs:
      - ADR-AUTO-TYPES#8
---
*/

// The cell is exact (root folder gives the track, extension the file language); only the lighting follows a fixed order.
// [comment:1](/docs/references/automation/catzc-base-maps/types/MapPlacement.cs.md#comment1)

using System;
using System.Collections.Generic;

namespace Catzc.Base.Maps;

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

    // False for test, vendored, verification-track and trackless files, so only live files can break a track's tech-stack.
    // [comment:2](/docs/references/automation/catzc-base-maps/types/MapPlacement.cs.md#comment2)
    public bool Live { get; }

    // True when the file is live, has an extension, and its file language is not one its track declares.
    public bool StackViolation { get; }

    // The step that produced the highlight relation: one of the Basis constants.
    public string Basis { get; }

    // The ADR code whose file this is (ADR-<CODE>); null for every other file.
    public string Adr { get; }

    // The ADR citations that light the file, canonical (ADR-<CODE> or ADR-<CODE>#n), distinct, in ordinal order.
    public IReadOnlyList<string> Citations { get; }

    // For files.yml and globset bases the sites sit in the owner's or globset's files, not in this file; empty for an ADR file.
    // [comment:3](/docs/references/automation/catzc-base-maps/types/MapPlacement.cs.md#comment3)
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
