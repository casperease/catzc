---
plan:
  status: active
  value: high
  reviewed: 2026-10-26
  class: feature
  targets: [contracts/catzc/0.1.0, pwsh/Base.Contracts, docs/drs/repository/api-contracts.md]
---

# Contract groups: the first segment names the language, never catzc

A group folder under `contracts/catzc/<version>/` stops spelling the catzc namespace. Its first segment names the language (the track) of
the module it declares contracts for, then the module's short name in contract form: `catzc.azure` becomes `pwsh.azure`,
`catzc.azure.dev_ops` becomes `pwsh.azure.dev_ops`, `catzc.base.vs_code` becomes `pwsh.base.vs_code`.

## Decided (the user, 2026-10-26)

- catzc is a namespace, not a path: no catzc in a contract group's folder name (DDR-TRACK-MODULENAMESPACE).
- The group name is a configurable mapping, declared once in the Contracts config on its type; the default is the owning module's track
  folder name, a dot, and the module's short name in contract form.
- Two phases, as the module move: the user runs a git mv script, then the repair lands with the repo's tools.

## Open steps

1. [ ] The mapping: its shape on the Contracts config type with the default declared once, and its tests. Check: `Invoke-TestFile` on the
       Contracts config type's tests.
2. [ ] `out/ns5/Rename-ContractGroups.ps1`: a per-file git mv for every group folder, `-WhatIf`, a record in `out/ns5/contract-moves.csv`,
       stop on the first git error, no content edits; the user runs it. Check: the `-WhatIf` lists every group once and no target exists.
3. [ ] The repair after the run: `Get-Contract`, the group to module mapping, `Build-ContractReference`, `Test-Contracts` and the command
       contracts' lookup resolve through the mapping; `contract.yml` applies_to and the reference pages follow the csv. Check:
       `Test-Contracts`, `Test-GeneratedFiles` and `Test-Links` on `docs/references/contracts`.
4. [ ] `docs/drs/repository/api-contracts.md` states the rule (the language segment, the mapping, its default). Check: `Test-DrsRegistry`
       and `Test-Links` on the page.
