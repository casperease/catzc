# pwsh/Azure.Templates/private/Get-BicepCustomerClassViolations.ps1

The private function that returns the customer-class violations for a single resolved config. It is the shared rule used by both
`Get-BicepTemplates` (fail-fast at discovery) and `Assert-BicepTemplate` (collect-all), so the two never drift, and it parallels
`Get-BicepConfigClassViolations`.

## help

### synopsis

Returns the customer-class violations for a single resolved config — the shared rule used by both Get-BicepTemplates (fail-fast at
discovery) and Assert-BicepTemplate (collect-all), so the two never drift. Parallels Get-BicepConfigClassViolations.

### description

Checks one config's customer and returns a (possibly empty) array of human-readable violation strings. The config's customer is its
configuration subfolder ('' for a configuration-root config). Whether a template is a customer deployment is inferred from the configuration
tree (a slot in a customer folder), never declared, so the rule needs only the customer:

- a root config (no customer) never violates;
- a customer config needs customer deployments enabled by the have_customers variant (Test-HaveCustomers) and its customer enabled
  (Test-HaveCustomer).

Empty result means the config conforms.

It rests on [ADR-AZ-CUSTOMER](../../../../drs/azure/azure-customer-model.md).

### parameter `Customer`

The configuration subfolder name (a customer key), or '' for a configuration-root config.

### parameter `Location`

A human-readable label for the config (e.g. 'configuration/acme/alpha.yml') used in messages.
