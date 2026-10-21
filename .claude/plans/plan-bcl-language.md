---
plan:
  status: active
  value: medium
  reviewed: 2026-10-21
  class: feature
  targets:
    [
      docs/references/BCL,
      docs/how-to/getting-started/BCL,
      docs/how-to/pwsh/manual-test-plan/csharp-types.md,
      docs/adr/automation/BCL/native-csharp-types.md,
      docs/adr/automation/BCL/index.md,
      docs/adr/automation/pwsh/hosting-csharp-types.md,
      docs/adr/index.md,
      pwsh/Catzc.Base.Docs/configs/adrs.yml,
      pwsh/Catzc.Base.Languages/configs/languages.yml,
      docs/index.md,
      docs/how-to/getting-started/automation/index.md,
      docs/how-to/getting-started/pwsh/add-a-module.md,
      docs/how-to/getting-started/pwsh/debug-in-vscode.md,
      docs/references/pwsh/index.md,
    ]
---

# BCL is its own language, not a part of pwsh

The `types/*.cs` sources are written in **BCL**: C# that references the .NET Base Class Library and nothing else, a subset of .NET. pwsh is
the one host that compiles and loads them today, so it binds them (`ADR-PWSH-TYPES`), but it does not own them. The ADRs already sit at
`docs/adr/automation/BCL/`, outside pwsh; the reference and how-to pages still sit under `pwsh/`, the language row is named `csharp`, and
the reference set the types compile against is "the BCL plus `System.Management.Automation`", which is not a subset of .NET's BCL. This plan
moves BCL out of pwsh in the docs, the language registry and the reference set.

## Why its value is medium

A reader looking for the type rules lands under pwsh and reads them as PowerShell rules, and 12 of 309 types bind to the pwsh host without
anything saying which or why. The language, its reference set and its host become three named things, each with one owner, which a second
host (or a reader of a bundle) needs before the types can be reasoned about apart from pwsh. Nothing breaks today, so medium.

## Decided (2026-10-20, from the user)

- BCL is a language of its own: a subset of .NET, C# against the Base Class Library. pwsh is its host, not its owner.

## Decided (the user, 2026-10-21, decision round)

- **Host bindings are config entries** (ADR-PRIN-CONFIG-EXCEPTIONISCONFIGENTRY): one row per host-bound file with its reason in a `bcl.yml`
  beside `languages.yml`, and a gate fails a `using System.Management.Automation*` in a file without a row. Twelve types carry the `using`
  (`ContractParameter.cs` and `TypeShape.cs` name SMA only in string literals). The five `PSObject`-unwrapping types (`ContractValue`,
  `ValueChainHighlight`, `ValueChainMap`, `WorldMapBuilder`, `WorldMapHighlight`) unwrap in their pwsh callers instead, so
  `ContractValue.Unwrap`'s signature changes; the parser and runspace types keep their rows.
- **BCL is its own ADR domain**, `bcl` (folder `automation/BCL`, depends on `automation`): `ADR-AUTO-TYPES` is re-cited to `ADR-BCL-TYPES`
  with `Update-AdrCitation`, dry run first, and `ADR-PWSH-TYPES` depends on `bcl`.
- **The language row is renamed `csharp` to `bcl` after plan-minimal-heads lands**, since that plan drops `language` from code heads and the
  rename shrinks from about 290 files to the configs and tests; the `csharp-namespace` imprint step becomes `bcl-namespace` in the same
  change.
- **BCL is two things** (the user, 2026-10-21): a .NET language in catzc's domain, where a language carries more than its file row (its
  build pair, its projects and solution, its reference set); and its use inside pwsh, which compiles the types in the .NET runtime already
  running the session, intrinsic to pwsh. The build pair of `ADR-AUTO-TYPES-DEBUGANYCPU` is the language's, so it lives in `bcl.yml` on
  `BclConfig` (landed), and the host bindings join it there.
- **The BCL drawing is wanted**, after the host bindings land, as one sample folder `out/diagrams/dark-sample/.assets/bcl-language/`; on
  approval it goes to `docs/adr/automation/BCL/.assets/bcl-language/`, kept in step with the one definition page.

## Open steps

The doc moves landed (2026-10-21; `docs/how-to/pwsh/manual-test-plan/csharp-types.md` stays, since it tests the pwsh hosting). Their commits
are the user's, in task-user-runs-and-commits. The ADR rule `ADR-AUTO-TYPES-BCLREFERENCESET` landed with the two narrowed `ADR-PWSH-TYPES`
rules; its "How this is enforced" line comes with `Test-BclReferences` below.

- [ ] `pwsh/Catzc.Base.Languages/configs/bcl.yml` and `pwsh/Catzc.Base.Languages/types/BclConfig.cs`, which exist with the build pair: add
      one row per host-bound file with its reason, beside `configuration` and `platform`. Today 12 `types/*.cs` files have
      `using System.Management.Automation`; the seven that stay host-bound after the unwraps below are its rows: `GlossaryProse.cs`,
      `GlobPattern.cs`, `FunctionCallCollector.cs`, `CommentLexer.cs`, `ParsedScripts.cs`, `SyntaxSearch.cs`, `PipelineWatchdog.cs` (check:
      `Invoke-TestFile` on `pwsh/Catzc.Base.Languages/tests/types/BclConfig.Tests.ps1`).
