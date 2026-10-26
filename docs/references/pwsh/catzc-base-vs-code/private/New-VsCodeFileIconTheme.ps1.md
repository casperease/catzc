# pwsh/Base.VSCode/private/New-VsCodeFileIconTheme.ps1

<!-- cspell:ignore Segoe linejoin linecap dasharray -->

The private renderer of the cats file icon theme, its SVGs and its theme JSON, from `file-icons.yml` into an extension's media folder.

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

## Labels

A label's size shrinks with its length so four characters still fit the 16-pixel square. The prompt style underlines it with a console
chevron and a cursor instead of a plain bar.

## Glyphs and languages

A glyph is looked up in the folders of `-GlyphDirectory`, in order: the icon theme's own glyphs (`<glyph>.svg`), then the lamp glyphs
(`<glyph>-on.svg`). An icon's `language` names a language of the languages config; each language's extensions come from there, never
restated in `file-icons.yml`.

## Unmarked files and folders

A file no icon marks is a leaf, one dot. The theme names no folder icon, so a folder is marked by the Explorer's own chevron alone.
