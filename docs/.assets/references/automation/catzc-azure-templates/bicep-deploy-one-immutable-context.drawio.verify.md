---
catzc:
  derived:
    path: docs/.assets/references/automation/catzc-azure-templates/bicep-deploy-one-immutable-context.drawio.verify.md
    kind: asset-description
    language: markdown
    track: docs
    body_sha: "01650c9e3e09"
    adrs:
      - ADR-PWSH-DRYRUN#1
---

# out/diagrams/wave-9/catzc-azure-templates/bicep-deploy-one-immutable-context.drawio.verify.md

`Verification: One immutable context, resolved from the az session (source lens, Catzc.Azure.Templates)`

Every line below was re-read on 2026-10-15 after the comment export; none of the scout's line numbers is reused (for example the context
call moved from `Deploy-Bicep.ps1:98` to `:75`, and the `Set-BicepTrackingTagSet` call from `:242` to `:214`). `condense-comments` may move
them again, so re-grep before landing. Paths are relative to `automation/Catzc.Azure.Templates/` unless they start with `automation/` or
`docs/`.

## Boxes

| #   | Claim (box)                                                                                                               | Source (`file:line`)                                                                                                                                   | Status    |
| --- | ------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------ | --------- |
| B1  | `Deploy-Bicep` is a public function (code unit)                                                                           | `Deploy-Bicep.ps1:34`, module root                                                                                                                     | confirmed |
| B2  | `Get-BicepDeploymentContext` is a public function (code unit), not private                                                | `Get-BicepDeploymentContext.ps1:27`, module root                                                                                                       | confirmed |
| B3  | `Get-AzCliSessionSubscription` lives in `Catzc.Azure.Cli` (catzc module frame)                                            | `automation/Catzc.Azure.Cli/Get-AzCliSessionSubscription.ps1:17`                                                                                       | confirmed |
| B4  | `Get-AzureEnvironment` lives in `Catzc.Azure` (catzc module frame)                                                        | `automation/Catzc.Azure/Get-AzureEnvironment.ps1:19`                                                                                                   | confirmed |
| B5  | `Build-Bicep` is a public function of this module                                                                         | `Build-Bicep.ps1:26`                                                                                                                                   | confirmed |
| B6  | `BicepDeploymentPlan` is a C# type: sealed, get-only (template, name, mode, target, resource_group)                       | `types/BicepDeploymentPlan.cs:8,13-27`                                                                                                                 | confirmed |
| B7  | `BicepArtifacts` is a C# type: sealed, get-only (did_local_build, folder, template_file, parameters_file, prepost_module) | `types/BicepArtifacts.cs:8,13-27`                                                                                                                      | confirmed |
| B8  | `BicepDeploymentContext` is a C# type: sealed, get-only `deployment`, `artifacts`, `environment`                          | `types/BicepDeploymentContext.cs:8,13,16,19,21`                                                                                                        | confirmed |
| B9  | The context's `environment` is the immutable `Catzc.Azure.AzureEnvironment`                                               | `types/BicepDeploymentContext.cs:19`; `automation/Catzc.Azure/types/AzureEnvironment.cs:8,13-25`; `automation/Catzc.Azure/Get-AzureEnvironment.ps1:40` | confirmed |
| B10 | `Invoke-AzCli` lives in `Catzc.Azure.Cli` and runs `az` through `Invoke-Executable`                                       | `automation/Catzc.Azure.Cli/Invoke-AzCli.ps1:49`                                                                                                       | confirmed |
| B11 | `Set-BicepTrackingTagSet` is a public function of this module                                                             | `Set-BicepTrackingTagSet.ps1:15`                                                                                                                       | confirmed |

## Edges (flow: calls)