- [ ] `pwsh/Catzc.Base.QualityGates/Test-BclReferences.ps1` (the planner's name, 2026-10-21): fails a `types/*.cs` file that references
      `System.Management.Automation` and has no `bcl.yml` row, with its L0 tests on widget/gadget fixtures (check: `Invoke-TestFile` on its
      test file).
- [ ] `pwsh/Catzc.Base.Objects/ConvertTo-BclValue.ps1`: the one deep-unwrap mechanism (decided, delegated by the orchestrator,
      2026-10-21): it returns a value with every `PSObject` at any depth replaced by its base object, rebuilding lists and dictionaries,
      since `ContractValue.Unwrap` and the Maps types unwrap nested elements, not only arguments (check: `Invoke-TestFile` on its L0 tests
      for nested lists, dictionaries and a scalar).
- [ ] The callers pass their values through `ConvertTo-BclValue`, one file per step: `Get-ContractFragmentFindings.ps1`, then
      `Get-ContractSchemaFindings.ps1`, then each pwsh caller of the four Maps types (check: the owning module's Pester files after each).
- [ ] The five types drop the `using System.Management.Automation` and their unwrap, one file per step: `ContractValue.cs` (its `Unwrap`
      deleted, with the callers in `ContractSchema.cs` and `ContractFragment.cs`), then `ValueChainHighlight.cs`, `ValueChainMap.cs`,
      `WorldMapBuilder.cs` and `WorldMapHighlight.cs` (check: a fresh full import after each, the owning module's Pester files, and
      `Test-BclReferences` with 0 issues after the last). Then `Test-BclReferences` joins the `csharp` row's checks in `languages.yml`.
- [ ] `pwsh/Catzc.Base.Docs/configs/adrs.yml` and `docs/adr/index.md`: the `bcl` domain and its table; `automation/`'s description stops
      listing `BCL/` as a language layer (check: `Test-AdrRegistry`).
- [ ] Re-cite `ADR-AUTO-TYPES-*` → `ADR-BCL-TYPES-*` with `Update-AdrCitation`, dry run first; the dry run lists
      `ADR-AUTO-TYPES-DEBUGANYCPU` too, cited in the head of `BclConfig.cs`, the three `.csproj` comments and the
      `Invoke-BuildForVSCode.ps1.md` page (check: `Test-AdrRegistry`, which runs the citation graph).
- [ ] After plan-minimal-heads lands: `pwsh/Catzc.Base.Languages/configs/languages.yml`: rename the `csharp` row to `bcl` and the
      `csharp-namespace` step to `bcl-namespace`, then every caller in the same change, one file at a time (check: `Catzc.Base.Languages`
      and `Catzc.Base.QualityGates` Pester, then `Test-Formatting -Language bcl`).
- [ ] `docs/references/BCL/index.md` (after the move): the one page that defines the BCL language (its files, its build pair from `bcl.yml`,
      its reference set) and its use inside the pwsh host, as the two things the user decided; the reference-set wording leaves
      `docs/references/pwsh/index.md` and links here instead, so the definition has one living version (`ADR-PRIN-ONELIVE`) (check:
      `Test-Links` on both pages, `grep -c "System.Management.Automation"` on the pwsh index is 0).
- [ ] `.claude/CLAUDE.md`, section Project structure: one line saying that the `types/*.cs` files are written in BCL, a subset of .NET, and
      pwsh hosts them, linking the BCL reference index, after the doc moves land (check: `Test-AgentDefinitions`,
      `Test-Links -Path .claude/CLAUDE.md`).
- [ ] After the `bcl.yml` step: the BCL diagram as one sample folder `out/diagrams/dark-sample/.assets/bcl-language/` (its
      `diagram.drawio.yml` and png), the host box showing the kinds `bcl.yml` keeps; nothing in `docs/` until approved (check: the user
      approves the sample).
- [ ] On approval: the folder moves to `docs/adr/automation/BCL/.assets/bcl-language/` and `docs/references/BCL/index.md` embeds it (check:
      `Test-Diagrams` on the folder, `Test-Links` on the page).

## Open questions

- From the session that added `ADR-AUTO-TYPES-DEBUGANYCPU` (2026-10-21), two facts each could shrink what the next session reads, as one
  clause merged into an existing line: should `catzc-run` say that changing a code line whose long comment moved to a `docs/references/`
  comment page means editing that page's "Above `…`" line too? Should `.claude/CLAUDE.md`'s Project structure say that `catzc.sln` at the
  root is a gitignored output of `Build-RootConfig`, with only its asset tracked? Recommendation: yes to the first; no to the second, which
  `rootconfig.yml` already says.

## Refs

- `docs/adr/automation/BCL/native-csharp-types.md` (`ADR-AUTO-TYPES`) — what the types are.
- `docs/adr/automation/pwsh/hosting-csharp-types.md` (`ADR-PWSH-TYPES`) — how pwsh hosts them.
- `docs/adr/principles/one-living-version.md` (`ADR-PRIN-ONELIVE`) — moves and renames change every caller at once.
- Microsoft's BCL definition: <https://learn.microsoft.com/en-us/dotnet/standard/glossary#bcl>.
