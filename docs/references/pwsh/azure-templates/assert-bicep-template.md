# pwsh/Azure.Templates/Assert-BicepTemplate.ps1

The command that validates one bicep template, or all of them, against its `options.yml` and the azure config. It collects every problem and
throws one consolidated error, the explicit, author- and CI-facing counterpart to the fail-fast checks `Get-BicepTemplates` runs at
discovery.

## help

### synopsis

Validates a bicep template (or all templates) against its options.yml and the azure config, collecting every problem and throwing one
consolidated error. The explicit, author/CI-facing counterpart to the fail-fast checks Get-BicepTemplates runs at discovery.

### description

Where Get-BicepTemplates enforces the rules at discovery and throws on the first violation (so a bad template makes the whole module fail to
load), Assert-BicepTemplate scans a template folder directly and reports ALL of its problems at once — so it can describe a template that
discovery would reject. The two share the per-config rule (Get-BicepConfigClassViolations), so they never drift.

Checks (all collected, then thrown together):

- main.bicep exists; configuration/ exists with at least one (non-default) config.
- options.yml (optional) is schema-valid (Read-BicepTemplateOptions); short_name is resolved from the folder name (or the options.yml
  override) via BicepShortName and — when validating all templates — globally unique.
- Env-class classification: every config matches the template's env-class bit (standard/subscription) — via Get-BicepConfigClassViolations.
  (Slot is per-config: a template may mix slotted and non-slotted configs.)
- Identity references: each config filename resolves to a defined environment; a configuration subfolder is always a defined customer key,
  and every config's (customer?, env) coordinate resolves to exactly one subscription (Get-BicepSubscriptionConfigViolations).
- Parameter alignment: a config's ParametersFile.parameters may only set parameters that main.bicep declares (params main.bicep declares but
  the config omits are fine — PrePost or bicep defaults supply them).
- With -Build: Build-Bicep renders the parameters files and compiles main.bicep (needs az; opt-in, slower, and writes the template's build
  output folder), then Get-BicepParameterViolations checks every rendered parameters file against the compiled parameter model — types,
  @allowed values, bounds, required parameters, and Key Vault references for secure parameters.

### parameter `Template`

Template name to validate. Omit to validate every template under infrastructure/templates/.

### parameter `Build`

Also build the template (requires az CLI) and check its rendered parameters files against the compiled parameter model. Off by default.

### example 1

```powershell
Assert-BicepTemplate my-template
```

### example 2

```powershell
Assert-BicepTemplate            # validate every template
```

### example 3

```powershell
Assert-BicepTemplate my-template -Build   # also compile with az
```

## Customer class

The customer-class bit defaults to the `have_customers` variant unless `options.yml` sets `customer_deployment`. An explicit
`customer_deployment: true` is allowed only when customers are enabled ([ADR-AZ-CUSTOMER](../../../drs/azure/azure-customer-model.md)).

## Short name

`short_name` is derived from the folder name unless `options.yml` overrides it. `BicepShortName` owns the derivation and the format
validation, and throws on a malformed override or on a folder that cannot derive a valid short name without one. The resolved value feeds
the global-uniqueness check.

## Parameters

The command runs the full build, render and compile, so the rendered parameters files can be checked against the compiled parameter model
([ADR-AZ-DATAMOD-PARAMETERCONTRACT](../../../drs/azure/azure-data-model.md#rule-adr-az-datamod-parametercontract)).
