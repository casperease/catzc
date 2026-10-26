# pwsh/Base.VSCode/private/Resolve-LampPaletteShade.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Replaces every lamp-palette reference in a settings or manifest tree with the hex of the shade it names.

### description

A string `palette.<range>.<shade>` becomes that shade of lamp-palette.yml, and `palette.<range>.<shade>/<aa>` becomes the shade with its
alpha set to `<aa>`, so a colour in vscode-settings.yml or vscode-extensions.yml changes in one line of the palette. Maps and lists are
walked; every other value is returned unchanged. An unknown range or shade throws.

### parameter `InputObject`

The tree to resolve: a map, a list, or a single value.

### parameter `Palette`

The lamp palette to resolve against. Default: the shipped lamp-palette config, read on the first reference only.

## comment:1

Above `[AllowNull()]`, written with `#`.

```text
A settings or manifest tree; every string 'palette.<range>.<shade>' in it, optionally '/<aa>' to set the
alpha, becomes its hex.
```
