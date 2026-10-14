// One piece of prose the glossary checks read (G4, G6): the surface it comes from (markdown, comments, help, messages),
// the line it starts on, and its text with code and mentions blanked to spaces so a match's offset still maps to its
// line. GlossaryProse produces them; GlossaryScan reads them.

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
