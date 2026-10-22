# pwsh/Catzc.Base.TypesSystem/private/Get-AgentHookName.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Names every agent hook: each folder under .claude/hooks/ that holds a .csproj, in ordinal order.

### description

Build-AgentHook's default set of hooks. The bin/ publish folder is never a hook, and a repository with no .claude/hooks/ folder has none,
so the result is then empty.

### outputs

`[string[]]` the hook folder names.

### example 1

```powershell
Get-AgentHookName
```
