---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-templates/private/Resolve-BicepParameterAddresses.ps1.md
    kind: comment-page
    body_sha: ed1a5dccccf5
    adrs:
      - ADR-AZ-DATAMOD#10
      - ADR-CONF-ADDRESSING#1
      - ADR-CONF-ADDRESSING#3
---

# automation/Catzc.Azure.Templates/private/Resolve-BicepParameterAddresses.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
A parameter in a template config's `ParametersFile.parameters` takes one of three forms: a literal
`{ value: … }`, an ARM Key Vault `{ reference: … }`, or a config address `{ address: global.<config>.<key>… }`
([ADR-AZ-DATAMOD#10](/docs/adr/azure/azure-data-model.md#rule-adr-az-datamod10)). This resolves every address
through Get-ConfigValue
([ADR-CONF-ADDRESSING#1](/docs/adr/configuration/config-value-addressing.md#rule-adr-conf-addressing1)) and
returns the parameters with each addressed entry replaced by `{ value: <resolved node> }`; every other entry
passes through unchanged, in its order.

An address reaches only version-controlled config
([ADR-CONF-ADDRESSING#3](/docs/adr/configuration/config-value-addressing.md#rule-adr-conf-addressing3)), so no
secret can be addressed: a secure parameter takes a Key Vault reference, never an address.

Fails fast, with every violation in one throw that names the config file and each parameter: an entry that
sets `address` together with `value` or `reference` (or any other key), an address that is not a string, and
an address that does not resolve (an unknown config, a missing key, or a malformed address).
```
