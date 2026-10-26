# pwsh/Base.VSCode/private/Expand-VsCodeRepeat.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Writes each extension command and menu entry that names a repeat once per item of the repeat's source.

### description

The folder generator calls it on an extension's contributes block before the state expansion. The block's `repeat` map declares each source
once: a config (`config`), the list in it (`list`), the item's key (`key`) and title (`title`), with leading items (`first`) and trailing
items (`plus`). An entry naming a source is copied per item in source order, `{<source>}`, `{<source>.title}` and `{<source>.position}`
filled in its strings, and the `repeat` keys are dropped. An entry naming a source the entry does not declare, or a source missing its
config, list or key, is refused.

### parameter `Contributes`

The extension's contributes block as the config declares it.

### outputs

`[System.Collections.Specialized.OrderedDictionary]` The contributes block with every repeating entry written out.

## comment:1

Above `$sources = @{}`, written with `#`.

```text
Each source: the declared leading items, the items of a config's list, then the declared trailing items, as {
value, title, position }.
```
