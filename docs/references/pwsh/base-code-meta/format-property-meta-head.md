# pwsh/Base.CodeMeta/Format-PropertyMetaHead.ps1

The formatter's entry point for a meta block that lives in a property rather than a comment: a JSON file or an MSBuild project. It takes the
whole text and the facts and returns the text with the property written first, or the text as it was when the file is neither carrier or the
property holds something foreign. The work is pure text on `Catzc.Base.CodeMeta.PropertyHead`.

## help

### synopsis

Returns a JSON text or an MSBuild project with its meta property imprinted from the given facts.

### description

The block is the text of one property, in either carrier: in a JSON file an ignored top-level member, in an XML file whose root is an
MSBuild project a CDATA property named for the block inside the first PropertyGroup labelled catzc. The same facts always give the same
bytes, so a second run changes no file (ADR-REPO-FILEMETA-JSONCARRIER). A text that is neither, or whose property holds something else,
comes back as it was.

### parameter `Text`

The whole JSON file or MSBuild project as text.

### parameter `Property`

The name of the property that holds the block (e.g. // or $comment in JSON, CatzcMeta in a project).

### parameter `Strip`

Beginnings of old values of the property that are replaced.

### parameter `Immutable`

The place facts, an ordered dictionary of key to value.

### parameter `Edges`

The outgoing edges, an ordered dictionary of edge name to value; no facts and no edges removes the property.

### outputs

`[string]` the whole text, with the property written first.

### example 1

```powershell
Format-PropertyMetaHead -Text $text -Property '//' -Immutable ([ordered]@{ path = 'widget/gadget.json'; kind = 'other' })
```
