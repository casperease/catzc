---
plan:
  status: active
  value: low
  reviewed: 2026-10-28
  class: refactor
  targets: [pwsh/.scriptanalyzer, pwsh/.internal/assets/PSScriptAnalyzerSettings.psd1, pwsh/Base.QualityGates]
---

# Analyzer entry rules: named by role, not by owner

The two analyzer entry rules carry the catzc name in their file and function names (`CatzcRules.psm1` / `Measure-CatzcRules`,
`CatzcSpelling.psm1` / `Measure-CatzcSpelling`). Their folder, `pwsh/.scriptanalyzer/`, already says whose rules they are, and catzc is a
namespace, never a disk name (PDR-CATS-CATZCISSOURCENAME). They take names that say what they do: the entry rule that runs every check, and
the entry rule of the spelling pass.

## Why its value is low

Nothing breaks today; the rename removes two of the last places the namespace is burned into a file name outside the namespace-carrying
modules (`Catzc.Internal.*`, `Catzc.Types`), so the next name sweep has fewer exceptions to explain.

## Decided (2026-10-28)

- `CatzcRules.psm1` -> `EntryRule.psm1`, function `Measure-CatzcRules` -> `Measure-EntryRule`.
- `CatzcSpelling.psm1` -> `SpellingEntryRule.psm1`, function `Measure-CatzcSpelling` -> `Measure-SpellingEntryRule`.
- File and function both rename: the file name follows its one exported function, and a diagnostic's rule name stays readable as an entry
  rule beside the engine's own rules. One living name (PDR-ONELIVE): no alias, no old name kept anywhere.
- The settings file changes every analyzer run, so steps 1-4 land together as one staged burst (`Invoke-StagedBurst`); the result caches of
  both passes are invalidated by the new rule names and rebuild on the next run.

## Open steps

1. [ ] Staged burst, the four code files together: move `pwsh/.scriptanalyzer/CatzcRules.psm1` to `EntryRule.psm1` and rename its function
       and `Export-ModuleMember`; move `CatzcSpelling.psm1` to `SpellingEntryRule.psm1` likewise; in
       `pwsh/.internal/assets/PSScriptAnalyzerSettings.psd1` swap both `CustomRulePath` entries and the comment naming `CatzcRules.psm1`
       (check: `Invoke-TestFile -Path pwsh/.scriptanalyzer/tests/CustomRuleWiring.Tests.ps1` inside the burst).
2. [ ] Same burst: `pwsh/Base.QualityGates/Measure-QualityGates.ps1` (`'Measure-CatzcRules'`),
       `pwsh/Base.QualityGates/private/Get-ScriptAnalyzerDiagnostics.ps1` (`$spellingRule`),
       `pwsh/Base.QualityGates/private/Get-ScriptAnalyzerInputs.ps1` (`$spellingRules`) take the new names (check: the Grep tool finds no
       `Catzc(Rules|Spelling)` under `pwsh/`).
3. [ ] Tests, one file at a time: `pwsh/.scriptanalyzer/tests/CustomRuleWiring.Tests.ps1`,
       `pwsh/Base.QualityGates/tests/Get-ScriptAnalyzerInputs.Tests.ps1`, `pwsh/Base.QualityGates/tests/Test-AnalyzerDrsMap.Tests.ps1`
       (check: `Invoke-TestFile -Path <each>`).
4. [ ] Reference pages: move `docs/references/pwsh/scriptanalyzer/catzc-rules.md` to `entry-rule.md` and `catzc-spelling.md` to
       `spelling-entry-rule.md`, retitled to the new paths; update `docs/references/pwsh/scriptanalyzer/tests/custom-rule-wiring.md`,
       `docs/references/pwsh/base-quality-gates/measure-quality-gates.md`, `.../test-analyzer-drs-map.md`,
       `.../private/get-script-analyzer-diagnostics.md`, `.../private/get-script-analyzer-inputs.md` (check: `Test-Links` on the seven
       pages).
5. [ ] Prose: `docs/drs/automation/pwsh/powershell-formatting.md`, `docs/explanation/flow/two-variables-read-in-one-place.md` (5 mentions,
       incl. the diagram label `c-rules`), `docs/explanation/flow/the-loader-holds-the-one-detector.md`; re-render the flow diagram if its
       label changed (check: `Test-Diagrams` on that page).
6. [ ] Check: the Grep tool finds no `Catzc(Rules|Spelling)` or `catzc-(rules|spelling)` in the tree; `Test-ScriptAnalyzer` on
       `pwsh/.scriptanalyzer` and `pwsh/Base.QualityGates` reports the custom checks under the new rule names.
