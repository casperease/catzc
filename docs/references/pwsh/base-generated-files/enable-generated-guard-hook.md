# pwsh/Base.GeneratedFiles/Enable-GeneratedGuardHook.ps1

The command a user runs to put the generated-files guard in their own clone's pre-commit hook. Nothing in the tree runs it, and no check
depends on the hook it writes.

## help

### synopsis

Writes a pre-commit hook that runs Assert-GeneratedStaysCommitted.

### description

Asks git where the hooks live (`git rev-parse --git-path hooks`), so a clone with `core.hooksPath` works too, and writes a `pre-commit`
shell shim there with LF endings. The shim starts `pwsh -NoProfile`, dot-sources the repository's `importer.ps1` and calls
`Assert-GeneratedStaysCommitted`, so a commit that stages the deletion of a generated file that stays committed stops. The shim carries a
marker line naming catzc's guard. A pre-commit hook without that marker is another tool's and is refused, never overwritten. A shim already
in place with the same body is left as it is, and one of catzc's with a different body is rewritten. With `-WhatIf` the command names the
path and writes nothing.

### parameter `RepositoryRoot`

The clone whose hooks folder is used. Default: the repository root.

### outputs

`[string]` The path of the hook written. Nothing when the shim was already there.

### example 1

```powershell
Enable-GeneratedGuardHook -WhatIf
```

## Why a marker

The marker is how the two commands tell their own shim from a hook a person or another tool put there. It lets `Disable-GeneratedGuardHook`
remove exactly what this command wrote and nothing else.
