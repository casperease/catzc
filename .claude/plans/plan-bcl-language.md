---
plan:
  status: active
  value: medium
  reviewed: 2026-10-21
  class: feature
  targets:
    [
      docs/references/pwsh/BCL,
      docs/how-to/getting-started/pwsh/BCL,
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
  beside `languages.yml`, and a gate fails a `using System.Management.Automation*` in a file without a row. Twelve types carry the
  `using` (`ContractParameter.cs` and `TypeShape.cs` name SMA only in string literals). The five `PSObject`-unwrapping types
  (`ContractValue`, `ValueChainHighlight`, `ValueChainMap`, `WorldMapBuilder`, `WorldMapHighlight`) unwrap in their pwsh callers instead,
  so `ContractValue.Unwrap`'s signature changes; the parser and runspace types keep their rows.
- **BCL is its own ADR domain**, `bcl` (folder `automation/BCL`, depends on `automation`): `ADR-AUTO-TYPES` is re-cited to `ADR-BCL-TYPES`
  with `Update-AdrCitation`, dry run first, and `ADR-PWSH-TYPES` depends on `bcl`.
- **The language row is renamed `csharp` to `bcl` after plan-minimal-heads lands**, since that plan drops `language` from code heads and
  the rename shrinks from about 290 files to the configs and tests; the `csharp-namespace` imprint step becomes `bcl-namespace` in the same
  change.
- **The BCL drawing is wanted**, after the host bindings land, as one sample folder `out/diagrams/dark-sample/.assets/bcl-language/`; on
  approval it goes to `docs/adr/automation/BCL/.assets/bcl-language/`, kept in step with the one definition page.

## Open steps

The doc moves go first.

- [ ] `docs/references/pwsh/BCL/` → `docs/references/BCL/` (both pages, moved on disk): reword "the host-guaranteed assemblies" to the BCL
      language with pwsh as its host, and re-point each relative link one level up (check: `Test-Links` on both pages).
- [ ] `docs/how-to/getting-started/pwsh/BCL/` → `docs/how-to/getting-started/BCL/` (both pages, moved on disk): re-point relative links
      (check: `Test-Links` on both pages).
- [ ] `docs/how-to/pwsh/manual-test-plan/csharp-types.md`: decide by reading it whether it tests the pwsh hosting (stays) or the language
      (moves to `docs/how-to/BCL/manual-test-plan/`); record the verdict here (check: `Test-Links` on the page).
- [ ] `docs/index.md`, `docs/how-to/getting-started/automation/index.md`, `docs/how-to/getting-started/pwsh/add-a-module.md`,
      `docs/how-to/getting-started/pwsh/debug-in-vscode.md`, `docs/references/pwsh/index.md`: re-point the links into the moved folders, one
      file at a time; `references/pwsh/index.md` keeps one line pointing at the BCL reference as the language its loaders host (check:
      `Test-Links` per file).
- [ ] `docs/adr/automation/BCL/index.md`: say BCL is a language, a subset of .NET, hosted by pwsh, and name the two ADRs (language, hosting)
      (check: `Test-Links`, `Test-Markdownlint`).
- [ ] `docs/adr/automation/BCL/native-csharp-types.md`: a rule stating the BCL reference set — the BCL only, a host binding only as its
      configured exception; the host-binding section names the language and its host apart (check: `Test-AdrIndex`,
      `Test-Links`).
- [ ] `docs/adr/automation/pwsh/hosting-csharp-types.md`: narrow `ADR-PWSH-TYPES-HOSTGUARANTEEDASSEMBLIES` and
      `ADR-PWSH-TYPES-POWERSHELLPRIMITIVES` to "the BCL language, plus SMA for a configured host binding" (check:
      `Test-AdrIndex`).
- [ ] `pwsh/Catzc.Base.Languages/configs/bcl.yml` and its config type: one row per host-bound file with its reason; register in
      `configs.yml` (check: the config type's L0 tests).
- [ ] The gate over `types/*.cs` that fails an unlisted `System.Management.Automation` reference, with its L0 tests on
      widget/gadget fixtures (check: its Pester file).
- [ ] The five `PSObject`-unwrapping types: unwrap in the pwsh caller and drop the `using`, one file at a time (check: each
      module's Pester files, then a fresh full import).
- [ ] `pwsh/Catzc.Base.Docs/configs/adrs.yml` and `docs/adr/index.md`: the `bcl` domain and its table; `automation/`'s description stops
      listing `BCL/` as a language layer (check: `Test-AdrIndex`).
- [ ] Re-cite `ADR-AUTO-TYPES-*` → `ADR-BCL-TYPES-*` with `Update-AdrCitation`, dry run first (check: `Test-AdrCitations` over
      the tree).
- [ ] After plan-minimal-heads lands: `pwsh/Catzc.Base.Languages/configs/languages.yml`: rename the `csharp` row to `bcl` and the
      `csharp-namespace` step to `bcl-namespace`, then every caller in the same change, one file at a time (check: `Catzc.Base.Languages`
      and `Catzc.Base.QualityGates` Pester, then `Test-Formatting -Language bcl`).
- [ ] `docs/references/BCL/index.md` (after the move): the one page that defines the BCL language, its host and its reference set; the
      reference-set wording leaves `docs/references/pwsh/index.md` and links here instead, so the definition has one living version
      (`ADR-PRIN-ONELIVE`) (check: `Test-Links` on both pages, `grep -c "System.Management.Automation"` on the pwsh index is
      0).
- [ ] `.claude/CLAUDE.md`, section Project structure: one line, "`types/*.cs` are written in BCL, a subset of .NET; pwsh hosts them",
      linking the BCL reference index, after the doc moves land (check: `Test-AgentDefinitions`, `Test-Links -Path .claude/CLAUDE.md`).
- [ ] After the `bcl.yml` step: the BCL diagram as one sample folder `out/diagrams/dark-sample/.assets/bcl-language/` (its
      `diagram.drawio.yml` and png), the host box showing the kinds `bcl.yml` keeps; nothing in `docs/` until approved (check: the user
      approves the sample).
- [ ] On approval: the folder moves to `docs/adr/automation/BCL/.assets/bcl-language/` and `docs/references/BCL/index.md` embeds it
      (check: `Test-Diagrams` on the folder, `Test-Links` on the page).

## Refs

- `docs/adr/automation/BCL/native-csharp-types.md` (`ADR-AUTO-TYPES`) — what the types are.
- `docs/adr/automation/pwsh/hosting-csharp-types.md` (`ADR-PWSH-TYPES`) — how pwsh hosts them.
- `docs/adr/principles/one-living-version.md` (`ADR-PRIN-ONELIVE`) — moves and renames change every caller at once.
- Microsoft's BCL definition: <https://learn.microsoft.com/en-us/dotnet/standard/glossary#bcl>.
