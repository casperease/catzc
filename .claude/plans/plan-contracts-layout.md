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

Decided 2026-10-26, reversing the vendor-root `applies_to`: a vendor root is the hard-locked copy of what the vendor promised and holds
nothing local. No asset under `ado`, `github` or `azure` is named after, or bound to, a repository file, and a vendor version folder has no
`contract.yml`. The binding lives at the consumer end: the module that owns the bound files (`Catzc.Azure.DevOps` for `.ado/pipelines/`,
`Catzc.Tooling.Github` for `.github/`, `Catzc.Azure.Templates` for its templates) declares in a config which vendor asset each of its globs
depends on, and `Test-Contracts` reads those declarations.

## Open steps

- [ ] Vendor roots hold vendor shapes only: delete the 7 per-pipeline fragments in `ado/0.1.0/pipelines/` and the 2 per-workflow fragments
      and the `README.md` presence asset in `github/0.1.0/`; what they pinned (`trigger`, `pr`, `extends.template`, `stages`, `jobs`) is
      already in `pipeline.yaml.schema.json`, or goes into it or `workflow.yml.schema.json` as the vendor's shape; delete every vendor
      `contract.yml`. Check: no file under a vendor root shares a name with a repository file.
- [ ] Consumer declarations: one config entry per owning module mapping its globs to a vendor asset path (`.ado/pipelines/**/*.yaml` →
      `ado/0.1.0/pipelines/pipeline.yaml.schema.json`, and so on), its default declared once on the config type; `ContractManifest` /
      `Resolve-ContractAsset` / `Get-ContractVersionAsset` read the consumer entries for vendor assets; tests follow, one file at a time.
      Check: the Contracts module's test files, then `Test-Contracts`.

- [ ] `Build-ContractReference`: one page per root (`docs/references/contracts/catzc.md`, `ado.md`, `github.md`, `azure.md`), its table per
      version with group, bound files, direction and kind; the `EXTERNAL-*` pages go with the writer's own clean-up; the contracts README
      follows. Check: `Test-GeneratedFiles` and `Test-Links` on `docs/references/contracts`.
- [ ] `ContractSchema`: `additionalProperties` as a schema, so the workflow schema checks each job and its steps, not only the top level.
      Check: `ContractSchema.Tests.ps1`, then `Test-Contracts` on the workflows.
