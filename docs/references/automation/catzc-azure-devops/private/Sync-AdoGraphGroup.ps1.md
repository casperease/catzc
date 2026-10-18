# automation/Catzc.Azure.DevOps/private/Sync-AdoGraphGroup.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Makes sure the approver group exists in the project, creating it when it is missing.

### description

The first step of the environment-approvals apply. It lists the project's groups and finds the group by its display name; when there is
none, it creates it with the configured description. A group that exists is left as it is: the description is written at creation only. With
`-DryRun` a missing group is reported as `Create` and nothing is written, so the result carries no descriptor or identity yet.

### parameter `Context`

The record `Get-AdoGraphContext` returns.

### parameter `Name`

The group's display name inside the project, from `environment-approvals.yml`.

### parameter `Description`

The description written when the group is created.

### parameter `DryRun`

Report the action without creating anything.

### outputs

`[pscustomobject]` { Action = Create | Unchanged; Name; Descriptor; IdentityId }; the identity id is the approver id the checks name.

### example 1

```powershell
Sync-AdoGraphGroup -Context $context -Name 'Prod Approvers' -Description 'Approves prod-tier deploys' -DryRun
```
