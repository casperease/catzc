# pwsh/Base.Maps/private/Resolve-MapLabelTerm.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Returns the glossary term a printed map label names, or nothing when it names none.

### description

A label names the concept it prints in its head: the text before its first ':', trimmed ('World map' in 'World map: repository tree'), or
the whole label when it has no ':'. The head resolves when, compared without case, it is a term of -Term or that term's plural (the term
followed by 's' or 'es': 'Root files' names the term 'root file'). Every label the world map or the value-chain map prints names a defined
term in its head ([DDR-TRACK-LABELSNAMEDEFINEDTERMS](../../../../drs/design/tracks.md#rule-ddr-track-labelsnamedefinedterms),
[DDR-TRACK-VALUECHAINMAP](../../../../drs/design/tracks.md#rule-ddr-track-valuechainmap)), so Test-WorldMap and Test-ValueChainMap report a
label this returns nothing for.

### parameter `Label`

The printed label.

### parameter `Term`

The glossary terms (Get-Glossary), lower-case as the glossary declares them.

### outputs

`[string]` The term the label names; nothing when it names none.

### example 1

```powershell
Resolve-MapLabelTerm -Label 'Root files' -Term (Get-Glossary | ForEach-Object { $_.Concept.term })
```
