# pwsh/Base.Slides/private/Get-DiagramImageReference.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

The reference-style image definitions of a markdown text that point at a diagram, by label.

### description

A page may embed a diagram by reference (`![Widget flow][widget-flow]`) with the definition elsewhere: `[widget-flow]: .assets/widget-flow.drawio.png`.
Each such definition, indented by at most three spaces and pointing at a `.drawio.png` directly in the page's `.assets/` folder (with or
without a leading `./`), maps its label, lower-cased as markdown matches labels, to the diagram's name. Other definitions are left out.

### parameter `Text`

The markdown text, which may be empty.

### outputs

`[hashtable]` Label to diagram name, empty when the text defines none.

### example 1

```powershell
Get-DiagramImageReference -Text (Get-Content -Raw docs/explanation/widget/index.md)
```

## comment:1

Above `$references = @{}`, written with `#`.

```text
A page's reference definitions that point at a diagram beside it: label, case-folded as markdown folds it, to the
diagram's name.
```
