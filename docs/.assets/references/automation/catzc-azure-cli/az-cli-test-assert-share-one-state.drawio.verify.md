---
catzc:
  derived:
    path: docs/.assets/references/automation/catzc-azure-cli/az-cli-test-assert-share-one-state.drawio.verify.md
    folder: docs/.assets/references/automation/catzc-azure-cli
    name: az-cli-test-assert-share-one-state-drawio-verify
    filetype: md
    kind: asset-description
    language: markdown
    track: docs
    body_sha: "4a8652767fed"
    adrs:
      - ADR-AUTO-PRELOG#5
      - ADR-AZ-CLI#1
      - ADR-AZ-DATAMOD#4
---

# out/diagrams/wave-9/catzc-azure-cli/az-cli-test-assert-share-one-state.drawio.verify.md

`Verification: Three az checks: Test and Assert share one state call (source lens, Catzc.Azure.Cli)`

Every line below was re-read on 2026-10-15 after the comment export. All the brief's line numbers had moved (for example
`Get-AzCliConnectionState.ps1:47,49` is now `:34,43`, `Assert-AzCliCanAccess.ps1:32-33` is now `:25-26`, and the drift comment at
`Assert-AzCliConnected.ps1:7-8` now lives on its comment page). `condense-comments` may move them again, so re-grep before landing. Paths
are relative to `automation/Catzc.Azure.Cli/` unless they start with `automation/` or `docs/`.

## Boxes

| #   | Claim (box)                                                                   | Source (`file:line`)                                                                                                                                                                                                                       | Status    |
| --- | ----------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | --------- |
| B1  | `Get-AzureSubscription` is a public function of module `Catzc.Azure` (frame)  | `automation/Catzc.Azure/Get-AzureSubscription.ps1:18`; reads azure.yml at `:27` (`Get-Config -Config azure`)                                                                                                                               | confirmed |
| B2  | `Test-AzCliIsConnected` is public, takes a subscription name from azure.yml   | `Test-AzCliIsConnected.ps1:12,17-19`                                                                                                                                                                                                       | confirmed |
| B3  | `Assert-AzCliIsConnected` is public, takes a subscription name from azure.yml | `Assert-AzCliIsConnected.ps1:15,19-21`                                                                                                                                                                                                     | confirmed |
| B4  | `Test-AzCliConnected` is public and generic (ids by argument)                 | `Test-AzCliConnected.ps1:16,19-25`                                                                                                                                                                                                         | confirmed |
| B5  | `Assert-AzCliConnected` is public and generic, the throwing companion         | `Assert-AzCliConnected.ps1:5,16,29-59`                                                                                                                                                                                                     | confirmed |
| B6  | `Get-AzCliConnectionState` is public and returns one `ConnectionState`        | `Get-AzCliConnectionState.ps1:16,36,43`; `types/ConnectionState.cs:8`                                                                                                                                                                      | confirmed |
| B7  | Named set `SubscriptionAccessState`: 5 functions share one state primitive    | `Test-AzCliCanAccess.ps1:14`, `Assert-AzCliCanAccess.ps1:16`, `Test-AzCliSubscriptionAccessible.ps1:13`, `Assert-AzCliSubscriptionAccessible.ps1:14`, `Get-AzCliSubscriptionAccessState.ps1:13`; type `types/SubscriptionAccessState.cs:8` | confirmed |
| B8  | Named set `BicepState`: 3 functions, no azure.yml-name wrapper                | `Test-AzCliBicep.ps1:12`, `Assert-AzCliBicep.ps1:14`, `private/Get-AzCliBicepState.ps1:10`; type `types/BicepState.cs:8`                                                                                                                   | confirmed |
| B9  | `Invoke-AzCli` is public, the one runner of az                                | `Invoke-AzCli.ps1:24`                                                                                                                                                                                                                      | confirmed |
| B10 | `az` is the external tool                                                     | `Invoke-AzCli.ps1:38` (`Assert-Tool 'az_cli'`), `:49` (`Invoke-Executable "az $Arguments"`)                                                                                                                                                | confirmed |
| B11 | Count chip `5` on the access set                                              | the five files of B7                                                                                                                                                                                                                       | confirmed |
| B12 | Count chip `3` on the bicep set                                               | the three files of B8                                                                                                                                                                                                                      | confirmed |

