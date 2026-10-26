# pwsh/Base.Slides/private/Get-NameMentionFinding.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

The lines of a diagram or slide whose picture names the system by its code name or its conversational name, one finding per line.

### description

A picture says what a thing is, not what the system is called. A word `catzc` or `cats` standing alone, in any case, is a finding; a name
joined into an identifier (a module, a folder, a command such as `Get-CatzcModuleRoot`) is no mention. A line naming both draws the contrast
between them and is no finding. The head is meta, never the picture: a front-matter block at the top is skipped, and so is a `#` comment
line in a file that is not markdown. A path slides.yml's `name_mentions` lists is a declared contrast and yields nothing.

### parameter `Path`

The file the text is from, as the findings name it.

### parameter `Text`

The file's text, which may be empty.

### parameter `Exempt`

The paths whose mentions are a declared contrast, from slides.yml's `name_mentions`; each names its reason there.

### outputs

`[string[]]` One finding per line, `<path>:<line>: names <name> in the picture; ...`, saying how to fix it.

### example 1

```powershell
Get-NameMentionFinding -Path docs/explanation/widget/.assets/widget-flow.drawio.yml -Text (Get-Content -Raw docs/explanation/widget/.assets/widget-flow.drawio.yml)
```

## comment:1

Above `[CmdletBinding()]`, written with `#`.

```text
The lines of a diagram declaration or a slide that name catzc or cats as a word
([DDR-VISUAL-NONAMEINPICTURE](/docs/drs/design/visual-design.md#rule-ddr-visual-nonameinpicture)).
```
