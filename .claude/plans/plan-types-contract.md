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

## Open steps

2. [ ] `Write-TypesContract` in `pwsh/.internal/assets/types/` (one function per file, ADR-PWSH-ONEFUNC): reads the surface with
       `Get-TypesAssemblyManifest`, renders `types.sample.json` (LF, stable order by name), writes via `Write-FileIfChanged`. Plus
       `types.schema.json` by hand, and its header `$comment` says what it pins (ADR-REPO-CONTRACT-HEADERSAYSWHATITPINS). Check: L0 test in
       `pwsh/.internal/tests/` with widget/gadget types: same surface → no write; added alias → one write.
3. [ ] `Import-CSharpTypes.ps1`: delete the committed-manifest copy and the stale-file sweep (lines ~208-220); after a compile, outside
       `-PrebuiltOnly` and outside a pipeline, call `Write-TypesContract`. The shadow manifest beside the DLL stays as is. Same pass:
       `Import-CSharpTypes.Shipped.Tests.ps1` and `Clear-CompiledType.Tests.ps1` stop expecting a file in `pwsh/.compiled`. Check: fresh
       full import right after (importer-path edit), then the two test files green.
4. [ ] The stamp check: `Test-GeneratedFiles` (or the types gate it runs) builds the surface from the current assembly and fails when it
       differs from the committed `types.sample.json`, naming the added, removed or changed types. `Test-Contracts` already validates the
       sample against its schema. Check: L0 test of the diff; `Test-Contracts` green on the new asset.
5. [ ] Bundle: `Get-ModuleBuildPlan.ps1` keeps shipping `.compiled/Catzc.Types.<hash>.json` beside the DLL (a bundle's local cache key, not
       the contract); `Invoke-ModuleBuild` runs the step-4 check before packing. Check: `Invoke-ModuleBuild.Tests.ps1` green.
6. [ ] Pipeline cache: `.ado/pipelines/steps/cache-types.yaml` keys on the sources, `pwsh/**/types/**/*.cs` and
       `pwsh/.internal/assets/Catzc.Types.csproj`, not `pwsh/.compiled/*.json`; regenerate its reference page. Check: `Test-Contracts` (ado
       pipeline schema) and `Test-GeneratedFiles` green.
7. [ ] Gitignore: the `compiled-types` entry in `pwsh/Catzc.Base.Git/configs/gitignore.yml` ignores all of `pwsh/.compiled/`, its
       description says the contract lives in `contracts/catzc/0.1.0/catzc.internal.types/`; rebuild `.gitignore`. The file has uncommitted
       edits from another session: land this after they are committed. Check: `git status --ignored pwsh/.compiled` lists every file
       ignored.
8. [ ] Contract map and reference: `Build-ContractReference` regenerates `docs/references/contracts/catzc.md`. Check: `Test-GeneratedFiles`
       green.
9. [ ] Supersedes step 10 of `plan-types-build-local.md` ("commit the current manifest"); strike it there once that file is clean. The
       untracking of `pwsh/.compiled/Catzc.Types.*.json` is the user's git step (`git rm --cached`), in task-user-runs-and-commits. Check:
       `git ls-files pwsh/.compiled` prints nothing.

## Open questions

- Should `Test-Plans` accept a new plan's missing master chunk line while `plan-master.md` is dirty in a peer session, reporting it as a
  pending step instead of a failure? Recommendation: yes, it blocks every solo session that lands a plan.
- Should `js/catzc-file-icons` gain a short README naming where glyphs live and that the theme has no folder icons, so the next icon task
  skips the search? Recommendation: yes, one paragraph.
