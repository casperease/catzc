---
catzc:
  derived:
    path: docs/.assets/references/automation/catzc-azure/azure-identity-resolves-from-config.drawio.md
    kind: asset-description
    language: markdown
    filetype: md
    track: docs
    body_sha: e71cc3ad7cb6
    adrs:
      - ADR-AZ-CUSTOMER#2
      - ADR-AZ-DATAMOD#4
      - ADR-AZ-SESSION#5
    links:
      - docs/.assets/references/automation/catzc-azure/azure-identity-resolves-from-config.drawio.png
---

# Azure identities resolve from config; session must match one: the diagram described

```text
A 1588 x 654 diagram, read left to right through two bands; the SESSION band sits above the CONFIG band.
Glyphs: 5 code units, 2 C# types, 2 files, 1 gate; 2 catzc module frames and 1 plain frame.
Edges: 11 flow edges (feeds); 10 markers; 1 count chip.
Sidebar: lens badge (SRC) and Supports chips; no minimaps.
```

This describes what the [diagram](azure-identity-resolves-from-config.drawio.png) draws from the source of the `Catzc.Azure` module. The
module's reference article embeds it and gives the responsibility in prose.

## At a glance

Every Azure identity in cats comes from two config files. `Get-Config` reads `azure.yml` into an `AzureConfig` and `customer.yml` into a
`CustomerConfig`, and the resolvers build subscriptions, customers and environments only from those objects. The az session is no exception:
`Get-AzCliSessionSubscription` takes the session's subscription id from `Get-CurrentAzSubscription` and looks it up in `AzureConfig`. It
throws when no declared subscription has that id and when more than one does, so exactly one declared name reaches `Get-AzureSubscription`.

## Walkthrough

1. **`azure.yml`** declares the tenants, subscriptions and environments.
2. **`customer.yml`** declares the customers, each by a readable key and a 2-character shortcode.
3. **`Get-Config`** (module `Catzc.Base.Config`) reads a config file and constructs the C# type its registry names for it, then caches the
   result.
4. **`AzureConfig`** is the typed `azure.yml`. It validates the file when it is constructed.
5. **`CustomerConfig`** is the typed `customer.yml`.
6. **`Get-AzureCustomer`** resolves a customer key or shortcode to the canonical customer, and throws on a name that is neither.
7. **`Get-AzureSubscription`** resolves a subscription name to its id, tenant and canonical customer key.
8. **`Get-AzureEnvironment`** checks that the subscription serves the environment and adds the subscription's identity to the environment's
   own fields.
9. **`Get-CurrentAzSubscription`** (module `Catzc.Azure.Cli`) reads the az session's active subscription.
10. **`Get-AzCliSessionSubscription`** matches the session's subscription id against the declared subscriptions. The count chip `1` says
    exactly one must match: none throws, because the session targets a subscription `azure.yml` does not declare, and more than one throws,
    because the id is declared twice. The one match goes on to `Get-AzureSubscription`.

## Reading path

Start at the two files on the left of the CONFIG band. Their edges join and enter `Get-Config` inside the Catzc.Base.Config frame, and its
output splits up to `AzureConfig` and down to `CustomerConfig`. Follow the lower row right to `Get-AzureCustomer` and up into
`Get-AzureSubscription`. From `AzureConfig`, one edge runs right into a plain frame around `Get-AzureSubscription` and
`Get-AzureEnvironment`, and a second rises into the SESSION band to the gate. In the SESSION band, `Get-CurrentAzSubscription` feeds the
gate from above, and the gate's edge drops down into `Get-AzureSubscription`. The upper row ends at `Get-AzureEnvironment`.

## Glyphs

