# pwsh/Base.Slides/private/Get-DiagramImageReference.ps1

The reader of reference-style image definitions that point at a diagram: it maps each label to the diagram's name.

## help

### synopsis

The reference-style image definitions of a markdown text that point at a diagram, by label.

### description

A page may embed a diagram by reference (`![Widget flow][widget-flow]`) with the definition elsewhere:
`[widget-flow]: .assets/widget-flow.drawio.png`. Each such definition, indented by at most three spaces and pointing at a `.drawio.png`
directly in the page's `.assets/` folder (with or without a leading `./`), maps its label, lower-cased as markdown matches labels, to the
diagram's name. Other definitions are left out.

### parameter `Text`

The markdown text, which may be empty.

### outputs

`[hashtable]` Label to diagram name, empty when the text defines none.

### example 1

```powershell
Get-DiagramImageReference -Text (Get-Content -Raw docs/explanation/widget/index.md)
```
