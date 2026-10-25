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

## Open steps

The on-disk move and the mechanism land together in one pass, with a fresh full import right after: `Get-Contract` is read at every import
that renders the cats lookup.

- [ ] On disk: `contracts/catzc/0.0.0/<module>/` becomes `contracts/catzc/0.1.0/<module>/` for every command contract, schema and sample;
      `catzc.base.globs/configs/file-kinds.yml` becomes `catzc/0.1.0/catzc.base.globs/file-kinds.yml`; the 7 pipeline fragments move to
      `ado/0.1.0/pipelines/`, the 2 workflow fragments to `github/0.1.0/workflows/`, `.github/README.md`'s presence asset to
      `github/0.1.0/README.md`; `EXTERNAL-ado`, `EXTERNAL-github` and `EXTERNAL-azure` become `ado/0.1.0/pipelines/`,
      `github/0.1.0/workflows/` and `azure/0.1.0/templates/`; every `EXTERNAL-*/0.1.0` copy and its `.frozen` is deleted; each `0.1.0` gets
      one `contract.yml` whose `applies_to` names every fragment and file schema with repository-relative globs. Check:
      `Get-ChildItem contracts -Recurse -Directory` shows no folder deeper than root/version/group and no `0.0.0` or `EXTERNAL-`.
- [ ] `Catzc.Base.Contracts` mechanism: enumerate root/version/[group]/asset with the depth check; direction from the root; `0.1.0` current,
      `1.0.0`+ a `catzc` release, any other version, `6.6.666`, or a vendor release a finding; `applies_to` repository-relative and required
      for every fragment and file schema; delete `ContractsConfig`, `contracts.yml`, its `configs.yml` entry, target roots, the addressing
      modes and `contract.yml` `direction`; the asset's `Module` becomes its `Group`; `-Unit` becomes `-Root` in `Get-Contract`,
      `Get-CommandContract`, `Test-Contracts` and `Publish-ContractRelease`, with their command contracts edited in the same change. Check:
      the Contracts module's test files, one at a time, then `Test-Contracts`.
- [ ] `Publish-ContractRelease`: copies `catzc/0.1.0` as `catzc/<version>` for a version from `1.0.0` up, and refuses a vendor root, `0.x`,
      and `6.6.666`. Check: `Publish-ContractRelease.Tests.ps1` and `Get-ContractFreezeFindings.Tests.ps1`.
- [ ] Bindings to the old paths: `Get-CommandContract` and `Test-Contracts` default to `0.1.0`; `New-CatsCommandLookup` header, then
      regenerate `pwsh/.internal/assets/importer-commands.sh`; `bash/tests/catzc-base-engines/cats.bats` fixture rows and
      `bash/tests/catzc-base-contracts/contracts.bats` (`-Root ado`); `vscode-settings.yml` `yaml.schemas` and `json.schemas` paths;
      `generated-files.yml` and `rootconfig.yml` `contracts/catzc/0.0.0` entries; `terminology.yml` scopes; the two `accosted` run lists;
      the `MinimapData.cs` comment. Check: `Invoke-BashTest Catzc.Base.Engines` and `Catzc.Base.Contracts`, `New-VsCodeSettings`, then
      `Test-GeneratedFiles`.
- [ ] `Build-ContractReference`: one page per root (`docs/references/contracts/catzc.md`, `ado.md`, `github.md`, `azure.md`), its table per
      version with group, bound files, direction and kind; the `EXTERNAL-*` pages go with the writer's own clean-up; the contracts README
      follows. Check: `Test-GeneratedFiles` and `Test-Links` on `docs/references/contracts`.
- [ ] `ContractSchema`: `additionalProperties` as a schema, so the workflow schema checks each job and its steps, not only the top level.
      Check: `ContractSchema.Tests.ps1`, then `Test-Contracts` on the workflows.
