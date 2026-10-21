# Apply the prod-tier approvals

A CD run must not reach a prod-tier environment unattended, and a commit climbs past the RC and RBC gates only when a person certifies it
([FDR-CD](../../adr/flow/cd-discipline-and-promotion-flow.md)). Every prod-tier Azure DevOps environment, and each unit's `release-uat`
(RC) and `pre-prod` (RBC) environment, therefore carries one **Approval** check, approved by one **approver group** of named people. All of
it is declared in one config, `pwsh/Catzc.Azure.DevOps/configs/environment-approvals.yml`, and one command applies the config to Azure
DevOps. Nothing is set by hand in the Azure DevOps portal: the config is the truth, and the apply makes the organization match it.

The approval itself runs in the execution engine: Azure DevOps holds the checks on its environments, and pipelines and service connections
can carry approvals of their own. cats ships the config and the apply so that a team adopting it builds its approval flow from one file; a
team runs the apply against its own organization, with its own approvers.

## The config

```yaml
approver_group:
  name: Prod Approvers # the group inside the ado.yml project: [<project>]\Prod Approvers
  description: ... # optional; written when the apply creates the group
  members: # principal names; the group holds exactly these after an apply
    - person@example.com
timeout_hours: 24 # how long a pending approval waits, 1 to 720
units: # each unit's release-gate environments, <unit>-<rung> for the rungs behind rc and rbc
  - shared
  - apex
prod_environments: # the prod tier, named by its deploy target
  - shared-psub
  - apex-psub
  - apex-prod
```

`name` defaults to `Prod Approvers` and `timeout_hours` to 24, both declared once on the config type (`EnvironmentApprovalsConfig`).
`members` has no default, and the apply refuses an empty list, because an approval nobody can give blocks every prod-tier deploy. The
shipped config lists the example principal `prod-approver@example.com`; replace it with your approvers before the first apply. The
organization and project come from `ado.yml`.

## Apply it

1. Edit `environment-approvals.yml`: list the approvers' principal names, the units whose release gates need approval, and the prod-tier
   environments.
2. Load cats and connect to the organization (a PAT in `$env:AZURE_DEVOPS_PAT`, or `Connect-AzCli` in the ado.yml tenant).
3. Preview the apply:

   ```powershell
   Sync-AdoEnvironmentApprovals -DryRun
   ```

   It reads the organization and reports, without writing anything, one record for the group and one per environment, each with its action:
   `Create`, `Update` or `Unchanged`.

4. Run the same command without `-DryRun`.

The apply works in a fixed order, and each step reads the organization before it writes:

1. **The group.** It finds `[<project>]\<name>` among the project's groups and creates it when it is missing.
2. **The members.** It resolves each configured member to an Azure DevOps user, adds the ones the group lacks, and removes every member the
   config does not list.
3. **The checks.** For each environment, it creates the environment when it does not exist yet (reported as an `Environment` record), then
   creates the Approval check when there is none, updates it when its approver or timeout differs from the config, and leaves it alone
   otherwise.

An approver who is not a user of the organization, or an organization URL that is not `https://dev.azure.com/<org>`, stops the apply with a
message naming it.

## Run it again

The apply is deterministic: the same config against the same organization makes the same changes, and a second run reports `Unchanged` for
the group and every check, with no member added or removed. Run it after every change to `environment-approvals.yml`, and whenever the
organization may have drifted, such as after someone edited a check in the portal.
