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
- A type's group comes from its namespace, `Catzc.<module folder>`, matched to the one group folder ending in the folder's normal form (as
  Get-TypesContractPath matches); a missing group is derived by the form (`<track>.<normal folder>`, contracts.yml exceptions) and created,
  as a types surface is a provided contract even without commands; Test-Contracts pins that each mapping equals Get-ContractGroup (the
  orchestrator, 2026-10-26).
- Each type lists name, aliases, display and its public members: property and method names, sorted, each with its kind, no signatures or
  bodies; a body edit leaves the file unchanged, a new public member moves it (the orchestrator, 2026-10-26).

## Open steps

1. [ ] Format-Code -Language json selects no file under `contracts/` (0 of 0), so the generated types.json are formatter-clean only by the
       writer's own form (0 of 44 changed off-tree). Check: Format-Code -Language json on a types.json reports 1 file checked.
2. [ ] Files the import writes during a burst are not in the burst journal, so a rollback leaves them behind (a failed burst left 44
       generated types.json in the live tree and broke every import); the burst journals every path the import writes. Check: a failed burst
       leaves git status unchanged.
3. [ ] Invoke-StagedBurst's restore re-creates a missing parent folder (a step that deleted a staged file's folder left the journal restore
       half done). Check: a burst whose step deletes a staged file's folder still rolls back clean.
4. [ ] A peer that imports while a C# + .ps1 burst's steps run (after the swap) loads the new .ps1 against its old types build; the
       importer waits on the run lock for the whole burst, not just the swap, when the burst staged a .cs. Check: a peer import during
       such a burst waits, then loads green.
5. [ ] Format-Types resolves a staged .cs copy under `out/` to no manifest and imprints its namespace without `Catzc`; Get-ModuleFullName
       (or Format-Types) maps a staged path to its live module folder through the burst's `.burst-base` mirror. Check: Format-Code on a
       staged copy of a `types/*.cs` leaves `namespace Catzc.<Module>;`.
