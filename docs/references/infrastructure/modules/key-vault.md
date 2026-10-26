# infrastructure/modules/key-vault.bicep

The reusable module for a Key Vault. The vault is RBAC-authorized and carries no access policies, so access is granted through role
assignments only.

## Use

A template references it with a relative `module` declaration (`../../modules/key-vault.bicep`), and `az bicep build` inlines it into the
template's `main.json`.
