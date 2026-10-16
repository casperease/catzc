---
catzc:
  immutable:
    with_body_sha: "7e76dc3b171b"
    path: docs/.assets/references/automation/catzc-azure-templates/bicep-template-is-a-folder.drawio.verify.md
    folder: docs/.assets/references/automation/catzc-azure-templates
    name: bicep-template-is-a-folder-drawio-verify
    filetype: md
    kind: asset-description
    language: markdown
    track: docs
  edges:
    cites:
      - ADR-AUTO-TYPES#9
      - ADR-AZ-DATAMOD#10
      - ADR-AZ-NAMING#2
      - ADR-CONF-ADDRESSING#1
      - ADR-PWSH-CACHE#4
      - ADR-PWSH-ERROR#8
---

# Verification: A template is a folder; options.yml overrides five defaults (source lens, Catzc.Azure.Templates)

Every line below was re-read on 2026-10-15 after the comment export; none of the scout's numbers is reused (for example the `allowedKeys`
line moved from `Read-BicepTemplateOptions.ps1:52` to `:32`, and `Invoke-AzCli bicep build` from `Build-Bicep.ps1:160` to `:144`).
`condense-comments` may move them again, so re-grep before landing. Paths are relative to `automation/Catzc.Azure.Templates/` unless they
start with `automation/` or `docs/`.

## Boxes

| #   | Claim (box)                                                                     | Source (`file:line`)                                                                                                                                                      | Status    |
| --- | ------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------- |
| B1  | `Build-Bicep` is a public function (code unit)                                  | `Build-Bicep.ps1:26`, module root                                                                                                                                         | confirmed |
| B2  | `Get-BicepTemplates` is public and enumerates one template per folder           | `Get-BicepTemplates.ps1:12,43-44`; root `private/Get-BicepTemplatesRoot.ps1:14`                                                                                           | confirmed |
| B3  | A folder must hold `main.bicep` and `configuration/` (band EACH FOLDER)         | `Get-BicepTemplates.ps1:46-50`                                                                                                                                            | confirmed |
| B4  | `Read-BicepTemplateOptions` is private and a gate: it throws on any invalid key | `private/Read-BicepTemplateOptions.ps1:13,70-72`                                                                                                                          | confirmed |
| B5  | It reads the optional `options.yml` beside `main.bicep` (file)                  | `private/Read-BicepTemplateOptions.ps1:20-25`; absent file returns no overrides `:21-23`                                                                                  | confirmed |
| B6  | The gate allows exactly five keys (title: "five")                               | `private/Read-BicepTemplateOptions.ps1:32,35-38`                                                                                                                          | confirmed |
| B7  | Each of the five has a derived default when absent                              | `Get-BicepTemplates.ps1:56-61` (`standard`), `:75-80` (`have_customers`), `:91` (short_name from folder), `:164-165` (`Incremental`, `ResourceGroup`), overlay `:172-177` | confirmed |
| B8  | `BicepShortName` is a C# type that resolves the folder name or the override     | `types/BicepShortName.cs:11,38-61`                                                                                                                                        | confirmed |
| B9  | `BicepTemplate` is a C# type built once per folder                              | `types/BicepTemplate.cs:10`; `Get-BicepTemplates.ps1:189`                                                                                                                 | confirmed |
| B10 | `Resolve-BicepParameterAddresses` is private (name elided on the slide)         | `private/Resolve-BicepParameterAddresses.ps1`                                                                                                                             | confirmed |
| B11 | One `parameters.<config>.json` is written per slot (band EACH SLOT)             | `Build-Bicep.ps1:89,138-139`; name from `private/Get-BicepParametersFileName.ps1:34-39` (`parameters.<customer>.<config>.json` for a customer slot)                       | confirmed |
| B12 | `Invoke-AzCli` lives in the other module `Catzc.Azure.Cli` (catzc module frame) | `automation/Catzc.Azure.Cli/Invoke-AzCli.ps1`                                                                                                                             | confirmed |

## Edges (flow: runs next, in code order)

| #   | Edge                                                                         | Source (`file:line`)                                                                 | Status    |
| --- | ---------------------------------------------------------------------------- | ------------------------------------------------------------------------------------ | --------- |
| E1  | `Build-Bicep` → `Get-BicepTemplates`                                         | `Build-Bicep.ps1:46` (`Get-BicepTemplate`, cut) → `Get-BicepTemplate.ps1:22`         | confirmed |
| E2  | `Get-BicepTemplates` → `Read-BicepTemplateOptions`                           | `Get-BicepTemplates.ps1:52`                                                          | confirmed |
| E3  | `Read-BicepTemplateOptions` → `BicepShortName`                               | `Get-BicepTemplates.ps1:52,91` (`[BicepShortName]::Resolve`)                         | confirmed |
| E4  | `BicepShortName` → `BicepTemplate`                                           | `Get-BicepTemplates.ps1:91,189` (`[BicepTemplate]::new`)                             | confirmed |
| E5  | `BicepTemplate` → `Resolve-BicepParameterAddresses` (crosses into EACH SLOT) | `Build-Bicep.ps1:46,89,113` (`Assert-AzCliBicep` at `:66` sits between, cut)         | confirmed |
| E6  | `Resolve-BicepParameterAddresses` → `Invoke-AzCli`                           | `Build-Bicep.ps1:113,144`; the build runs once, after the slot loop closes at `:141` | confirmed |

