# automation/Catzc.Azure.DevOps/Sync-AdoEnvironmentApprovals.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Puts an approval check on every prod-tier Azure DevOps environment that environment-approvals.yml lists.

### description

A deploy to a prod-tier environment waits for a person to approve it, so CD never reaches production unattended
([ADR-FLOW-CD](../../../adr/flow/cd-discipline-and-promotion-flow.md)). For each environment the config lists, this finds the environment
and the approver group (`[<project>]\<approver_group>`), reads the environment's checks, and creates the Approval check when it has none,
updates it when its approver or timeout drifted from the config, and leaves it alone otherwise. A missing group or environment throws,
naming it. The approver group and the timeout default on the config type (`Prod Approvers`, 24 hours); the file may override both.

### parameter `Project`

Azure DevOps project name. Defaults to the value in ado.yml.

### parameter `Organization`

Azure DevOps organization URL (`https://dev.azure.com/<org>`). Defaults to the value in ado.yml.

### parameter `DryRun`

Read and report what would change, writing nothing.

### outputs

`[pscustomobject]` One per environment: { Environment; Action = Create | Update | Unchanged; ApproverGroup; TimeoutHours; DryRun }.

### example 1

```powershell
Sync-AdoEnvironmentApprovals -DryRun
```
