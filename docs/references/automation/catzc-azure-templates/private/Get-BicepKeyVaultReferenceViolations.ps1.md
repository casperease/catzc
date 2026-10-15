---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-templates/private/Get-BicepKeyVaultReferenceViolations.ps1.md
    kind: comment-page
    body_sha: "6983f5a59415"
    adrs: []
---

# automation/Catzc.Azure.Templates/private/Get-BicepKeyVaultReferenceViolations.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
A parameters-file entry may carry, instead of a value, an ARM Key Vault reference that the deployment resolves:
`{ "keyVault": { "id": "/subscriptions/…/providers/Microsoft.KeyVault/vaults/…" }, "secretName": "…" }`, with an
optional `secretVersion`. This checks that shape only — never the secret, which the repository does not hold.
Returns zero or more messages, each the text that follows "parameter '<name>' " in the caller's message.
Used by Get-BicepParameterEntryViolations.
```
