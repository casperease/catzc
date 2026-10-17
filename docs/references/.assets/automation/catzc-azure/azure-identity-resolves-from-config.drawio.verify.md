---
catzc:
  immutable:
    with_body_sha: e410849b57ff
    repo_status: clean
    path: docs/.assets/references/automation/catzc-azure/azure-identity-resolves-from-config.drawio.verify.md
    folder: docs/.assets/references/automation/catzc-azure
    name: azure-identity-resolves-from-config-drawio-verify
    filetype: md
    kind: asset-description
    language: markdown
    track: docs
    tracktype: documentation
  edges:
    cites:
      - ADR-AUTO-DEFAULT#6
      - ADR-AUTO-TYPES#8
      - ADR-AZ-CUSTOMER#2
      - ADR-AZ-DATAMOD#4
      - ADR-AZ-NAMING#6
      - ADR-AZ-SESSION#5
      - ADR-PWSH-CACHE#4
---

# out/diagrams/wave-9/catzc-azure/azure-identity-resolves-from-config.drawio.verify.md

`Verification: Azure identities resolve from config; session must match one (source lens, Catzc.Azure)`

Every line below was re-read on 2026-10-15 after the comment export. None of the scout's line numbers still held (for example the 0-match
throw moved from `Get-AzCliSessionSubscription.ps1:26` to `:25-27`, and `Get-AzureCustomer.ps1:27` is now `:125`), so none is reused.
`condense-comments` may move them again, so re-grep before landing. Paths are relative to `automation/`.

## Boxes

| #   | Claim (box)                                                                                | Source (`file:line`)                                                                        | Status    |
| --- | ------------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------- | --------- |
| B1  | `azure.yml` is a Catzc.Azure config file                                                   | `Catzc.Azure/configs/azure.yml` (Glob hit)                                                  | confirmed |
| B2  | `customer.yml` is a Catzc.Azure config file                                                | `Catzc.Azure/configs/customer.yml` (Glob hit)                                               | confirmed |
| B3  | `Get-Config` is public in Catzc.Base.Config, the single config reader                      | `Catzc.Base.Config/Get-Config.ps1:5,20`                                                     | confirmed |
| B4  | `AzureConfig` is a C# type under `types/`                                                  | `Catzc.Azure/types/AzureConfig.cs:20`                                                       | confirmed |
| B5  | `CustomerConfig` is a C# type under `types/`                                               | `Catzc.Azure/types/CustomerConfig.cs:14`                                                    | confirmed |
| B6  | `Get-AzureCustomer` is public; it throws on a name that is no key or shortcode             | `Catzc.Azure/Get-AzureCustomer.ps1:101,113-125`                                             | confirmed |
| B7  | `Get-AzureSubscription` is public and builds `AzureSubscription` (id, customer, tenant)    | `Catzc.Azure/Get-AzureSubscription.ps1:18,32,43`                                            | confirmed |
| B8  | `Get-AzureEnvironment` is public and asserts the subscription serves the env               | `Catzc.Azure/Get-AzureEnvironment.ps1:63,80-81,84`                                          | confirmed |
| B9  | `Get-CurrentAzSubscription` is public in Catzc.Azure.Cli and reads `az account show`       | `Catzc.Azure.Cli/Get-CurrentAzSubscription.ps1:52,59,67`                                    | confirmed |
| B10 | `Get-AzCliSessionSubscription` is a gate: it throws on 0 matches and on more than 1        | `Catzc.Azure.Cli/Get-AzCliSessionSubscription.ps1:24,25-27,28-30`                           | confirmed |
| B11 | Count chip `1`: the session id must match exactly one declared subscription                | `Catzc.Azure.Cli/Get-AzCliSessionSubscription.ps1:24-32` (`$declared[0]` after both throws) | confirmed |
| M1  | Frame Catzc.Base.Config holds `Get-Config`                                                 | `Catzc.Base.Config/Get-Config.ps1` at the module root                                       | confirmed |
| M2  | Frame Catzc.Azure.Cli holds `Get-CurrentAzSubscription` and `Get-AzCliSessionSubscription` | both files at `Catzc.Azure.Cli/` root                                                       | confirmed |

## Edges (flow: feeds)

