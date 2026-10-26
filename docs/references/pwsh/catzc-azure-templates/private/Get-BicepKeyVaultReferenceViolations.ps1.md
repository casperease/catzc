# pwsh/Azure.Templates/private/Get-BicepKeyVaultReferenceViolations.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

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
