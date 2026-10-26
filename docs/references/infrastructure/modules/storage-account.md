# infrastructure/modules/storage-account.bicep

The reusable module for a StorageV2 account with the Well-Architected defaults.

## Defaults

- Zone-redundant (ZRS).
- No public network access.
- TLS 1.2 minimum and HTTPS only.
- No anonymous blob access and no shared-key access.
- A system-assigned managed identity.
- Soft delete on blobs and containers.

## Reaching it

Reach the account through a private endpoint (`../../modules/private-endpoint.bicep`, group id `blob`).

## Use

A template references it with a relative `module` declaration, for example `../../modules/storage-account.bicep` from a template's
`main.bicep`. `az bicep build` inlines the module into each template's `main.json`, so nothing from `infrastructure/modules/` ships
separately at deploy time.

Modules are not discovered as templates: `Get-BicepTemplates` scans only `infrastructure/templates/`.
