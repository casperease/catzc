# pwsh/Azure.DevOps/private/Sync-AdoEnvironmentCheck.ps1

The private function that keeps one Approval check on one Azure DevOps environment, with the configured approver and timeout.

## help

### synopsis

Keeps one Approval check on one Azure DevOps environment, with the configured approver and timeout.

### description

The third step of the environment-approvals apply, once per environment. It finds the environment by name and creates it when it does not
exist, so an RC or RBC gate's environment carries its check before any pipeline deploys there. It reads the checks of an environment that
existed and picks the Approval check by its well-known check-type id (`ado_approval_check_type` in guids.yml). It creates the check when
there is none, updates it when its approver or timeout differs from the config, and leaves it alone otherwise. With `-DryRun` both actions
are reported and nothing is written, so a dry run needs no approver id yet.

### parameter `Context`

The record `Get-AdoGraphContext` returns.

### parameter `Environment`

The Azure DevOps environment name.

### parameter `ApproverId`

The approver group's identity id; empty only in a dry run before the group exists.

### parameter `TimeoutMinutes`

How long a pending approval waits, in minutes.

### parameter `DryRun`

Report the action without writing it.

### outputs

`[pscustomobject]` `Environment`, the environment's action (Create or Unchanged), and `Check`, the check's action (Create, Update or
Unchanged).

### example 1

```powershell
Sync-AdoEnvironmentCheck -Context $context -Environment 'shared-psub' -ApproverId $group.IdentityId -TimeoutMinutes 1440
```
