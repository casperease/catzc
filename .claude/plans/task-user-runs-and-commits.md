---
task:
  status: open
  plans: [plan-master]
  value: highest
  blocked_on: nothing; every step is the user's own git operation, edit, run or eye check, and the last is the final session's full run
  targets: [.claude/plans, out, docs]
---

# Task: the user's git steps, one commit, and the one final full run

<!-- cspell:ignore adronly -->

Every step here is one the user does by hand, because agents never run mutating git, never edit `.claude/CLAUDE.md` or
`.claude/settings.json`, and never run all tests (ADR-REPO-AI; `.claude/CLAUDE.md`, No mutating git operations). A check is one test file
under `Invoke-TestFile`, one gate on named paths, a grep or a file read. The one full-repository proof is the last step. The typed DLL under
`pwsh/.compiled` is ignored by every step.

## Steps

1. Commit the working tree, one commit, when the orchestrator says the workers are at rest:
   `pwsh -NoProfile -File out/user/Invoke-UserCommit.ps1 -WhatIf`, then without `-WhatIf`. Before it, `git status --short` lists only paths
   the plans name, with no `??` under `out/` and no `pwsh/.compiled`. After it:
   - `Invoke-TestFile` passes on `pwsh/Base.Slides/tests/Build-Diagrams.Tests.ps1`,
     `pwsh/Azure.Templates/tests/Build-Bicep.Integrity.Tests.ps1`, `pwsh/Base.Git/tests/Push-Topic.Flow.Tests.ps1` and
     `pwsh/Base.QualityGates/tests/Format-Code.Tests.ps1`;
   - `Test-Links` reports no `[Untracked]` issue (the BCL folders, the kebab reference pages, the flat diagram files);
   - `git status` showed the moves under `docs/` as renames, not delete and add pairs;
   - `git ls-files` lists no old case spelling, no `Catzc.` folder under `contracts`, and nothing matching `egg-info|__pycache__` or
     `pwsh/.compiled`;
   - `Test-Contracts` and `Test-BuildArtifact -Facet Types` report no issues;
   - `Test-Formatting` lists no function help hand edit outside Base.Contracts;
   - `Test-Diagrams` reports no issues: the commit carries the two query diagrams re-rendered after the track renames
     (`docs/explanation/model/.assets/zoom-internal-c4.drawio.png`, `docs/explanation/model/.assets/zoom-pwsh-c3.drawio.png`);
   - `Invoke-TestFile -Path pwsh/Base.ModuleSystem/tests/Test-FunctionDependency.Tests.ps1` passes: the commit carries the one-character fix
     at `pwsh/Tooling.Toolchain/private/Install-UvStandalone.ps1:57` (`Get-ChildPath $extractDirectory`);
   - `Test-ManagedGuids` reads 0 issues: the commit tracks `pwsh/Azure/configs/roles.yml` (the role-id registry) and the moved policy GUIDs'
     new home, which clears the registry's coverage and the seven dead `policy_*` entries the uncommitted tree shows.
2. One ci-pwsh pipeline run, now that `.ado/pipelines/steps/cache-types.yaml` is committed (the types cache). Check: the second run of a job
   restores the types cache (Cache@2 "Cache restored") and skips the DLL build.
3. plan-vscode-session-binding: when the PowerShell extension's session hangs again, run `Get-VsCodeSession` in a sibling terminal of the
   hung session and paste its one line to a session. Check: the line names the session's types binding; a day in VS Code without a hang
   closes the plan.
4. The flow lens's live occupants: `Update-AdoFlowOccupants docs/explanation/flow/.assets/ci-pwsh-to-deploy-apex.drawio.yml`, signed in to
   ADO. Check: the file's `about.occupants` names each `apex-<rung>` environment with a commit, and `Build-Diagrams` draws them in the
   rhombi.
5. One ci-infrastructure pipeline run, now that it installs the pinned bicep before `Build-Bicep` (the build no longer goes through
   `az bicep`). Check: the "Install-Bicep" step reports Bicep CLI 0.48 and the three Build-Bicep steps pass.
