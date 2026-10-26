# pwsh/Base.VSCode/private/Expand-VsCodeCommandState.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Expands each extension command that declares states into one command per state, and its menu items to match.

### description

The folder generator calls it on an extension's contributes block before writing package.json. A command with `states` and `state_context`
keeps its bare name for the default state and gains `<command>.<state>` per state, its icon `<icon>-<state>.svg`; each menu item naming it
is repeated per state with its when clause narrowed by the context key, so exactly one shows. A command with states but no context key is
refused.

### parameter `Contributes`

The extension's contributes block as the config declares it.

### outputs

`[System.Collections.Specialized.OrderedDictionary]` The contributes block with every stated command expanded.

## comment:1

Above `$expanded = [ordered]@{}`, written with `#`.

```text
A command that declares states (and the context key that holds the current one) becomes one command per state: the bare command is
the default state, each other state its own command, '<command>.<state>', with the icon '<icon>-<state>.svg' and its title marked.
Every menu item naming the command is repeated per state, its when narrowed by the context key, so the title row shows exactly one.
```
