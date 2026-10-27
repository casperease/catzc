# infrastructure/modules/sql-server.bicep

The reusable module for a SQL logical server with the Well-Architected defaults.

## Defaults

- An Entra ID administrator, a group by default.
- Entra-only authentication.
- No public network access.
- TLS 1.2 minimum.
- A system-assigned managed identity.

## Reaching it

Reach the server through a private endpoint (`../../modules/private-endpoint.bicep`, group id `sqlServer`). Databases are separate
(`../../modules/sql-database.bicep`).

## Break-glass login

A SQL login is opt-in: pass `entraOnlyAuthentication: false` together with `administratorLogin` and `administratorLoginPassword`, the
password as a Key Vault reference.

## Use

A template references it with a relative `module` declaration, and `bicep build` inlines it.
