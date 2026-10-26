---
plan:
  status: active
  value: high
  reviewed: 2026-10-26
  class: bug
  targets: [pwsh/.compiled, contracts/catzc/0.1.0, pwsh/.internal/assets/bootstrap/Import-CSharpTypes.ps1, docs/drs/automation/caching.md]
---

# Types contract: the types surface is a catzc contract at 0.1.0, `pwsh/.compiled` is local only

Bug: `pwsh/.compiled/Catzc.Types.<hash>.json` is tracked and named for the source hash, so every C# body edit deletes one tracked file and
adds another, though the surface it lists (name, aliases, display per type) did not move. The hash is a per-machine cache key and stays
local; the surface is what a consumer binds to, so it becomes a provided contract (ADR-REPO-CONTRACT-BINDINGINTERFACE), current at `0.1.0`
and free to change in place (ADR-REPO-CONTRACT-CURRENTVERSION). The tracked file changes only when the surface does.

## Decided

- The asset is `contracts/catzc/0.1.0/catzc.internal.types/types.sample.json`, with `types.schema.json` beside it
  (ADR-REPO-CONTRACT-CONTRACTASSET: a sample the owning module's tests produce, validated by its schema). Group: the module that writes it
  and holds its tests, `Catzc.Internal.Types` (ADR-REPO-CONTRACT-LAYOUT). Content: the manifest's `types` array only, no `hash`.
- Stamp: the contract is regenerated from the compiled assembly and written through `Write-FileIfChanged`, so equal content leaves git
  clean. A devbox import that compiles writes it; a pipeline or a bundle never writes, it checks.
- One living version (PDR-ONELIVE): no file under `pwsh/.compiled` is tracked; the copy-into-`.compiled` code and the old tracked manifest
  go in the same change, no fallback read.

## Open questions

- Should `Test-Plans` accept a new plan's missing master chunk line while `plan-master.md` is dirty in a peer session, reporting it as a
  pending step instead of a failure? Recommendation: yes, it blocks every solo session that lands a plan.
- Should `js/file-icons` gain a short README naming where glyphs live and that the theme has no folder icons, so the next icon task skips
  the search? Recommendation: yes, one paragraph.
