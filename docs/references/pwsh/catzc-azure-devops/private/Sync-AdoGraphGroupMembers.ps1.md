# automation/Catzc.Azure.DevOps/private/Sync-AdoGraphGroupMembers.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Makes the approver group hold exactly the configured members: adds the missing, removes the unlisted.

### description

The second step of the environment-approvals apply. Each configured principal name is resolved to an Azure DevOps user; a name that is not a
user of the organization throws, naming it. The group's current members are read (none for a group a dry run has not created yet), and the
difference is applied: a membership for every configured user the group lacks, and the removal of every member the config does not list.
With `-DryRun` the difference is reported and nothing is written.

### parameter `Context`

The record `Get-AdoGraphContext` returns.

### parameter `Group`

The record `Sync-AdoGraphGroup` returns.

### parameter `Member`

The configured members by principal name.

### parameter `DryRun`

Report the difference without writing it.

### outputs

`[pscustomobject]` { Added = the principal names added; Removed = the descriptors removed }.

### example 1

```powershell
Sync-AdoGraphGroupMembers -Context $context -Group $group -Member 'person@example.com' -DryRun
```
