---
catzc:
  derived:
    path: docs/.assets/references/automation/catzc-azure-templates/bicep-template-is-a-folder.drawio.md
    kind: asset-description
    language: markdown
    filetype: md
    track: docs
    body_sha: "8061b764a8d1"
    adrs:
      - ADR-AUTO-TYPES#9
      - ADR-AZ-DATAMOD#10
      - ADR-AZ-NAMING#2
      - ADR-CONF-ADDRESSING#1
      - ADR-PWSH-CACHE#4
      - ADR-PWSH-ERROR#8
    links:
      - docs/.assets/references/automation/catzc-azure-templates/bicep-template-is-a-folder.drawio.png
---

# A template is a folder; options.yml overrides five defaults: the diagram described

```text
A 1588 x 666 diagram, read left to right through two bands, top to bottom.
Glyphs: 3 code units, 1 private helper, 2 C# types, 1 gate, 2 files, 1 catzc module frame; 6 flow edges; 7 markers.
Sidebar: lens badge (SRC) and Supports chips; no minimaps.
```

This describes what the [diagram](bicep-template-is-a-folder.drawio.png) draws from the source of the `Catzc.Azure.Templates` module. The
module's reference article embeds it and gives the responsibility in prose.

## At a glance

In cats a Bicep template is a folder under `infrastructure/templates/`: one folder, one template. `Get-BicepTemplates` walks those folders
and, for each, lets an optional `options.yml` override five defaults that are otherwise derived: `short_name` (from the folder name),
`deployment_mode` (`Incremental`), `deployment_target` (`ResourceGroup`), `environment_kind` (`standard`) and `customer_deployment` (the
`have_customers` variant). Any other key, or an invalid value, stops discovery. `Build-Bicep` then writes one parameters file per slot and
compiles `main.bicep` once.

## Walkthrough

1. **`Get-BicepTemplates`** enumerates the folders under `infrastructure/templates/`, sorted, and requires each to hold `main.bicep` and a
   `configuration/` folder. `Build-Bicep` reaches it through `Get-BicepTemplate`, which picks one template by name.
2. **`Read-BicepTemplateOptions`** reads the folder's `options.yml` when it exists and accepts only the five keys `short_name`,
   `deployment_mode`, `deployment_target`, `environment_kind` and `customer_deployment`. It collects every unknown key and invalid value and
   throws them together. A missing or empty file means no overrides.
3. **`BicepShortName`** resolves the template's `short_name`: the override when `options.yml` gives one, otherwise the folder name
   lower-cased, kept to letters and digits, and cut to the maximum length (ADR-AZ-NAMING#2, #6).
4. **`BicepTemplate`** is the descriptor built once per folder: the slots found under `configuration/`, the defaults, and the remaining
   `options.yml` overrides laid over them.
5. **`Resolve-BicepParameterAddresses`** runs for each slot `Build-Bicep` targets. It renders every config-addressed parameter as the value
   it addresses (ADR-AZ-DATAMOD#10, ADR-CONF-ADDRESSING#1, #3).
6. **`parameters.<config>.json`** is the one parameters file written per slot into the template's output folder; a customer slot's file is
   `parameters.<customer>.<config>.json`.
7. **`Invoke-AzCli`** runs `bicep build` once, after every slot's parameters file is written, and the build must leave a `main.json`.

## Reading path

Start at the two code units on the left, outside the bands: `Build-Bicep` above, with one short edge down to `Get-BicepTemplates`. From
there the flow runs right into the EACH FOLDER band, through the `Read-BicepTemplateOptions` gate, `BicepShortName` and `BicepTemplate`. The
`options.yml` file sits directly under the gate. From `BicepTemplate` one edge drops below the band and runs left to
`Resolve-BicepParameterAddresses` at the start of the EACH SLOT band. The `parameters.<config>.json` file sits below and right of it in the
same band. The flow leaves the band to the right and ends at `Invoke-AzCli` inside the `Catzc.Azure.Cli` frame.

## Glyphs

| Glyph                             | Kind           | Band                    | Marker |
| --------------------------------- | -------------- | ----------------------- | ------ |
| `Build-Bicep`                     | code unit      | none (left)             | —      |
| `Get-BicepTemplates`              | code unit      | none (left)             | 1      |
| `Read-BicepTemplateOptions`       | gate           | EACH FOLDER             | 2      |
| `options.yml`                     | file           | EACH FOLDER             | —      |
| `BicepShortName`                  | C# type        | EACH FOLDER             | 3      |
| `BicepTemplate`                   | C# type        | EACH FOLDER             | 4      |
| `Resolve-BicepParameterAddresses` | private helper | EACH SLOT               | 5      |
| `parameters.<config>.json`        | file           | EACH SLOT               | 6      |
| `Invoke-AzCli`                    | code unit      | `Catzc.Azure.Cli` frame | 7      |

`Resolve-BicepParameterAddresses` is shown elided as `Resolve-Bicep…Addresses`. Each C# type carries a `C#` tag on its top-right corner. The
`Catzc.Azure.Cli` frame sits right of the EACH SLOT band, on the same row. The private helper has a darker fill than the code units.

## Edges

Every edge is a flow edge meaning "runs next, in code order". Each is backed by a call site in the module's source.

| From                              | To                                | Call site                                            |
| --------------------------------- | --------------------------------- | ---------------------------------------------------- |
| `Build-Bicep`                     | `Get-BicepTemplates`              | `Build-Bicep.ps1`, through `Get-BicepTemplate.ps1`   |
| `Get-BicepTemplates`              | `Read-BicepTemplateOptions`       | `Get-BicepTemplates.ps1`                             |
| `Read-BicepTemplateOptions`       | `BicepShortName`                  | `Get-BicepTemplates.ps1`                             |
| `BicepShortName`                  | `BicepTemplate`                   | `Get-BicepTemplates.ps1`                             |
| `BicepTemplate`                   | `Resolve-BicepParameterAddresses` | `Build-Bicep.ps1`, across the start of the slot loop |
| `Resolve-BicepParameterAddresses` | `Invoke-AzCli`                    | `Build-Bicep.ps1`, after the slot loop               |

No edge enters either file. `options.yml` sits under the gate that reads it, and the EACH SLOT band places the parameters file.

## Legend

The legend panel spans the bottom of the drawing area in four columns:

| Swatch                    | Phrase                       |
| ------------------------- | ---------------------------- |
| slate rounded box         | code unit                    |
| dark slate rounded box    | private helper               |
| slate box with a `C#` tag | C# type                      |
| slate frame, no fill      | catzc module                 |
| rhombus, thick rim        | gate                         |
| green folded page         | file                         |
| arrow                     | flow: runs next (code order) |
| numbered disc             | marker: a Walkthrough step   |

## Sidebar

A lens badge reading `SRC · source lens`. Below it is a Supports panel listing ADR-AZ-DATAMOD#10, ADR-AZ-NAMING#2 and #6, ADR-AZ-CUSTOMER,
ADR-CONF-ADDRESSING#1 and #3, and ADR-AUTO-TYPES#9: the rules the drawn code cites. The drawn code also cites ADR-AUTO-CACHE,
ADR-PWSH-CACHE#4, ADR-PWSH-ERROR#8 and ADR-PWSH-PREPOST, which govern parts the slide leaves out. Source-lens slides carry no minimaps.

## Where the code and the ADR differ

The data-model diagram in ADR-AZ-DATAMOD labels the relation from a template to its options "short_name override", while its own options
entity and the code allow five keys: `short_name`, `deployment_mode`, `deployment_target`, `environment_kind` and `customer_deployment`.
