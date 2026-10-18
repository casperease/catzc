# pwsh/Catzc.Azure.DevOps/Sync-AdoEnvironmentApprovals.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Applies environment-approvals.yml to Azure DevOps: the approver group, its members, and one Approval check per prod-tier environment.

### description

A deploy to a prod-tier environment waits for a person to approve it, so CD never reaches production unattended
([ADR-FLOW-CD](../../../adr/flow/cd-discipline-and-promotion-flow.md)). The config is the truth and this apply makes the organization match
it, in a fixed order: the group `[<project>]\<approver_group.name>` is created when missing; its members are made exactly the configured
principal names, adding the missing and removing the unlisted; and each listed environment gets one Approval check by that group with the
configured timeout, created, updated or left alone. An empty member list is refused before any call, and a missing environment or an unknown
member throws, naming it. The group name and the timeout default on the config type (`Prod Approvers`, 24 hours). The procedure is
[Apply the prod-tier approvals](../../../how-to/automation/apply-environment-approvals.md).

### parameter `Project`

Azure DevOps project name. Defaults to the value in ado.yml.

### parameter `Organization`

Azure DevOps organization URL (`https://dev.azure.com/<org>`). Defaults to the value in ado.yml.

### parameter `DryRun`

Read and report what the apply would change, writing nothing.

### outputs

`[pscustomobject]` One for the group, then one per environment: { Kind = Group | Check; Target; Action = Create | Update | Unchanged;
Details; DryRun }.

### example 1

```powershell
Sync-AdoEnvironmentApprovals -DryRun
```