| #   | Edge                                                                             | Source (`file:line`)                                                                                          | Status    |
| --- | -------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------- | --------- |
| E1  | `azure.yml` → `Get-Config`                                                       | `Catzc.Base.Config/Get-Config.ps1:66`; asked as `-Config azure` at `Catzc.Azure/Get-AzureSubscription.ps1:27` | confirmed |
| E2  | `customer.yml` → `Get-Config`                                                    | `Catzc.Base.Config/Get-Config.ps1:66`; asked as `-Config customer` at `Catzc.Azure/Get-AzureCustomer.ps1:109` | confirmed |
| E3  | `Get-Config` → `AzureConfig` (the registered type)                               | `Catzc.Base.Config/Get-Config.ps1:68,82-85`; `Catzc.Base.Config/configs/configs.yml:84-85`                    | confirmed |
| E4  | `Get-Config` → `CustomerConfig` (the registered type)                            | `Catzc.Base.Config/Get-Config.ps1:68,82-85`; `Catzc.Base.Config/configs/configs.yml:82-83`                    | confirmed |
| E5  | `AzureConfig` → `Get-AzureSubscription` (via the frame)                          | `Catzc.Azure/Get-AzureSubscription.ps1:27-30`                                                                 | confirmed |
| E6  | `AzureConfig` → `Get-AzureEnvironment` (via the frame)                           | `Catzc.Azure/Get-AzureEnvironment.ps1:77-81`                                                                  | confirmed |
| E7  | `CustomerConfig` → `Get-AzureCustomer`                                           | `Catzc.Azure/Get-AzureCustomer.ps1:109-110`                                                                   | confirmed |
| E8  | `Get-AzureCustomer` → `Get-AzureSubscription` (the canonical key)                | `Catzc.Azure/Get-AzureSubscription.ps1:41` (token from `Get-AzureSubscriptionCustomer` at :36, cut)           | confirmed |
| E9  | `Get-AzureSubscription` → `Get-AzureEnvironment`                                 | `Catzc.Azure/Get-AzureEnvironment.ps1:83-84`                                                                  | confirmed |
| E10 | `AzureConfig` → `Get-AzCliSessionSubscription`                                   | `Catzc.Azure.Cli/Get-AzCliSessionSubscription.ps1:22,24`                                                      | confirmed |
| E11 | `Get-CurrentAzSubscription` → `Get-AzCliSessionSubscription`                     | `Catzc.Azure.Cli/Get-AzCliSessionSubscription.ps1:21,24` (`$current.Id`)                                      | confirmed |
| E12 | `Get-AzCliSessionSubscription` → `Get-AzureSubscription` (the one declared name) | `Catzc.Azure.Cli/Get-AzCliSessionSubscription.ps1:32`                                                         | confirmed |

## Brief and sidebar

| #   | Claim                                                                                                   | Source (`file:line`)                                                                                                                                            | Status       |
| --- | ------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------ |
| C1  | Brief sketch: `azure.yml`, `customer.yml` → `Get-Config` → `AzureConfig`                                | `customer.yml` is registered to `CustomerConfig`, not `AzureConfig`: `Catzc.Base.Config/configs/configs.yml:82-83`                                              | contradicted |
| C2  | The 0-match throw names the undeclared session and lists the declared names                             | `Catzc.Azure.Cli/Get-AzCliSessionSubscription.ps1:25-27`; `docs/adr/azure/az-session-verification.md:42-44` (ADR-AZ-SESSION#5)                                  | confirmed    |
| S1  | Supports: ADR-AZ-SESSION; ADR-AZ-DATAMOD#4, #7, #8, #11; ADR-AZ-CUSTOMER#2, #3, cited by the drawn code | `Get-AzCliSessionSubscription.ps1:6`; `Get-AzureSubscription.ps1:6-7`; `Get-AzureEnvironment.ps1:50`; `types/AzureConfig.cs:2-9`; `types/CustomerConfig.cs:2-5` | confirmed    |

Counts: 28 claims, 27 confirmed, 1 contradicted, 0 ADR-only.

The drawn code also cites ADR-AUTO-TYPES#8, ADR-AUTO-DEFAULT#6 and ADR-AZ-NAMING#6 (`types/AzureConfig.cs:3-6`,
`types/CustomerConfig.cs:3`), and `Get-Config` cites ADR-AUTO-OVERLAY and ADR-PWSH-CACHE#4 (`Get-Config.ps1:41,57`). They govern parts the
slide does not draw (validation shape, defaults, naming, overlay, caching), so they stay out of the Supports chips.

## Corrections

- The brief's sketch fed both files into `AzureConfig`. `Get-Config` constructs each config's own registered type, so `customer.yml` becomes
  `CustomerConfig`, and the slide draws two typed outputs from the one reader.
- The brief's sketch ran `Get-CurrentAzSubscription` → `Get-AzCliSessionSubscription`. That is the direction data moves; the call goes the
  other way (`Get-AzCliSessionSubscription.ps1:21`). The slide's one edge meaning is `flow: feeds`, so the sketch's direction stands.
- `AzureConfig` feeds three readers, not one: `Get-AzureSubscription`, `Get-AzureEnvironment` (it reads `environments` itself) and
  `Get-AzCliSessionSubscription`. The slide draws all three.
- Every scout line number had moved after the comment export. All the numbers above are new.

## Drift

- ADR-AZ-SESSION#5 states one throw, for a session on a subscription azure.yml does not declare. The code adds a second throw for an id
  declared more than once (`Get-AzCliSessionSubscription.ps1:28-30`, "subscription ids must be unique"). No ADR rule states global
  subscription-id uniqueness (ADR-AZ-DATAMOD says uniqueness is per coordinate, `azure-data-model.md:193-197`), and `AzureConfig` does not
  check it at load, so a duplicate id surfaces only when a session lands on it.

## Cut

`Get-AzureSubscriptionCustomer` (`Get-AzureSubscription.ps1:36`, the subscription's raw customer token), `Get-ConfigRegistry`
(`Get-Config.ps1:68`), `Resolve-ConfigEntry` (`:38`), the overlay merge (`:43-79`), `Invoke-AzCli` (`Get-CurrentAzSubscription.ps1:59`), the
`Tenant`, `AzureSubscription` and `AzureEnvironment` result types (`Get-AzureSubscription.ps1:32,43`, `Get-AzureEnvironment.ps1:84`), and
the throws as a failure glyph (an eleventh box). Each is one more box past the cap of 10.
