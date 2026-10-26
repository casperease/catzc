# pwsh/Base.VSCode/private/Expand-VsCodeRepeat.ps1

The private expander that writes each extension command and menu entry naming a repeat once per item of the repeat's list.

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

## The item lists

Each repeat's list is the declared leading items, the items of a config's list, then the declared trailing items, each as
`{ value, title, position }`.
