# pwsh/Azure.Templates/private/Get-BicepKeyVaultReferenceViolations.ps1

The private function that returns the ways an ARM Key Vault reference in a parameters file is not well-formed.

## help

### synopsis

Returns the ways an ARM Key Vault reference in a parameters file is not well-formed.

### description

A parameters-file entry may carry, instead of a value, an ARM Key Vault reference that the deployment resolves:
`{ "keyVault": { "id": "/subscriptions/…/providers/Microsoft.KeyVault/vaults/…" }, "secretName": "…" }`, with an optional `secretVersion`.
This checks that shape only — never the secret, which the repository does not hold. Returns zero or more messages, each the text that
follows "parameter '`<name>`' " in the caller's message. Used by Get-BicepParameterEntryViolations.

### parameter `Reference`

The `reference` object of a parameters-file entry.

### outputs

`[string[]]` the violations; empty when the reference is well-formed.
