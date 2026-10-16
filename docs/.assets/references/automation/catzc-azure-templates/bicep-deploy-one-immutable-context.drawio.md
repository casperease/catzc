---
catzc:
  derived:
    path: docs/.assets/references/automation/catzc-azure-templates/bicep-deploy-one-immutable-context.drawio.md
    kind: asset-description
    language: markdown
    filekind: md
    track: docs
    body_sha: "053bd80fdbac"
    adrs:
      - ADR-AZ-DATAMOD#4
      - ADR-PWSH-DRYRUN#1
      - ADR-PWSH-ERROR#8
    links:
      - docs/.assets/references/automation/catzc-azure-templates/bicep-deploy-one-immutable-context.drawio.png
---

# One immutable context, resolved from the az session: the diagram described

```text
A 1588 x 732 diagram, read top to bottom through two bands, entered from the left.
Glyphs: 7 code units, 3 C# types, 2 catzc module frames; 11 flow edges; 8 markers.
Sidebar: lens badge (SRC) and Supports chips; no minimaps.
```

This describes what the [diagram](bicep-deploy-one-immutable-context.drawio.png) draws from the source of the `Catzc.Azure.Templates`
module. The module's reference article embeds it and gives the responsibility in prose.

## At a glance

Every Bicep deploy in cats first builds one deployment context and then acts on it. `Deploy-Bicep` asks `Get-BicepDeploymentContext` for it.
The context reads the live az session's subscription, checks it against `azure.yml`, resolves the environment that subscription serves, and
finds the built template files. It returns one immutable `BicepDeploymentContext` with three concerns: the plan, the artifacts and the
environment. `Deploy-Bicep` then hands the context's values to `az` through `Invoke-AzCli` and stamps the tracking tags with
`Set-BicepTrackingTagSet`. That last step resolves the session and the environment again through the same two resolvers, rather than reading
the context.

## Walkthrough

1. **`Deploy-Bicep`** is the entry point. In a pipeline it throws unless `-SubscriptionIdAssertIs` pins the subscription the service
   connection must target (ADR-AZ-DATAMOD). A template marked `DoNotRun` yields no context, and the deploy stops there.
2. **`Get-BicepDeploymentContext`** resolves everything the deploy needs, in this order: the session, the environment, the build, then the
   three C# types.
3. **`Get-AzCliSessionSubscription`** (module `Catzc.Azure.Cli`) reads the az session's subscription and reverse-resolves it against
   `azure.yml`. An undeclared or doubly declared subscription throws (ADR-AZ-SESSION). `-SubscriptionIdAssertIs`, when given, must match it.
