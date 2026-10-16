/*
---
catzc:
  immutable:
    path: automation/Catzc.Base.QualityGates/types/LinkFinding.cs
    folder: types
    name: link-finding
    filetype: cs
    kind: type
    language: csharp
    track: automation
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    page: docs/references/automation/catzc-base-qualitygates/types/LinkFinding.cs.md
---
*/

using System.Globalization;

namespace Catzc.Base.QualityGates;

public sealed class LinkFinding
{
    public string File { get; }
    public int Line { get; }
    public int Column { get; }
    public LinkKind Kind { get; }
    public LinkFindingType Type { get; }
    public string Message { get; }
    public string Fix { get; }

    // Fixable when the aligner has a replacement for it.
    public bool IsFixable => !string.IsNullOrEmpty(Fix);

    // A violation fails Test-Links; Overlong is information only.
    public bool IsViolation => Type != LinkFindingType.Overlong;

    public LinkFinding(string file, int line, int column, LinkKind kind, LinkFindingType type, string message, string fix)
    {
        File = file;
        Line = line;
        Column = column;
        Kind = kind;
        Type = type;
        Message = message ?? string.Empty;
        Fix = fix ?? string.Empty;
    }

    public override string ToString() =>
        string.Format(CultureInfo.InvariantCulture, "{0}:{1}:{2} [{3}] {4}", File, Line, Column, Type, Message);
}
