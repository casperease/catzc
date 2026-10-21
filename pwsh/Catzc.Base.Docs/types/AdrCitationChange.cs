/*
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.Docs/types/AdrCitationChange.cs
    folder: types
    name: adr-citation-change
    filetype: cs
    role: type
    language: csharp
    track: pwsh
    tracktype: modules
    module: Catzc.Base.Docs
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    docs: "[AdrCitationChange.cs.md](docs/references/pwsh/catzc-base-docs/types/AdrCitationChange.cs.md)"
    cites:
      - ADR-BCL-TYPES-NATIVETYPEDMODEL
---
*/

using System;

namespace Catzc.Base.Docs;

public sealed class AdrCitationChange
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    public string Path { get; }
    public int Line { get; }
    public AdrCitationChangeKind Kind { get; }
    public string Old { get; }
    public string New { get; }

    public AdrCitationChange(string path, int line, AdrCitationChangeKind kind, string old, string replacement)
    {
        if (string.IsNullOrEmpty(path)) { throw new ArgumentException("an ADR citation change requires a path"); }
        if (line < 1) { throw new ArgumentOutOfRangeException(nameof(line), line, "a line number starts at 1"); }
        if (string.IsNullOrEmpty(old)) { throw new ArgumentException("an ADR citation change requires the old text"); }
        if (kind == AdrCitationChangeKind.Unhandled ? replacement != null : replacement == null)
        {
            throw new ArgumentException("an Unhandled change carries no new text, and every other change carries one");
        }

        Path = path;
        Line = line;
        Kind = kind;
        Old = old;
        New = replacement;
    }
}
