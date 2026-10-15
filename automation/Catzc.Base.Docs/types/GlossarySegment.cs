// catzc:
//   path: automation/Catzc.Base.Docs/types/GlossarySegment.cs
//   module: Catzc.Base.Docs

// Code and mentions are blanked to spaces, not removed, so a match's offset still maps back to its source line.
// [comment:1](/docs/references/automation/catzc-base-docs/types/GlossarySegment.cs.md#comment1)

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
