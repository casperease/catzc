# pwsh/Base.Docs/types/GlossarySegment.cs

One piece of prose the glossary checks read (G4, G6): the surface it comes from (markdown, comments, help, messages), the line it starts on,
and its text with code and mentions blanked to spaces so a match's offset still maps to its line. [GlossaryProse](GlossaryProse.cs.md)
produces them; [GlossaryScan](GlossaryScan.cs.md) reads them.