4. **`Get-AzureEnvironment`** (module `Catzc.Azure`) composes the environment the session's subscription serves from `azure.yml`
   (ADR-AZ-DATAMOD#4).
5. **`Build-Bicep`** runs only on a devbox without `-DoNotRebuild`. A pipeline takes the files from `-ArtifactsFolder`, and `-DoNotRebuild`
   reuses the template's existing output folder.
6. **`BicepDeploymentContext`** holds the `BicepDeploymentPlan` (template, deployment name, mode, target, resource group), the
   `BicepArtifacts` (build folder, template file, parameters file, PrePost module) and the `AzureEnvironment`. All three are sealed C# types
   with read-only properties, so nothing downstream can change what was resolved.
7. **`Invoke-AzCli`** (module `Catzc.Azure.Cli`) runs `az`. `Deploy-Bicep` calls it once: with `-DryRun` it runs the `--what-if` preview and
   returns, otherwise it runs the real `deployment group create` or `deployment sub create`. `Build-Bicep` calls it for `bicep build`.
8. **`Set-BicepTrackingTagSet`** runs after a successful deploy and stamps the tracking tags. It resolves the session and the environment
   again, through the same resolvers the context used, so the tag scope and the deploy target cannot drift.

## Reading path

Start at `Deploy-Bicep` on the left, outside the bands. Its first edge runs right into `Get-BicepDeploymentContext` at the top of the
RESOLVE band. From there one edge runs right into a frame holding the three C# types, and one drops to a junction that branches down to
`Build-Bicep` and right to `Get-AzCliSessionSubscription` in the `Catzc.Azure.Cli` frame and `Get-AzureEnvironment` in the `Catzc.Azure`
frame. Back at `Deploy-Bicep`, a second edge drops down the left margin, runs along the bottom of the DEPLOY band and branches up into
`Invoke-AzCli` and `Set-BicepTrackingTagSet`. From `Set-BicepTrackingTagSet` three edges leave: left to `Invoke-AzCli`, up to
`Get-AzureEnvironment`, and up and left to `Get-AzCliSessionSubscription`.

## Glyphs

| Glyph                          | Kind      | Band                             | Marker |
| ------------------------------ | --------- | -------------------------------- | ------ |
| `Deploy-Bicep`                 | code unit | none (left)                      | 1      |
| `Get-BicepDeploymentContext`   | code unit | RESOLVE                          | 2      |
| `BicepDeploymentPlan`          | C# type   | RESOLVE, in a frame              | —      |
| `BicepArtifacts`               | C# type   | RESOLVE, in a frame              | —      |
| `BicepDeploymentContext`       | C# type   | RESOLVE, in a frame              | 6      |
| `Build-Bicep`                  | code unit | RESOLVE                          | 5      |
| `Get-AzCliSessionSubscription` | code unit | RESOLVE, `Catzc.Azure.Cli` frame | 3      |
| `Get-AzureEnvironment`         | code unit | RESOLVE, `Catzc.Azure` frame     | 4      |
| `Invoke-AzCli`                 | code unit | DEPLOY, `Catzc.Azure.Cli` frame  | 7      |
| `Set-BicepTrackingTagSet`      | code unit | DEPLOY                           | 8      |

The `Catzc.Azure.Cli` frame is tall: it starts in the RESOLVE band and ends in the DEPLOY band, so both of its members sit in one frame. The
frame around the three C# types has the band's border colour and no name.

## Edges

Every edge is a flow edge meaning "calls". Each is backed by a call site in the source.

| From                         | To                             | Call site                                       |
| ---------------------------- | ------------------------------ | ----------------------------------------------- |
| `Deploy-Bicep`               | `Get-BicepDeploymentContext`   | `Deploy-Bicep.ps1`                              |
| `Get-BicepDeploymentContext` | the three C# types (one edge)  | `Get-BicepDeploymentContext.ps1`, three `::new` |
| `Get-BicepDeploymentContext` | `Get-AzCliSessionSubscription` | `Get-BicepDeploymentContext.ps1`                |
| `Get-BicepDeploymentContext` | `Get-AzureEnvironment`         | `Get-BicepDeploymentContext.ps1`                |
| `Get-BicepDeploymentContext` | `Build-Bicep`                  | `Get-BicepDeploymentContext.ps1`                |
| `Build-Bicep`                | `Invoke-AzCli`                 | `Build-Bicep.ps1`                               |
| `Deploy-Bicep`               | `Invoke-AzCli`                 | `Deploy-Bicep.ps1`, the what-if or the create   |
| `Deploy-Bicep`               | `Set-BicepTrackingTagSet`      | `Deploy-Bicep.ps1`                              |
| `Set-BicepTrackingTagSet`    | `Invoke-AzCli`                 | `Set-BicepTrackingTagSet.ps1`                   |
| `Set-BicepTrackingTagSet`    | `Get-AzureEnvironment`         | `Set-BicepTrackingTagSet.ps1`                   |
| `Set-BicepTrackingTagSet`    | `Get-AzCliSessionSubscription` | `Set-BicepTrackingTagSet.ps1`                   |

The three edges out of `Get-BicepDeploymentContext` toward the resolvers share one junction below it. The two edges out of `Deploy-Bicep`
toward the DEPLOY band share one trunk along the bottom.

## Legend

The legend panel spans the bottom of the drawing area in three columns:

- code unit
- C# type
- catzc module (another Catzc.\* module)
- flow: calls
- marker: a Walkthrough step

## Sidebar

A lens badge reading `SRC · source lens`. Below it is a Supports panel listing ADR-AZ-DATAMOD#4 and #10, ADR-AZ-SESSION, ADR-AUTO-DRYRUN,
ADR-PWSH-DRYRUN#1 and ADR-PWSH-PREPOST: the rules the drawn code cites. The drawn code also cites ADR-PWSH-ERROR#8 (the PrePost hooks and
template builds run strict). Source-lens slides carry no minimaps.

## Where the code and the ADR differ

They don't differ on what this slide draws. The three concerns of the context, the session-determined subscription and the mandatory
pipeline pin match ADR-AZ-DATAMOD. The ADR's single source for the deploy target and the tracking-tag scope holds through shared resolvers:
`Set-BicepTrackingTagSet` resolves the session, the environment and the resource group again rather than reading the context.
