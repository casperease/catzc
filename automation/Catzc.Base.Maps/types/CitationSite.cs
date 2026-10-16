/*
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.Maps/types/CitationSite.cs
    folder: types
    name: citation-site
    filetype: cs
    kind: type
    language: csharp
    track: automation
    tracktype: modules
    module: Catzc.Base.Maps
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    page: docs/references/automation/catzc-base-maps/types/CitationSite.cs.md
    cites:
      - ADR-AUTO-TYPES#8
---
*/

namespace Catzc.Base.Maps;

[Catzc.Base.Objects.ConsoleDisplay(nameof(Path), nameof(Line), nameof(Kind), nameof(Citation))]
public sealed class CitationSite
{
    // The file's header: a PowerShell comment-based help block, or the comment block a C# or YAML file opens with.
    public const string KindHelp = "help";

    // A comment after the header: a body comment, or a trailing comment on a line of code or YAML.
    public const string KindComment = "comment";

    // Anything else: markdown prose, code, a YAML value.
    public const string KindText = "text";

    // The repository-relative, '/'-separated path of the citing file.
    public string Path { get; }

    // The 1-based line of the citation.
    public int Line { get; }

    // KindHelp, KindComment or KindText.
    public string Kind { get; }

    // The canonical citation: ADR-<CODE> or ADR-<CODE>#n.
    public string Citation { get; }

    // True when the site is a passing mention: a comment after the file's header.
    public bool Mention => Kind == KindComment;

    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    public CitationSite(string path, int line, string kind, string citation)
    {
        Path = path;
        Line = line;
        Kind = kind;
        Citation = citation;
    }
}
