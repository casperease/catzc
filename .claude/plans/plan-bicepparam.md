---
plan:
  status: active
  value: medium
  reviewed: 2026-10-21
  class: feature
  targets:
    [
      pwsh/Catzc.Azure.Templates,
      pwsh/Catzc.Base.Languages/configs/languages.yml,
      pwsh/Catzc.Base.QualityGates/private/Invoke-BicepFormat.ps1,
      pwsh/Catzc.Base.Globs/configs/file-kinds.yml,
      docs/adr/azure/azure-data-model.md,
      infrastructure/templates,
    ]
---

# Bicep parameters files: `.bicepparam` as a source format and as the render of the yml configs

A template slot's parameters live today in `configuration/[<customer>/]<env>[-<slot>].yml` under `ParametersFile.parameters`, and
`Build-Bicep` writes them out as an ARM `parameters.[<customer>.]<config>.json`. Bicep's own parameters format, `.bicepparam`
(`using '<template>'` plus `param <name> = <expression>`), is typed against the template by the Bicep compiler and formatted by
`bicep format`. This plan adds three things: a renderer from the yml config to `.bicepparam`, the `.bicepparam` format under the formatter,
and `.bicepparam` as a hand-authored slot config the build reads directly, in the Bicep language beside `.bicep`.

## Why its value is medium

A `.bicepparam` file is checked by the compiler against `main.bicep` at authoring time (names, types, `@allowed`), in the editor through the
Bicep extension, which moves part of the parameter contract (ADR-AZ-DATAMOD-PARAMETERCONTRACT) left of the build. The yml config keeps what
the Bicep format has no form for: the config address (ADR-AZ-DATAMOD-VALUEBYADDRESS) and the PrePost hook's input. Nothing deployed changes:
the deploy still reads the compiled ARM parameters JSON.

## Proposed (waits on the open questions)

- **One language, two extensions.** `.bicepparam` joins the existing `bicep` entry in `languages.yml` (`extensions: [.bicep, .bicepparam]`),
  so it takes the `bicep` formatter, the `//` comment head from `file-carriers.yml`, and the same checks
  (ADR-AUTO-MODULE-LANGUAGESFROMFILES).
- **One config per coordinate.** A slot config is `<env>[-<slot>].yml` or `<env>[-<slot>].bicepparam`, never both; discovery
  (`Get-BicepTemplates`, `Assert-BicepTemplate`) fails on both, naming the coordinate (extends ADR-AZ-DATAMOD-ONEFILEONESUBSCRIPTION).
- **One path to the deploy artifact.** Every slot becomes a `.bicepparam` in the build output: a yml slot is rendered after its addresses
  resolve and its PrePost hook runs; a `.bicepparam` slot is taken as written. `bicep build-params` compiles each to the
  `parameters.[<customer>.]<config>.json` that the parameter contract check and `Deploy-Bicep` read as now, so `BicepArtifacts` and the
  deploy do not change.
- **The mapping, yml to `.bicepparam`:** `value` → `param <name> = <Bicep literal>` (objects, arrays, strings, ints, bools; a quoted `"0.5"`
  stays a string); `reference.keyVault.id` + `secretName` [+ `secretVersion`] →
  `az.getSecret('<subscription>', '<resource group>', '<vault>', '<secret>'[, '<version>'])`, parsed from the vault id; `address` → the
  resolved literal (resolution runs first, as now).
- **Renderer as a type** (type-first): `Catzc.Azure.Templates.BicepParamWriter` turns an ordered parameter map and a `using` path into
  `.bicepparam` text; `ConvertTo-BicepParam` is its public PowerShell face, and `Build-Bicep` calls it.
- The `using` path in a source `.bicepparam` is the relative path to the template's `main.bicep`, asserted at discovery.
- `Set-BicepTemplateConfiguration` edits only a yml slot; for a `.bicepparam` slot it throws, naming the file, since a hand-authored source
  is edited by hand.

## Open questions

1. **Where does the render land?** (a, recommended) the build output only, `out/…/<config>.bicepparam`, never tracked: the yml stays the one
   source and nothing in the tree needs a generated head; (b) a tracked generated file beside the yml, with a generated head and body sha:
   two files per coordinate, which the one-config rule then has to except.