| Glyph                          | Kind      | Band                            | Marker |
| ------------------------------ | --------- | ------------------------------- | ------ |
| `azure.yml`                    | file      | CONFIG                          | 1      |
| `customer.yml`                 | file      | CONFIG                          | 2      |
| `Get-Config`                   | code unit | CONFIG, Catzc.Base.Config frame | 3      |
| `AzureConfig`                  | C# type   | CONFIG                          | 4      |
| `CustomerConfig`               | C# type   | CONFIG                          | 5      |
| `Get-AzureCustomer`            | code unit | CONFIG                          | 6      |
| `Get-AzureSubscription`        | code unit | CONFIG                          | 7      |
| `Get-AzureEnvironment`         | code unit | CONFIG                          | 8      |
| `Get-CurrentAzSubscription`    | code unit | SESSION, Catzc.Azure.Cli frame  | 9      |
| `Get-AzCliSessionSubscription` | gate      | SESSION, Catzc.Azure.Cli frame  | 10     |

Two catzc module frames, `Catzc.Base.Config` and `Catzc.Azure.Cli`, hold the glyphs of other modules. A plain frame with no label groups
`Get-AzureSubscription` and `Get-AzureEnvironment` as the targets of one edge. A count chip reading `1` sits on the gate's lower-right rim,
away from its marker. The SESSION band starts at the `AzureConfig` column and leaves its right half empty.

## Edges

Every edge is a flow edge meaning "feeds": data moves from the source to the target. Each is backed by a call site in the source.

| From                           | To                                                     | Call site                                               |
| ------------------------------ | ------------------------------------------------------ | ------------------------------------------------------- |
| `azure.yml`                    | `Get-Config`                                           | `Get-Config.ps1`, asked by `Get-AzureSubscription.ps1`  |
| `customer.yml`                 | `Get-Config`                                           | `Get-Config.ps1`, asked by `Get-AzureCustomer.ps1`      |
| `Get-Config`                   | `AzureConfig`                                          | `Get-Config.ps1`, registry `configs.yml`                |
| `Get-Config`                   | `CustomerConfig`                                       | `Get-Config.ps1`, registry `configs.yml`                |
| `AzureConfig`                  | frame: `Get-AzureSubscription`, `Get-AzureEnvironment` | `Get-AzureSubscription.ps1`, `Get-AzureEnvironment.ps1` |
| `CustomerConfig`               | `Get-AzureCustomer`                                    | `Get-AzureCustomer.ps1`                                 |
| `Get-AzureCustomer`            | `Get-AzureSubscription`                                | `Get-AzureSubscription.ps1`                             |
| `Get-AzureSubscription`        | `Get-AzureEnvironment`                                 | `Get-AzureEnvironment.ps1`                              |
| `AzureConfig`                  | `Get-AzCliSessionSubscription`                         | `Get-AzCliSessionSubscription.ps1`                      |
| `Get-CurrentAzSubscription`    | `Get-AzCliSessionSubscription`                         | `Get-AzCliSessionSubscription.ps1`                      |
| `Get-AzCliSessionSubscription` | `Get-AzureSubscription`                                | `Get-AzCliSessionSubscription.ps1`                      |

The two file edges meet at a junction left of the Catzc.Base.Config frame and enter `Get-Config` as one arrow; its output leaves as one line
and splits to the two C# types.

## Legend

The legend panel spans the bottom of the drawing area in four columns:

| Swatch                 | Phrase                                 |
| ---------------------- | -------------------------------------- |
| slate rounded box      | code unit                              |
| slate box with C# tag  | C# type                                |
| slate frame, no fill   | catzc module                           |
| green folded page      | file                                   |
| rhombus, thick rim     | gate                                   |
| pill reading `1`       | count chip: ids the session must match |
| arrow                  | flow: feeds                            |
| light disc reading `1` | marker: a Walkthrough step             |

## Sidebar

A lens badge reading `SRC · source lens`. Below it is a Supports panel listing ADR-AZ-SESSION, ADR-AZ-DATAMOD#4, #7, #8 and #11, and
ADR-AZ-CUSTOMER#2 and #3: the rules the drawn code cites. Source-lens slides carry no minimaps.

## Where the code and the ADR differ

ADR-AZ-SESSION#5 names one failure of the reverse lookup: a session on a subscription `azure.yml` does not declare. The code also throws
when the session's id is declared more than once, a uniqueness that no ADR rule states and that `AzureConfig` does not check when it loads.
