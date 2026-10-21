/*
---
catzc:
  immutable:
    with_body_sha: ef54e430acd6
  edges:
    docs: "[DrsCitationChange.cs.md](../../../docs/references/pwsh/catzc-base-drs/types/DrsCitationChange.cs.md)"
    cites:
      - ADR-BCL-TYPES-NATIVETYPEDMODEL
---
*/

using System;

namespace Catzc.Base.Drs;

public sealed class DrsCitationChange
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    public string Path { get; }
    public int Line { get; }
    public DrsCitationChangeKind Kind { get; }
    public string Old { get; }
    public string New { get; }

    public DrsCitationChange(string path, int line, DrsCitationChangeKind kind, string old, string replacement)
    {
        if (string.IsNullOrEmpty(path)) { throw new ArgumentException("an ADR citation change requires a path"); }
        if (line < 1) { throw new ArgumentOutOfRangeException(nameof(line), line, "a line number starts at 1"); }
        if (string.IsNullOrEmpty(old)) { throw new ArgumentException("an ADR citation change requires the old text"); }
        if (kind == DrsCitationChangeKind.Unhandled ? replacement != null : replacement == null)
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