2. **Two living source formats, or a migration?** (a, recommended, as asked) both stay: yml for slots that need an address or the PrePost
   hook, `.bicepparam` for the rest, plus `New-BicepParamSource`, which writes a slot's `.bicepparam` from its yml and deletes the yml, so a
   slot moves over in one step; (b) every slot migrates and the yml format is deleted (ADR-PRIN-ONELIVE), which first needs answers for
   addresses and PrePost in `.bicepparam`. Option (a) is a second format for one concern, which ADR-PRIN-REDUCEVAR weighs against.
3. **A config address in a `.bicepparam` source?** (a, recommended) none: a `.bicepparam` slot holds literals and `az.getSecret` only, and a
   slot that needs an address stays yml; (b) a convention the build resolves (for example `readEnvironmentVariable('CATZC_<address>')`
   injected at build), which hides a catzc mechanism inside a vendor format.
4. **A PrePost template with a `.bicepparam` slot?** (a, recommended) discovery refuses the pair, naming the template and the file; (b) the
   hook receives the compiled parameters JSON instead of the yml descriptor, which changes the hook's input for every template.
5. **Language entry.** The request says "new language Bicep"; `bicep` is already a language in `languages.yml` (formatter `bicep`, `.bicep`
   only). (a, recommended) add the extension to it; (b) a separate `bicepparam` language with its own checks.

## Open steps

### 1. Spike the Bicep CLI at the pin (0.48)

- [ ] `out/spike-bicepparam.ps1`: on a copy of `infrastructure/templates/expedition/`, write a `.bicepparam` with `using '../main.bicep'`
      and an `az.getSecret(...)` parameter; run `bicep build-params` and `bicep format` on it from a temp folder, and record whether format
      needs the `using` target to resolve and whether the compiled secret is the ARM Key Vault `reference` the contract check reads (check:
      the script prints both answers; they are folded into the steps below before step 2 starts).

### 2. The rules first (ADR-REPO-PLANS-DECISIONSBECOMERULES)

- [ ] `docs/adr/azure/azure-data-model.md`: extend ADR-AZ-DATAMOD-ONEFILEONESUBSCRIPTION to `.yml` or `.bicepparam`; add a rule for the
      `.bicepparam` slot source (its `using` path, literals and `az.getSecret` only, no PrePost) and one for the render (one path to the
      compiled JSON, the mapping above); the Layer 2 prose and the mermaid `SLOT_CONFIG` follow (check: `Test-AdrIndex`, `Test-Links` on the
      page).
- [ ] `pwsh/Catzc.Azure.Templates/configs/glossary.yml`: the defined terms the new rules bold (check: `Test-Glossary`, `Build-Glossary`; via
      `glossary-keeper`).

### 3. Bicep language and formatter

- [ ] `pwsh/Catzc.Base.Languages/configs/languages.yml`: `bicep.extensions: [.bicep, .bicepparam]` (check: `Invoke-TestFile` on
      `tests/types/LanguagesConfig.Tests.ps1`, `Test-ShippedConfigs`).
- [ ] `pwsh/Catzc.Base.QualityGates/private/Invoke-BicepFormat.ps1`: each numbered copy keeps its own extension (`<n>.bicep` or
      `<n>.bicepparam`) and the pattern takes both, per the spike's answer on `using` (check: `Invoke-TestFile` on
      `tests/Invoke-BicepFormat.Tests.ps1`, with a `.bicepparam` case added).
- [ ] `pwsh/Catzc.Base.Globs/configs/file-kinds.yml`: `template.config` takes `infrastructure/templates/**/configuration/**/*.bicepparam`
      (check: `Invoke-TestFile` on `tests/Get-FileKind.Tests.ps1`).
