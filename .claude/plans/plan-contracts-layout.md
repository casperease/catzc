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

- [ ] `api-contracts.md`: rewrite the `applies_to` rule and the tree and example blocks (lines near 90, 114, 179-186, 230-271, 322) to the
      consumer-end binding above; `catzc/0.1.0/contract.yml` keeps `applies_to` only for what `catzc` provides. Check: `Test-Links` and
      `Test-Spelling` on the page.
- [ ] Vendor roots hold vendor shapes only: delete the 7 per-pipeline fragments in `ado/0.1.0/pipelines/` and the 2 per-workflow fragments
      and the `README.md` presence asset in `github/0.1.0/`; what they pinned (`trigger`, `pr`, `extends.template`, `stages`, `jobs`) is
      already in `pipeline.yaml.schema.json`, or goes into it or `workflow.yml.schema.json` as the vendor's shape; delete every vendor
      `contract.yml`. Check: no file under a vendor root shares a name with a repository file.
- [ ] Consumer declarations: one config entry per owning module mapping its globs to a vendor asset path (`.ado/pipelines/**/*.yaml` →
      `ado/0.1.0/pipelines/pipeline.yaml.schema.json`, and so on), its default declared once on the config type; `ContractManifest` /
      `Resolve-ContractAsset` / `Get-ContractVersionAsset` read the consumer entries for vendor assets; tests follow, one file at a time.
      Check: the Contracts module's test files, then `Test-Contracts`.

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
