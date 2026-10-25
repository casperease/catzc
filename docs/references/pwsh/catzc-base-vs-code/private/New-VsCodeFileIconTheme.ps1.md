# pwsh/Catzc.Base.VSCode/private/New-VsCodeFileIconTheme.ps1

<!-- cspell:ignore Segoe linejoin linecap -->

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Renders the cats file icon theme, its SVGs and its theme JSON, from file-icons.yml into an extension's media folder.

### description

Each icon of file-icons.yml becomes one SVG: a lamp glyph of catzc-track-lamps recoloured, or a generated label underlined by a bar or a
console prompt. The theme maps every extension, file name and language id the icon names, and a language's extensions come from the language
system (languages.yml), except an extension another icon names itself. A file no icon marks takes the plain file icon. A glyph with no lamp
SVG, or a language the language system does not declare, throws. Returns the path of the theme JSON.

### parameter `MediaDirectory`

The extension's media folder; the theme and its SVGs are written into it.

### parameter `Config`

The icons to render. Default: the shipped file-icons config.

### parameter `GlyphDirectory`

The folders an icon's `glyph` is looked up in, in order, as `<glyph>.svg` or `<glyph>-on.svg`. Default: the icon theme's own glyphs, then
the catzc-track-lamps assets.

### parameter `Languages`

The language system's languages, each with its name and extensions. Default: the shipped languages config.

## comment:1

Above `$labelSvg = {`, written with `#`.

```text
A label's size shrinks with its length so four characters still fit the 16-pixel square; the prompt style underlines it with a
console chevron and a cursor instead of a plain bar.
```
