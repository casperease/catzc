---
catzc:
  immutable:
    with_body_sha: "1cff1a11cd39"
    repo_status: locked
    path: docs/references/automation/catzc-azure-templates/Assert-BicepTemplate.ps1.md
    folder: docs/references/automation/catzc-azure-templates
    name: assert-bicep-template-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
  edges:
    cites:
      - ADR-AZ-DATAMOD#9
---

# automation/Catzc.Azure.Templates/Assert-BicepTemplate.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

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

### parameter Template

Template name to validate. Omit to validate every template under infrastructure/templates/.

### parameter Build

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

## comment:1

Above `$folders = @([System.IO.Directory]::EnumerateDirectories($root) | Sort-Object)`, written with `#`.

```text
[System.IO.Directory] (sorted) instead of Get-ChildItem — see Get-BicepTemplates for the
~20ms-per-call Get-ChildItem overhead this avoids.
```

## comment:2

Above `$customerDeploymentOption = if ($options.Contains('customer_deployment')) {`, written with `#`.

```text
Customer-class bit — defaults to the have_customers variant unless options.yml sets it; an explicit
customer_deployment: true is only allowed when customers are enabled (see customer-model ADR).
```

## comment:3

Above `$shortNameOverride = if ($options.Contains('short_name')) {`, written with `#`.

```text
short_name is derived from the folder name unless options.yml overrides it. BicepShortName owns the
derivation + format validation (throws on a malformed override, or a folder that cannot derive a
valid short_name without one); the resolved value feeds the global-uniqueness check.
```

## comment:4

Above `$built = $false`, written with `#`.

```text
The full build (render + compile) so the rendered parameters files can be checked against the
compiled parameter model ([ADR-AZ-DATAMOD#9](/docs/adr/azure/azure-data-model.md#rule-adr-az-datamod9)).
```
