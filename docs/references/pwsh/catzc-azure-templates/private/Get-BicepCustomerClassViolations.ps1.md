# pwsh/Catzc.Azure.Templates/private/Get-BicepCustomerClassViolations.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Returns the customer-class violations for a single resolved config — the shared rule used by both Get-BicepTemplates (fail-fast at
discovery) and Assert-BicepTemplate (collect-all), so the two never drift. Parallels Get-BicepConfigClassViolations.

### description

Checks one config against the template's `customer_deployment` bit and returns a (possibly empty) array of human-readable violation strings.
The config's customer is its configuration subfolder ('' for a configuration-root config). The rule is asymmetric:

- customer_deployment = false ⇒ the config must NOT live under a customer subfolder (a non-customer template ships root configs only);
- customer_deployment = true ⇒ a customer subfolder is allowed, but its customer must be ENABLED by the have_customers variant
  (Test-HaveCustomer). A true template may still ship root configs.

Empty result means the config conforms.

It rests on [ADR-AZ-CUSTOMER](../../../../adr/azure/azure-customer-model.md).

### parameter `Customer`

The configuration subfolder name (a customer key), or '' for a configuration-root config.

### parameter `CustomerDeployment`

The template's effective customer_deployment bit.

### parameter `Location`

A human-readable label for the config (e.g. 'configuration/acme/alpha.yml') used in messages.
