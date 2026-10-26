---
plan:
  status: active
  value: high
  reviewed: 2026-10-26
  class: feature
  targets: [contracts/catzc/0.1.0, pwsh/.internal/assets/types, pwsh/Base.Contracts]
---

# Module types contracts: each module group publishes its compiled type surface beside its command contracts

Each module group under `contracts/catzc/<version>/` carries a `types.json`: that module's public types (name, members, aliases) as the
compiler builds them into the types DLL. It replaces the one global types sample, and every command contract's parameter and output type
names are checked against the surfaces.

## Decided (the user, 2026-10-26)

- A types contract per module group, `contracts/catzc/<version>/<group>/types.json`, beside the group's command contracts.
- Its content comes from the compiled DLL (the Add-Type build), never written by hand: a generated contract, as the global types sample is
  today.

## Open steps

1. [ ] The writer: Write-TypesContract renders one `types.json` per module group from the compiled assembly (the group from
       Get-ContractGroup), written only when a module's surface moves, and the global `pwsh.internal.types` sample goes in the same change
       (one living version); each file is a registered generated target. Check: Write-TypesContract tests, Test-GeneratedFiles.
2. [ ] The schema: one `types.schema.json` the per-group files validate against. Check: Test-Contracts.
3. [ ] The drift check: Get-TypesContractDrift and the build's surface comparison read the per-group files. Check: `Invoke-TestFile` on
       Get-TypesContractDrift.Tests.ps1 and Invoke-ModuleBuild.Tests.ps1.
4. [ ] The cross-check: every type a command contract names in `parameters` or `output` exists in some group's `types.json`, a
       Test-Contracts finding otherwise. Check: Test-Contracts with an L0 case per direction and the real tree at 0.
5. [ ] The rule text in `docs/drs/repository/api-contracts.md` and `docs/drs/automation/caching.md`. Check: Test-DrsRegistry and
       Test-Links.