- [ ] `pwsh/Catzc.Base.QualityGates/configs/terminology.yml` (or the spelling list it owns): `bicepparam` is a known word (check:
      `Test-Spelling` on this plan's changed files).

### 4. The renderer

- [ ] `pwsh/Catzc.Azure.Templates/types/BicepParamWriter.cs`: ordered map + `using` path → `.bicepparam` text in `bicep format`'s layout;
      the Key Vault id parse throws on a malformed id, naming the parameter (check: `Invoke-TestFile` on
      `tests/types/BicepParamWriter.Tests.ps1`, widget/gadget fixtures, every value kind and a secret).
- [ ] `pwsh/Catzc.Azure.Templates/ConvertTo-BicepParam.ps1`: a slot's prepared descriptor to `.bicepparam` text (check: `Invoke-TestFile` on
      its tests; the output for each shipped yml slot passes `bicep format` unchanged, at L2).

### 5. Discovery reads both formats

- [ ] `pwsh/Catzc.Azure.Templates/Get-BicepTemplates.ps1`: enumerate `*.yml` and `*.bicepparam`; both for one coordinate throws; each slot
      carries its source format (check: `Invoke-TestFile` on `tests/Get-BicepTemplates.Tests.ps1`).
- [ ] `pwsh/Catzc.Azure.Templates/types/BicepSlot.cs`: the slot's config file and format (check: its type tests).
- [ ] `pwsh/Catzc.Azure.Templates/Assert-BicepTemplate.ps1`: the same enumeration, the `using` assert, the PrePost refusal (question 4), and
      the contract check over a `.bicepparam` slot's compiled parameters (check: `Invoke-TestFile` on
      `tests/Assert-BicepTemplate.Tests.ps1`).
- [ ] `pwsh/Catzc.Azure.Templates/Get-BicepTemplateConfiguration.ps1`: return the yml descriptor for a yml slot and the source path for a
      `.bicepparam` slot (check: `Invoke-TestFile` on its tests).
- [ ] `pwsh/Catzc.Azure.Templates/Set-BicepTemplateConfiguration.ps1`: throw on a `.bicepparam` slot (check: `Invoke-TestFile` on its
      tests).
- [ ] `pwsh/Catzc.Azure.Templates/tests/assets/templates/sample-bicepparam/`: a test template with one `alpha.bicepparam` slot and one
      `beta.yml` slot (check: `Invoke-TestFile` on `tests/Get-BicepTemplates.Tests.ps1`).

### 6. The build renders and compiles

- [ ] `pwsh/Catzc.Azure.Templates/Build-Bicep.ps1`: per slot, write the `.bicepparam` (rendered from yml, or copied from the source with its
      `using` re-pointed per the spike) and compile it with `bicep build-params` to the parameters JSON name `Get-BicepParametersFileName`
      gives (check: `Invoke-TestFile` on `tests/Build-Bicep.Tests.ps1` and a new `tests/Build-Bicep.SampleBicepparam.Tests.ps1`; the
      existing `Build-Bicep.Sample*` tests stay green, their JSON byte-equal to the pre-change output).
- [ ] `pwsh/Catzc.Azure.Templates/tests/Build-Bicep.Integrity.Tests.ps1`: every shipped template builds through the new path (check:
      `Invoke-TestFile` on it).

### 7. The migration command (when question 2 is a)

- [ ] `pwsh/Catzc.Azure.Templates/New-BicepParamSource.ps1`: write a yml slot's `.bicepparam` source beside it and delete the yml; refuses a
      slot with an address or a PrePost template; `-DryRun` (ADR-PWSH-DRYRUN) (check: `Invoke-TestFile` on its tests).

## Refs

- [azure-data-model](../../docs/adr/azure/azure-data-model.md) (ADR-AZ-DATAMOD-ONEFILEONESUBSCRIPTION, -PARAMETERCONTRACT, -VALUEBYADDRESS),
  [infrastructure-kinds](../../docs/adr/azure/infrastructure-kinds.md), [module-model](../../docs/adr/automation/module-model.md)
- `pwsh/Catzc.Azure.Templates/Build-Bicep.ps1`, `private/Get-BicepParametersFileName.ps1`, `private/Resolve-BicepParameterAddresses.ps1`,
  `private/Get-BicepParameterViolations.ps1`
- `pwsh/Catzc.Base.Execution/configs/tools.yml#bicep` (the 0.48 pin)