## Edges (flow: calls)

| #   | Edge                                                                                       | Source (`file:line`)                                                                         | Status    |
| --- | ------------------------------------------------------------------------------------------ | -------------------------------------------------------------------------------------------- | --------- |
| E1  | `Test-AzCliIsConnected` → `Get-AzureSubscription`                                          | `Test-AzCliIsConnected.ps1:22`                                                               | confirmed |
| E2  | `Assert-AzCliIsConnected` → `Get-AzureSubscription`                                        | `Assert-AzCliIsConnected.ps1:24`                                                             | confirmed |
| E3  | access set → `Get-AzureSubscription`                                                       | `Test-AzCliCanAccess.ps1:24`; `Assert-AzCliCanAccess.ps1:25`                                 | confirmed |
| E4  | `Test-AzCliIsConnected` → `Test-AzCliConnected`                                            | `Test-AzCliIsConnected.ps1:24`                                                               | confirmed |
| E5  | `Assert-AzCliIsConnected` → `Get-AzCliConnectionState` (passes `Assert-AzCliConnected` by) | `Assert-AzCliIsConnected.ps1:26`                                                             | confirmed |
| E6  | `Test-AzCliConnected` → `Get-AzCliConnectionState`                                         | `Test-AzCliConnected.ps1:28`                                                                 | confirmed |
| E7  | `Assert-AzCliConnected` → `Get-AzCliConnectionState`                                       | `Assert-AzCliConnected.ps1:27`                                                               | confirmed |
| E8  | `Get-AzCliConnectionState` → `Invoke-AzCli`                                                | `Get-AzCliConnectionState.ps1:34` (`account show -o yaml`)                                   | confirmed |
| E9  | access set → `Invoke-AzCli`                                                                | `Get-AzCliSubscriptionAccessState.ps1:24` (`account list-locations`), `:31` (`account show`) | confirmed |
| E10 | bicep set → `Invoke-AzCli`                                                                 | `private/Get-AzCliBicepState.ps1:18` (`bicep version`)                                       | confirmed |
| E11 | `Invoke-AzCli` → `az`                                                                      | `Invoke-AzCli.ps1:49`, through `Invoke-Executable` (module Catzc.Base.Execution, cut)        | confirmed |

## Inside the named sets (the finding, not drawn as boxes)

| #   | Claim                                                                              | Source (`file:line`)                                                                      | Status    |
| --- | ---------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------- | --------- |
| S1  | `Test-AzCliCanAccess` → `Test-AzCliSubscriptionAccessible`                         | `Test-AzCliCanAccess.ps1:25`                                                              | confirmed |
| S2  | `Assert-AzCliCanAccess` → `Assert-AzCliSubscriptionAccessible` (symmetric with S1) | `Assert-AzCliCanAccess.ps1:26`                                                            | confirmed |
| S3  | `Test-AzCliSubscriptionAccessible` → `Get-AzCliSubscriptionAccessState`            | `Test-AzCliSubscriptionAccessible.ps1:21`                                                 | confirmed |
| S4  | `Assert-AzCliSubscriptionAccessible` → `Get-AzCliSubscriptionAccessState`          | `Assert-AzCliSubscriptionAccessible.ps1:21`                                               | confirmed |
| S5  | `Test-AzCliBicep` → `Get-AzCliBicepState`                                          | `Test-AzCliBicep.ps1:16`                                                                  | confirmed |
| S6  | `Assert-AzCliBicep` → `Get-AzCliBicepState` (after its own `Assert-Tool 'az_cli'`) | `Assert-AzCliBicep.ps1:19,21`                                                             | confirmed |
| S7  | The bicep state reads its minimum from azure.yml itself, not through a wrapper     | `private/Get-AzCliBicepState.ps1:13` (`Get-AzureBicepMinVersion`, module Catzc.Azure)     | confirmed |
| S8  | "Both Assert/Test share Get-AzCliConnectionState"                                  | `docs/references/automation/catzc-azure-cli/Assert-AzCliConnected.ps1.md:16`; code E6, E7 | confirmed |

