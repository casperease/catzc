# infrastructure/modules/key-vault.bicep

The reusable module for a Key Vault. The vault is RBAC-authorized and carries no access policies, so access is granted through role
assignments only.

## Defaults

- **Purge protection is always on.** It is no parameter: once on it cannot be turned off, so no deployment may let a vault be purged.
- **Soft delete** keeps a deleted secret recoverable for `softDeleteRetentionInDays`, 90 days by default (7 to 90).
- **Public network access is off** (`publicNetworkAccess`, default `Disabled`), and the vault network is closed: its network rules deny by
  default and let only the trusted Azure services through, so Resource Manager still resolves a parameter file's Key Vault reference
  (`enabledForTemplateDeployment`, on by default). Everything else reaches the vault through a private endpoint, which the template that
  deploys the vault places (`private-endpoint.bicep`, group id `vault`).

## Use

A template references it with a relative `module` declaration (`../../modules/key-vault.bicep`), and `bicep build` inlines it into the
template's `main.json`.
