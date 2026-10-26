# pwsh/Base.TypesSystem/private/Get-AgentHookName.ps1

The private lister of the agent hooks: each folder under `.claude/hooks/` that holds a `.csproj`, in ordinal order.

## help

### synopsis

Names every agent hook: each folder under .claude/hooks/ that holds a .csproj, in ordinal order.

### description

Build-AgentHook's default set of hooks. The bin/ publish folder is never a hook, and a repository with no .claude/hooks/ folder has none, so
the result is then empty.

### outputs

`[string[]]` the hook folder names.

### example 1

```powershell
Get-AgentHookName
```
