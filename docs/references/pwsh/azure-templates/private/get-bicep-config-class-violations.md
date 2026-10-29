# pwsh/Azure.Templates/private/Get-BicepConfigClassViolations.ps1

The private function that returns the environment-class violations for a single resolved config. It is the shared rule used by both
`Get-BicepTemplates` (fail-fast at discovery) and `Assert-BicepTemplate` (collect-all), so the two never drift.

## help

### synopsis

Returns the env-class violations for a single resolved config — the shared rule used by both Get-BicepTemplates (fail-fast at discovery) and
Assert-BicepTemplate (collect-all), so the two never drift.

### description

Checks the environments of a template's slots and returns a (possibly empty) array of human-readable violation strings. The template's
environment kind is inferred, never declared: each environment is classed by its `per_subscription` flag in `azure.yml`, and the only
violation is a template whose slots mix per-subscription environments (nsub/psub) with standard ones. Such a template splits into two
templates.

The slot is a per-config dimension, not a template-level bit — a template may freely mix slotted (`<env>-<slot>.yml`) and non-slotted
(`<env>.yml`) configs — so there is no slot rule here. Empty result means the environments share one class.

It rests on [ADR-AZ-DATAMOD-SCHEMAANDINTEGRITY](../../../../drs/azure/azure-data-model.md#rule-adr-az-datamod-schemaandintegrity).

### parameter `Environment`

The environment names of the template's slots (may be empty).

### parameter `AzureConfig`

The loaded azure config (Get-Config -Config azure) — used to read each env's per_subscription flag.

### parameter `Location`

A human-readable label for the template (used in messages).
