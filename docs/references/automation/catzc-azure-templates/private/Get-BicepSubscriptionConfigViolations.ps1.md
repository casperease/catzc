# automation/Catzc.Azure.Templates/private/Get-BicepSubscriptionConfigViolations.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Returns the subscription-resolution violations for a single config — the shared rule used by both Get-BicepTemplates (fail-fast at
discovery) and Assert-BicepTemplate (collect-all), so the two never drift. Parallels Get-BicepConfigClassViolations.

### description

A config lives at `configuration/<env>[-<slot>].yml` (a shared-platform config) or `configuration/<customer>/<env>[-<slot>].yml` (a customer
config). This checks the two conventional rules (returns a possibly-empty array of human-readable violations; the caller prepends the
template identifier):

- a configuration subfolder is always a customer KEY defined in customer.yml;
- the config's (customer?, environment) coordinate resolves to exactly ONE subscription (Get-BicepConfigSubscriptionCandidates) — the root
  rule: one non-customer subscription serves the env; the customer rule: one of the customer's subscriptions serves it.

Empty result means the config conforms.

It rests on [ADR-AZ-DATAMOD#8](../../../../adr/azure/azure-data-model.md#rule-adr-az-datamod8).

### parameter Customer

The configuration subfolder name, or '' for a configuration-root config.

### parameter Environment

The config's resolved environment name.

### parameter AzureConfig

The loaded azure config (Get-Config -Config azure) — used to read subscriptions.

### parameter Location

A human-readable label for the config (e.g. 'configuration/acme/alpha.yml') used in messages.
