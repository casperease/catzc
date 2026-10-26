# pwsh/Azure.DevOps/types/EnvironmentApprovalsConfig.cs

The typed record for `environment-approvals.yml`, which `Sync-AdoEnvironmentApprovals` applies. Constructing it validates the file and fills
the defaults: the approver group name and description, and the timeout.

## Environments

`Environments(rungs)` lists the Azure DevOps environments that carry the approval check: `<unit>-<rung>` for every unit and every rung
behind a release gate (RC, RBC), then the prod-tier environments. The rung names come from the rungs registry, so the environment names
follow it. The apply creates an environment that does not exist yet.
