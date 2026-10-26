# pwsh/Base.Maps/private/Resolve-MinimapGlyphPath.ps1

The helper that resolves a drawing's glyph labels to the tracked files they name, by file name, so a label never carries a path.

## help

### synopsis

Resolves the labels of a drawing's code and file glyphs to the tracked paths they name.

### description

Only a glyph of a code kind (code, private, runner, type) or a file names a repository place. Its label's first line is read as a function
name (`Verb-Noun`, the `.ps1` of that name), a module name (`Catzc.*`, its manifest), a type name (the `.cs` of that name) or a file name,
and resolved against the tracked paths by file name, so a label never carries a path of its own. A label that names no tracked file resolves
to no path.

### parameter `Glyph`

The drawing's glyphs, each `{ kind; label }`.

### parameter `TrackedPath`

Every tracked repository-relative path, the one index a label is resolved against.

### outputs

`[pscustomobject]` one per code or file glyph: its kind, its label and the paths it names.