| #   | Edge                                                                           | Call site (`file:line`)                                                          | Status    |
| --- | ------------------------------------------------------------------------------ | -------------------------------------------------------------------------------- | --------- |
| E1  | `Deploy-Bicep` → `Get-BicepDeploymentContext`                                  | `Deploy-Bicep.ps1:75`                                                            | confirmed |
| E2  | `Get-BicepDeploymentContext` → `Get-AzCliSessionSubscription`                  | `Get-BicepDeploymentContext.ps1:83`                                              | confirmed |
| E3  | `Get-BicepDeploymentContext` → `Get-AzureEnvironment`                          | `Get-BicepDeploymentContext.ps1:107` (`-Subscription` = the session's name, :90) | confirmed |
| E4  | `Get-BicepDeploymentContext` → `Build-Bicep` (devbox, no `-DoNotRebuild`)      | `Get-BicepDeploymentContext.ps1:127-134`                                         | confirmed |
| E5  | `Get-BicepDeploymentContext` → the three C# types (`::new`)                    | `Get-BicepDeploymentContext.ps1:148,163,170`                                     | confirmed |
| E6  | `Build-Bicep` → `Invoke-AzCli` (`bicep build`)                                 | `Build-Bicep.ps1:144`                                                            | confirmed |
| E7  | `Deploy-Bicep` → `Invoke-AzCli` (`--what-if` under `-DryRun`, else the create) | `Deploy-Bicep.ps1:180,192`                                                       | confirmed |
| E8  | `Deploy-Bicep` → `Set-BicepTrackingTagSet`                                     | `Deploy-Bicep.ps1:214`                                                           | confirmed |
| E9  | `Set-BicepTrackingTagSet` → `Get-AzCliSessionSubscription`                     | `Set-BicepTrackingTagSet.ps1:45`                                                 | confirmed |
| E10 | `Set-BicepTrackingTagSet` → `Get-AzureEnvironment`                             | `Set-BicepTrackingTagSet.ps1:46`                                                 | confirmed |
| E11 | `Set-BicepTrackingTagSet` → `Invoke-AzCli`                                     | `Set-BicepTrackingTagSet.ps1:95`                                                 | confirmed |

No edge is drawn from `Get-AzCliSessionSubscription` to `Invoke-AzCli`: the call goes through `Get-CurrentAzSubscription`
(`automation/Catzc.Azure.Cli/Get-AzCliSessionSubscription.ps1:21`, `Get-CurrentAzSubscription.ps1:19`), which is not drawn.

## Bands, markers and brief claims

| #   | Claim                                                                                                                                  | Source (`file:line`)                                                                                                                                                                                                                                        | Status       |
| --- | -------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------ |
| C1  | A pipeline deploy without `-SubscriptionIdAssertIs` throws before anything resolves                                                    | `Deploy-Bicep.ps1:69-71`; `docs/adr/azure/azure-data-model.md:59-61`                                                                                                                                                                                        | confirmed    |
| C2  | The session's subscription is reverse-resolved against `azure.yml`; undeclared or duplicate ids throw                                  | `automation/Catzc.Azure.Cli/Get-AzCliSessionSubscription.ps1:21-30`                                                                                                                                                                                         | confirmed    |
| C3  | `-SubscriptionIdAssertIs` is checked against the session's id inside the context                                                       | `Get-BicepDeploymentContext.ps1:84-89`                                                                                                                                                                                                                      | confirmed    |
| C4  | `Get-AzureEnvironment` reads `azure.yml` and returns an `AzureEnvironment`                                                             | `automation/Catzc.Azure/Get-AzureEnvironment.ps1:33,40`                                                                                                                                                                                                     | confirmed    |
| C5  | Artifacts come from `-ArtifactsFolder` in a pipeline, the template's `output_folder` under `-DoNotRebuild`, else a local `Build-Bicep` | `Get-BicepDeploymentContext.ps1:126-137`                                                                                                                                                                                                                    | confirmed    |
| C6  | The context has exactly three concerns: plan, artifacts, identity (environment)                                                        | `types/BicepDeploymentContext.cs:13-19`; `docs/adr/azure/azure-data-model.md:358-359`                                                                                                                                                                       | confirmed    |
| C7  | A `DoNotRun` template yields no context and `Deploy-Bicep` returns                                                                     | `Get-BicepDeploymentContext.ps1:76-79`; `Deploy-Bicep.ps1:84-87`                                                                                                                                                                                            | confirmed    |
| C8  | Brief: `Deploy-AzureResourceGroup` → `Invoke-AzCli` runs the what-if, then the create                                                  | `Deploy-AzureResourceGroup.ps1:39,50` runs `group exists` / `group create`; the deployment's az calls are `Deploy-Bicep.ps1:180,192`                                                                                                                        | contradicted |
| C9  | Brief: the what-if runs, then the create                                                                                               | `Deploy-Bicep.ps1:178-190`: `-DryRun` runs only the what-if and returns; otherwise only the create runs (:192)                                                                                                                                              | contradicted |
| C10 | Brief: "Deploy-Bicep works on one immutable context" (and nothing else)                                                                | `Deploy-Bicep.ps1:98-99` also resolves `Get-BicepTemplate` / `Get-BicepTemplateConfiguration` outside the context, for the hook descriptors; `Set-BicepTrackingTagSet.ps1:45-46` re-resolves the session and environment instead of reading the context     | contradicted |
| C11 | Supports: ADR-AZ-DATAMOD (#4, #10), ADR-AZ-SESSION, ADR-AUTO-DRYRUN, ADR-PWSH-DRYRUN#1, ADR-PWSH-PREPOST, cited by the drawn code      | `Get-BicepDeploymentContext.ps1:6`; `Deploy-Bicep.ps1:6,36,38,67,121`; `automation/Catzc.Azure/Get-AzureEnvironment.ps1:6`; `Build-Bicep.ps1:103,117`; `automation/Catzc.Azure.Cli/Get-AzCliSessionSubscription.ps1:6`; `Set-BicepTrackingTagSet.ps1:17,19` | confirmed    |

Counts: 33 claims, 30 confirmed, 3 contradicted, 0 ADR-only.

## Corrections

- The brief's `Deploy-AzureResourceGroup → Invoke-AzCli (what-if, then create)` is two errors: `Deploy-AzureResourceGroup` only ensures the
  resource group exists, and the what-if and the create are alternatives on `-DryRun`, both called by `Deploy-Bicep` itself. The slide draws
  `Deploy-Bicep → Invoke-AzCli` and cuts `Deploy-AzureResourceGroup`.
- `Get-BicepDeploymentContext` is public (module root), not a private helper.
- `az` is not drawn as an external tool: no drawn box calls `az` directly; `Invoke-AzCli` runs it through `Invoke-Executable`.
- Every scout line number had moved after the comment export. All the numbers above are new.

## Drift

None between this slide and ADR-AZ-DATAMOD: the three concern-objects (`azure-data-model.md:358`) and the session-determined subscription
with the mandatory pipeline pin (`:57-61`) match the code. The ADR's "single source for both the deploy target and the tracking-tag scope"
(`:304-307`) holds by shared resolvers (`Get-BicepResourceGroupName`, the session, the environment), not by passing the context: tagging
resolves them a second time.

## Cut

`Get-BicepTemplate` (`Get-BicepDeploymentContext.ps1:70`), `Get-BicepTemplateConfiguration` (:108; again at `Deploy-Bicep.ps1:99`),
`Get-BicepResourceGroupName` (private, :114), `Get-BicepDeploymentName` (:150), `Get-BicepParametersFileName` (private, :145),
`Deploy-AzureResourceGroup` (`Deploy-Bicep.ps1:145`), the optional `PrePost.psm1` hooks `Invoke-BicepPreDeploy` / `Invoke-BicepPostDeploy`
(:101-118, :140-142, :209-212), `Get-CurrentAzSubscription`, the `az` executable and `azure.yml` as a file glyph (reading a file is not a
call, and the slide's one edge meaning is `calls`). Each is one more box past the cap of 10.
