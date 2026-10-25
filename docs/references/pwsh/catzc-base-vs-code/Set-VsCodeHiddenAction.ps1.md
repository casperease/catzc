# pwsh/Catzc.Base.VSCode/Set-VsCodeHiddenAction.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Hides the editor actions vscode-settings.yml declares under `hidden_actions`, in VS Code's own hidden-menu state.

### description

The declared command ids join what the editor already hides per menu, and what a user hid by hand stays. The state store is backed up before
it is written, and the editor must be closed, since a running editor writes its in-memory state back on exit. Supports `-WhatIf`.

### parameter `StorePath`

VS Code's state store of the default profile, where its hidden-menu state lives. Default: `Code/User/globalStorage/state.vscdb` under the
user's application data.

### parameter `BackupDirectory`

The folder the state store is copied to before it is written. Default: `vscode-state` under the output root.

### parameter `ProcessName`

The editor's process; the command stops while it runs. Default: `Code`.

### outputs

`[hashtable]` menu id to the command ids hidden there, as written.