## Bands, sidebar

| #   | Claim                                                                   | Source (`file:line`)                                                   | Status    |
| --- | ----------------------------------------------------------------------- | ---------------------------------------------------------------------- | --------- |
| C1  | EACH FOLDER: the gate, the short name and the descriptor run per folder | `Get-BicepTemplates.ps1:43-190`                                        | confirmed |
| C2  | EACH SLOT: address resolution and the parameters file run per slot      | `Build-Bicep.ps1:89-141`                                               | confirmed |
| C3  | Supports ADR-AZ-DATAMOD#10                                              | `Build-Bicep.ps1:103`; `private/Resolve-BicepParameterAddresses.ps1:6` | confirmed |
| C4  | Supports ADR-AZ-NAMING#2, #6                                            | `Get-BicepTemplates.ps1:83`; `types/BicepShortName.cs:2,82`            | confirmed |
| C5  | Supports ADR-AZ-CUSTOMER                                                | `Get-BicepTemplates.ps1:64`; `types/BicepTemplate.cs:55`               | confirmed |
| C6  | Supports ADR-CONF-ADDRESSING#1, #3                                      | `private/Resolve-BicepParameterAddresses.ps1:7-8`                      | confirmed |
| C7  | Supports ADR-AUTO-TYPES#9                                               | `types/BicepShortName.cs:3`                                            | confirmed |

Not on the chips (cited by the drawn code, left to the `.md`): ADR-AZ-DATAMOD (bare, `Get-BicepTemplates.ps1:7,54`), ADR-AUTO-CACHE (`:19`),
ADR-PWSH-CACHE#4 (`:23`), ADR-PWSH-ERROR#8 and ADR-PWSH-PREPOST (`Build-Bicep.ps1:81,117`). `Invoke-AzCli.ps1` and
`Read-BicepTemplateOptions.ps1` cite no ADR.

Counts: 25 claims, 25 confirmed, 0 contradicted, 0 ADR-only.

## Corrections

- The brief's sketch ran `Invoke-AzCli bicep build` before "one parameters file per slot". The code writes every slot's parameters file
  inside the slot loop (`Build-Bicep.ps1:138-139`) and runs `az bicep build` once after it (`:144`), which emits `main.json`, not the
  parameters files. The slide draws the parameters file inside EACH SLOT and the build outside it.
- `Build-Bicep` does not call `Get-BicepTemplates` directly; it calls `Get-BicepTemplate` (`:46`), which filters `Get-BicepTemplates`
  (`Get-BicepTemplate.ps1:22`). E1 is drawn through that cut box.
- The brief's count chip on the parameters file has no fixed number (one file per slot, the slot count varies per template), so it is not
  drawn; the bands carry "per folder" and "per slot". The "five" is in the title, so no count chip repeats it on the gate.
- The template folder named set was cut: the EACH FOLDER band carries it, which keeps the slide at four kinds and the legend at eight.

## Drift

- `docs/adr/azure/azure-data-model.md:239` labels the TEMPLATE → TEMPLATE_OPTIONS relation "options.yml (OPTIONAL; short_name override)",
  but the same diagram's TEMPLATE_OPTIONS entity (`:256-262`) and the code (`private/Read-BicepTemplateOptions.ps1:32`) allow five keys:
  `short_name`, `deployment_mode`, `deployment_target`, `environment_kind`, `customer_deployment`. The drift is inside the ADR; the code and
  the entity agree.

## Cut

`Get-BicepTemplate` (`Build-Bicep.ps1:46`), `Assert-AzCliBicep` (`:66`, module Catzc.Azure.Cli), the PrePost hook
`Invoke-BicepPrepareParameterSet` (`:73-87,126-131`), `Get-BicepTemplateConfiguration` / `ConvertTo-FlatSettingSet` and the `UNDEFINED`
check (`:91-100`), `Get-BicepParametersFileName` (`:138`), the `main.json` assertion (`:148-153`), the per-slot config validators
(`Get-BicepTemplates.ps1:123-143`), the session cache (`:21-30`) and the duplicate short_name check (`:193-196`). Each is one more box past
the cap of 10.
