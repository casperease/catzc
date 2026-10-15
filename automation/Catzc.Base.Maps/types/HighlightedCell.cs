// Touched is true only when every reason is a passing mention, so a cell lit by mentions alone is told apart.
// [ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)
// [comment:1](/docs/references/automation/catzc-base-maps/types/HighlightedCell.cs.md#comment1)

using System;
using System.Collections.Generic;

namespace Catzc.Base.Maps;

[Catzc.Base.Objects.ConsoleDisplay(nameof(Track), nameof(FileLanguage), nameof(FileCount), nameof(Sources))]
public sealed class HighlightedCell
{
    // The source of a cell lit by a requested file.
    public const string SourcePath = "path";

    // The source of a cell lit by a reviewed pin.
    public const string SourcePin = "pin";

    // The row: a track name, or WorldMap.NoTrack.
    public string Track { get; }

    // The column: a file-language name, or WorldMap.NoFileLanguage.
    public string FileLanguage { get; }

    // The lit files of the cell, in ordinal order. Empty for a cell a pin alone lights.
    public IReadOnlyList<string> Files { get; }

    // The steps that lit the cell, distinct, in ordinal order.
    public IReadOnlyList<string> Sources { get; }

    // Why each lit file (and a pin) lights the cell, in file order then request order (HighlightReason).
    public IReadOnlyList<HighlightReason> Reasons { get; }

    // The number of lit files.
    public int FileCount => Files.Count;

    // True when every reason is a passing mention: the cell is touched, not the subject.
    public bool Touched
    {
        get
        {
            if (Reasons.Count == 0) { return false; }
            foreach (HighlightReason reason in Reasons)
            {
                if (!reason.Mention) { return false; }
            }
            return true;
        }
    }

    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    public HighlightedCell(string track, string fileLanguage, string[] files, string[] sources, HighlightReason[] reasons = null)
    {
        Track = track;
        FileLanguage = fileLanguage;
        Files = files == null ? Array.Empty<string>() : (string[])files.Clone();
        Sources = sources == null ? Array.Empty<string>() : (string[])sources.Clone();
        Reasons = reasons == null ? Array.Empty<HighlightReason>() : (HighlightReason[])reasons.Clone();
    }
}