## Sidebar

| #   | Claim                                        | Source (`file:line`)                                                                                                                       | Status    |
| --- | -------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------ | --------- |
| C1  | ADR-AZ-CLI#1 is cited by the drawn code      | `Test-AzCliSubscriptionAccessible.ps1:6`, `Get-AzCliSubscriptionAccessState.ps1:6`, `Test-AzCliBicep.ps1:6`, `Assert-AzCliCanAccess.ps1:7` | confirmed |
| C2  | ADR-AZ-DATAMOD#4 is cited by the drawn code  | `automation/Catzc.Azure/Get-AzureSubscription.ps1:6` (bare ADR-AZ-DATAMOD at `Assert-AzCliIsConnected.ps1:6`, `Test-AzCliCanAccess.ps1:6`) | confirmed |
| C3  | ADR-AZ-CUSTOMER is cited by the drawn code   | `automation/Catzc.Azure/Get-AzureSubscription.ps1:7,34`                                                                                    | confirmed |
| C4  | ADR-AUTO-FAILFAST is cited by the drawn code | `Assert-AzCliSubscriptionAccessible.ps1:7`                                                                                                 | confirmed |
| C5  | ADR-AUTO-ENTERP is cited by the drawn code   | `Test-AzCliBicep.ps1:7`, `Assert-AzCliBicep.ps1:7`                                                                                         | confirmed |
| C6  | ADR-AUTO-PRELOG#5 is cited by the drawn code | `private/Get-AzCliBicepState.ps1:16`                                                                                                       | confirmed |

Counts: 37 claims, 37 confirmed, 0 contradicted, 0 ADR-only. One code comment is contradicted by the code (Drift below); the slide draws the
code.

## Corrections

- The brief's finding said "each az check" shares one state primitive. The module has a fourth check, the extension check, whose
  `Assert-AzCliExtension` calls `Test-AzCliExtension` directly (`Assert-AzCliExtension.ps1:19`) with no state primitive between them. The
  title says "Three az checks" and the extension pair is cut.
- The brief's finding said the config-aware wrappers "only add the azure.yml lookup". That holds for `Test-AzCliIsConnected`,
  `Test-AzCliCanAccess` and `Assert-AzCliCanAccess`. `Assert-AzCliIsConnected` also repeats the throw logic of `Assert-AzCliConnected`
  (`Assert-AzCliIsConnected.ps1:30-39` against `Assert-AzCliConnected.ps1:29-59`) instead of delegating to it. The slide draws its edge
  straight to `Get-AzCliConnectionState`, past `Assert-AzCliConnected`.
- The bicep check has no azure.yml-name wrapper: its state reads `bicep_min_version` itself (S7), so its named set starts at the pair row.
- Every scout line number had moved after the comment export. All the numbers above are new.

## Drift

- The comment of `Assert-AzCliConnected` (`docs/references/automation/catzc-azure-cli/Assert-AzCliConnected.ps1.md:15-16`) says the
  config-aware `Assert-AzCliIsConnected` "delegates here". The code of `Assert-AzCliIsConnected` calls `Get-AzCliConnectionState` directly
  (`Assert-AzCliIsConnected.ps1:26`) and throws its own messages. Its own comment page (`Assert-AzCliIsConnected.ps1.md:16`) says so
  correctly. The two comments disagree; the code agrees with the second.

## Cut

`Test-AzCliExtension` / `Assert-AzCliExtension` (no state primitive), the members of the two named sets (named in the description),
`Get-AzCliBicepState` as a private helper box (inside the bicep set), `Get-AzureBicepMinVersion` (Catzc.Azure, S7), `azure.yml` as a file
glyph, `Invoke-Executable` (Catzc.Base.Execution), `Assert-Tool` (`Invoke-AzCli.ps1:38`, `Assert-AzCliBicep.ps1:19`), `Assert-IsGuid`
(`Get-AzCliConnectionState.ps1:28,31`), and the session functions (`Connect-AzCli`, `Set-AzCliSubscription`, `Invoke-InSubscription`, …).
Each would be one more box past the cap of 10.
