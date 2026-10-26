# pwsh/Azure.DevOps/configs/environment-approvals.yml

The approval checks that `Sync-AdoEnvironmentApprovals` applies to Azure DevOps environments, mirrored by the `EnvironmentApprovalsConfig`
type. The how-to [apply environment approvals](../../../../how-to/automation/apply-environment-approvals.md) walks the apply.

## Keys

- **`approver_group`** — the group's `name`, optional `description` and its `members`; the apply makes the group hold exactly these members.
- **`timeout_hours`** — how long a pending approval waits before the run times out, 24 when the key is absent; at most 720, Azure DevOps'
  own ceiling of 30 days.
- **`units`** — the units whose release-gate rungs carry the RC and RBC checks, as `<unit>-<rung>` environments for the rungs the rungs
  registry puts behind those gates.
- **`prod_environments`** — the prod-tier environments, listed here because the prod tier is named by its deploy target (the subscription or
  the configuration slot), not by a rung.

The apply creates an environment that does not exist yet.
