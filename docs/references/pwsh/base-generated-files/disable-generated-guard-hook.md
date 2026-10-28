# pwsh/Base.GeneratedFiles/Disable-GeneratedGuardHook.ps1

The command that takes the generated-files guard out of a clone's pre-commit hook again. It removes only the shim
`Enable-GeneratedGuardHook` wrote.

## help

### synopsis

Removes the pre-commit hook that Enable-GeneratedGuardHook wrote.

### description

Finds the `pre-commit` hook the same way `Enable-GeneratedGuardHook` does and deletes it when it carries catzc's marker line. A hook without
the marker is another tool's and is refused, so it stays. When no pre-commit hook exists the command does nothing. With `-WhatIf` the
command names the path and deletes nothing.

### parameter `RepositoryRoot`

The clone whose hooks folder is used. Default: the repository root.

### outputs

`[string]` The path of the hook removed. Nothing when there was none.

### example 1

```powershell
Disable-GeneratedGuardHook -WhatIf
```
