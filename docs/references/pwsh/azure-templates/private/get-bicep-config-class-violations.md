# pwsh/Azure.Templates/private/Get-BicepConfigClassViolations.ps1

The private function that returns the environment-class violations for a single resolved config. It is the shared rule used by both
`Get-BicepTemplates` (fail-fast at discovery) and `Assert-BicepTemplate` (collect-all), so the two never drift.

## help

### synopsis

Returns the env-class violations for a single resolved config — the shared rule used by both Get-BicepTemplates (fail-fast at discovery) and
Assert-BicepTemplate (collect-all), so the two never drift.

### description

Checks one config against the template's env-class bit and returns a (possibly empty) array of human-readable violation strings:

- env-class bit: subscription ⇒ the config env must be a per_subscription env (nsub/psub); standard ⇒ it must be a standard env.

The slot is a per-config dimension, not a template-level bit — a template may freely mix slotted (`<env>-<slot>.yml`) and non-slotted
(`<env>.yml`) configs — so there is no slot rule here. Empty result means the config conforms.

It rests on [ADR-AZ-DATAMOD-SCHEMAANDINTEGRITY](../../../../drs/azure/azure-data-model.md#rule-adr-az-datamod-schemaandintegrity).

### parameter `Environment`

The config's resolved environment name.

### parameter `EnvironmentKind`

The template's env-class bit ('standard' or 'subscription').

### parameter `AzureConfig`

The loaded azure config (Get-Config -Config azure) — used to read the env's per_subscription flag.

### parameter `Location`

A human-readable label for the config (e.g. 'configuration/apex/dev.yml') used in messages.
