# `<name>`

One or two sentences: what `<name>` deploys and its single responsibility; what it deliberately does not own; and any cross-template
dependency (for example, it needs `foundation`'s Key Vault). Link the governing ADR(s) (`../../adr/azure/...`).

## Resources

- `<Azure resource>` — via `<module>.bicep`
- `<Azure resource>` — via `<module>.bicep`

## Configuration

- `short_name`: `<xxx>`; `environment_kind`: `standard` (per environment) or `subscription` (once per subscription).
- `<the environments, and slots if any, it targets>`
- `configuration/[<customer>/]<env>[-<slot>].yml` — `<which root/customer configs are shipped>`.
- `<any PrePost.psm1 behaviour, e.g. injecting a secret from foundation's Key Vault>`

## Modules used

- `<module>.bicep` — see [modules](modules.md).