6. One `Deploy-Bicep` of `foundation` or `expedition` to a non-production slot, now that the resource groups carry the CAF tags. Check:
   `az group show --name <group> --query tags` lists the six CAF keys of the slot's `tags` parameter, and
   `az policy state list --subscription <id> --filter "policyAssignmentName eq '<the slot's -tag-pa name>'" --query "[?complianceState=='NonCompliant'].resourceId"`
   lists no resource. Once the hub firewall is deployed, in a hub slot also check that
   `az network firewall show -g <group> -n <the -afw name> --query "ipConfigurations[0].privateIPAddress"` equals the hub's
   `firewall_private_ip` in network.yml (the derived address the spoke routes use), and try the regional Storage tag (for example
   `Storage.WestEurope`) in the policy's egress rule, confirming storage egress still works, for the open regional-tag step.
7. Optional: the old mixed-case provenance tags (`Deployed_From_Commit`, `_BuildId`, `_Branch`, and `<template>_Deployed_From_*` on a
   subscription) stay on what was deployed before the rename to `deployed-from-*`. List them with
   `az tag list --resource-id /subscriptions/<id>[/resourceGroups/<group>]`, and remove each with
   `az tag update --resource-id <id> --operation Delete --tags "<key>=<its listed value>"`. Check: the `az tag list` shows only lowercase
   keys.
8. One ci-pwsh run on a branch that plants a fake cloud access key in a tracked file. Check: the run fails on the
   `Test-SecretScan (real tree)` integrity test, naming the file and line; delete the branch after.
9. The DORA delivery metrics, live (read-only; the agent could not run it, `az` is not on its PATH, so no sign-in):
   `Get-AdoDeliveryMetrics -Days 90 | Format-Table`, signed in to ADO. Check: one row per deployable unit, each with Deployments and
   DeploymentsPerDay, and LeadTimeHours, ChangeFailRate and RecoveryHours where its production environment saw deployments.
10. Re-run `Test-DependencyAdvisories`: it now reads an advisory's optional `summary` (falling back to `details`), so the scan that threw on
    it completes. Check: the scan completes with its report and findings count.
11. One live break-glass rotation, signed in with `az` to the apex non-production subscription: first
    `Invoke-BreakGlassRotation dev -Customer apex -DryRun` (the agent could not run it, `az` is not on its PATH), then without `-DryRun`;
    then queue `cron-break-glass-rotation` once by hand in ADO. Check: the dry run names the server, vault and secret; the real run reports
    "Rotated the break-glass password"; the secret's version in the vault is new; a sign-in with the new password works; and the login alert
    fires to `owner-alerts` within ten minutes of that sign-in.
12. The service connections, live, signed in to ADO as a project administrator who may create Entra app registrations (the agent could not
    run the dry run or the test, `az` is not on its PATH): `Get-BicepServiceConnections | Sync-AdoServiceConnections -DryRun`, then without
    `-DryRun`; then `Get-BicepServiceConnections | Test-AdoServiceConnections`. Check: the dry run lists the 16 connections
    `Get-BicepServiceConnections` derives from `service-connections.yml` with their actions, the sync reports each `Create`, `Update` or
    `Unchanged`, a CD run still deploys through its connection, and `Test-AdoServiceConnections` reads 0 issues: no connection holds a
    stored secret.
13. The L3 system test, signed in to a non-production subscription (`az login`, then `Set-AzCliSubscription` to it):
    `Invoke-TestFile -Path pwsh/Azure.Templates/tests/Deploy-Bicep.L3.Tests.ps1 -MaxLevel 3`. It deploys each resource-group template's
    non-production base slot on that subscription again as the ephemeral slot `l3`, checks the group's CAF and deployed-from tags, and
    deletes the group. Check: the result reads 0 failures, and `Test-BicepOrphans` then lists no `-l3-` group.
14. Review the stacked role assignments before the first live deploy (read-only; not run by the agent, no sign-in):
    `Get-BicepRoleAssignmentPlan` for discovery (readers, operators with the rbac-administrator condition) and expedition (its three
    data-role assignments). Check: every assignment reads as intended, or the change you want lands as a plan step.
15. The final full run, in a fresh session, when the chunks in plan-master have landed. Once it is green and committed, the work is done and
    every plan, task and prompt in `.claude/plans` is deleted (the user, 2026-10-20). Check: `.claude/plans` is empty.

## Report

As catzc-core's report: which steps the user reported done, with each verdict line.
