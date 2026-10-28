# pwsh/Base.GeneratedFiles/Restore-Generated.ps1

The command that rolls the generated files back on: it runs the writers of the rollable files that are missing or stale, in the order the
registry's input and output graph derives. Which writers exist, their class and their order come from the registry alone
(`Get-GeneratedWriterOrder`), never from a file's head.

## help

### synopsis

Runs the writers of the missing or stale rollable generated files, in graph order.

### description

Only a writer of the class `rollable` runs; `import-critical`, `snapshot` and `untracked` writers are never rolled. Each writer is asked
`Get-GeneratedWriterDue` right before its turn, so a writer that reads what an earlier one has just written sees that change. A due writer
is run as a command of the session, then its input stamp is stored with `Save-GeneratedWriterStamp`. A due writer that is no command of the
session throws. Paired with `Remove-Generated`, a clean round trip leaves `git status` without a change.

### parameter `Name`

The writers to roll on, as the writer rows name them. Default: every rollable writer.

### parameter `RepositoryRoot`

The root a missing output is looked for under. Default: the repository root.

### parameter `MemoPath`

The memo of the stamps each writer stored after its last run. Default: out/cache/generated-writers.json.

### outputs

`[string]` The name of each writer that ran, in the order it ran.

### example 1

```powershell
Restore-Generated -WhatIf
```

## Why the writers are asked one at a time

The registry's order puts a writer after the writers that produce its inputs. Asking for every writer's due state up front would judge a
downstream writer before its inputs were rendered back; asking right before each run judges it on the files as they then are.
