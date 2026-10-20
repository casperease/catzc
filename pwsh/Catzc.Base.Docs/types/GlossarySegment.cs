/*
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.Docs/types/GlossarySegment.cs
    folder: types
    name: glossary-segment
    filetype: cs
    role: type
    language: csharp
    track: pwsh
    tracktype: modules
    module: Catzc.Base.Docs
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    docs: "[GlossarySegment.cs.md](docs/references/pwsh/catzc-base-docs/types/GlossarySegment.cs.md)"
---
*/

namespace Catzc.Base.Docs;

public sealed class GlossarySegment
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    // markdown | comments | help | messages — the surfaces a glossary source's options can select.
    public string Surface { get; }

    // The 1-based line the text starts on.
    public int Line { get; }

    // The prose, mentions and code blanked to spaces (line breaks kept).
    public string Text { get; }

    public GlossarySegment(string surface, int line, string text)
    {
        Surface = surface;
        Line = line;
        Text = text ?? string.Empty;
    }
}
