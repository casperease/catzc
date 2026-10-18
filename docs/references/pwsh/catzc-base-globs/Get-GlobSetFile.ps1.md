# automation/Catzc.Base.Globs/Get-GlobSetFile.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Returns the tracked files a globset matches — the deployable unit's actual members.

### description

Intersects the matching universe (`git ls-files`, [ADR-FLOW-CD-GLOBS#4](../../../adr/flow/durable-sha-globs.md#rule-adr-flow-cd-globs4))
with the named globset's membership (include minus exclude), ordinally sorted — the exact file list the durable SHA is computed over
([ADR-FLOW-CD-GLOBS#5](../../../adr/flow/durable-sha-globs.md#rule-adr-flow-cd-globs5)). A member may be missing on disk (an unstaged
deletion); it is still a member here.

### parameter `Name`

The globset whose members to list.

### example 1

```powershell
Get-GlobSetFile -Name automation
```
