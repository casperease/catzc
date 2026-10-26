---
plan:
  status: active
  value: high
  reviewed: 2026-10-25
  targets: [contracts, pwsh/Catzc.Base.Contracts, docs/references/contracts]
---

# Contracts: one root per promiser, current at 0.1.0, flat, addressed by applies_to

The decision landed in `docs/drs/repository/api-contracts.md` (decided 2026-10-25, with command-contracts, conventional-folders and
one-living-version in step): `contracts/<root>/<version>/[<group>/]<asset>`; `catzc` is provided, every other root a vendor and depended-on;
`0.1.0` is the one current version every internal binding points at, the rest of `0.1` reserved, `0.0.0` never a folder, `1.0.0` and up
frozen `catzc` releases, `6.6.666` never a folder; the files a fragment or file schema binds are named only in its version's `contract.yml`
`applies_to`, as repository-relative globs. The tree and the code still carry the old layout; these steps move both.

Decided 2026-10-26: a shape we wrote is an inner contract and lives in `catzc` under its owning module's group, even when it describes a
file a vendor reads, bound by `catzc/0.1.0/contract.yml` `applies_to`; a vendor root holds only a shape the vendor ships, copied verbatim,
so today `catzc` is the only root.

## Open steps

- [ ] `ContractSchema`: `additionalProperties` as a schema, so the workflow schema checks each job and its steps, not only the top level.
      Check: `ContractSchema.Tests.ps1`, then `Test-Contracts` on the workflows.
