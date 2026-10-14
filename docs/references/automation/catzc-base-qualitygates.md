# docs/references/automation/catzc-base-qualitygates.md

`Catzc.Base.QualityGates`

The quality-gate module. It **runs every check the repository applies to itself** — all tests (with tag-enforcement and timestamped
reporting), the repository-wide quality gates, the spell-checker, the Markdown linter, the formatters, the terminology registry, and the
managed-GUID registry. What it deliberately does **not** own is the tests themselves (each module keeps its own `tests/` folder), the
quality gates whose property belongs to another module (the module-graph quality gates live in
[Catzc.Base.ModuleSystem](catzc-base-modulesystem.md)), or the per-tool configuration (cSpell, markdownlint, and Prettier each carry their
own config at the repository root). A quality gate collects every issue, writes its report through
[Catzc.Base.Reports](catzc-base-reports.md), and throws once listing them all
([test-automation](../../adr/automation/test-automation.md#rule-adr-auto-test35)); the tier and category tag rules the Pester runner
enforces are the subject of the same ADR.

## Responsibilities

| Responsibility   | Area        | Name                                                                   |
| -------- | ----------- | ---------------------------------------------------------------------- |
| responsibility:1 | runner      | [Test runner](#responsibility1--test-runner)                                   |
| responsibility:2 | gates       | [Repository quality gates](#responsibility2--repository-quality-gates)         |
| responsibility:3 | formatting  | [Document and code formatting](#responsibility3--document-and-code-formatting) |
| responsibility:4 | terminology | [Terminology and dictionaries](#responsibility4--terminology-and-dictionaries) |
| responsibility:5 | guids       | [Managed GUIDs](#responsibility5--managed-guids)                               |

### responsibility:1 — Test runner

How the repository runs and validates all its tests. This responsibility discovers tests across every module, runs them at the requested tier level
(L0–L3) and optional category filter (`logic`/`integrity`), and writes a timestamped report — as a source run, as a build run against a
fresh build of the selected modules, one test file at a time, or for a module profile copied into an isolated sandbox. Before any test
executes, a discovery-only pass inspects the full test tree and throws if any test is missing or ambiguous on either of the two mandatory
tag axes — exactly one tier (`L0|L1|L2|L3`) and exactly one category (`logic|integrity`). The tag model, the two-axis tagging contract, the
two run modes, and the tier definitions are the subject of [test-automation](../../adr/automation/test-automation.md).

### responsibility:2 — Repository quality gates

The gates that each check one property of the whole repository: every generated file equals what its generator would write now; every
formatter would leave the repository unchanged; the built artifact builds, loads, and matches its source; every shipped config has a
registered C# config type and loads through it
([module-config-loading](../../adr/configuration/module-config-loading.md#rule-adr-conf-loading4)); the source and test files follow the
naming and one-function conventions; test titles carry no unfilled template token; the manual test plan lists every integrity check once;
the analyzer-to-ADR map cites only real rules and maps every custom analyzer rule; the PowerShell passes PSScriptAnalyzer; and test and
production identities never cross — no logic test names a live identity, no shipped config carries a test-fixture one, and no fixture
identity is also a live one. An integrity test runs each gate at its tier, so every default test run and every CI run includes it.

### responsibility:3 — Document and code formatting

How the repository checks and enforces the style of its written and source content. This responsibility runs the spell-checker (and collects its
flagged tokens into a triage queue), the Markdown linter, the Markdown formatter (which aligns tables and wraps prose in place), the
Markdown title and heading formatter and quality gate, the ADO pipeline YAML formatter (`Format-Pipelines`, the same Prettier engine as
`Format-Markdown` — they share one private `Invoke-Prettier`), the PowerShell auto-formatter, the C# type-namespace formatter, and the link
aligner and quality gate, which keep code links repository-rooted and markdown links relative and resolving
([markdown-links](../../adr/repository/markdown-links.md)). The responsibility owns the invocation of each tool, not the tool itself or its per-tool
configuration.

### responsibility:4 — Terminology and dictionaries

The terminology registry (`terminology.yml`) is the single authored source of the repository's approved vocabulary, grouped by category.
This responsibility generates the per-category spell-checker dictionaries from it and the committed English word list the spell-out-names analyzer
rule checks identifiers against, and checks the registry: no drift between it and the generated dictionaries, no orphan entries, no
unjustified ones.

### responsibility:5 — Managed GUIDs

The managed-GUID registry (`guids.yml`) names every GUID the repository is allowed to carry
([managed-guids](../../adr/automation/managed-guids.md)). This responsibility reads the registry, answers or asserts whether one GUID is registered,
scans tracked text for GUID literals, mints a readable GUID from a sentence, and checks the repository: every GUID in tracked text is
registered, none is denied, and every entry is live.

## What the module does

The module is the repository's self-check harness. The test runner (responsibility 1) checks behaviour — does every function do what it claims? —
and runs every gate through the integrity tests that call it. The repository quality gates (responsibility 2) check the properties no single
function owns: generated files, formatting, the built artifact, the shipped configs, and the conventions. The formatting quality gates
(responsibility 3) check form — are the prose, markup, and source consistently shaped? The terminology (responsibility 4) and managed-GUID
(responsibility 5)
registries turn two open-ended vocabularies — accepted words and allowed GUIDs — into reviewed, checked lists. All answer to the same
contract: these are the gates a change is measured against before it merges.

Responsibility 1 carries the most machinery. The test runner does not simply invoke Pester; it enforces the two-tag contract on every run. A
discovery-only pass — driven by private helpers that perform nearest-contributing-block tag resolution across the `Describe`/`Context` chain
— inspects every test before a single one executes, so a missing or ambiguous tag fails the run immediately rather than silently skipping a
tier. The L0–L3 tier filter and the `logic`/`integrity` category filter are orthogonal run parameters, and the enforcement pass always
covers the full tree regardless of which subset is requested.

Responsibility 3 is a set of thin wrappers, one per external tool, deliberately kept separate so each can be run in isolation;
`Test-Formatting` (responsibility 2) runs every formatter in its report-only mode as one gate. A `Format-*` function is both a check and a mutation — it rewrites
files in place, so it belongs to the authoring workflow as well as CI.

The module's neighbours are the rest of the `Base` group, which supply the primitives (file location, process invocation, console output,
reports, and assertions) this module composes. It does not depend on any domain module.

## Division

The module's public functions and configuration files, sorted into the responsibilities above.

| Responsibility                                  | Function                      |
| --------------------------------------- | ----------------------------- |
| responsibility:1 — Test runner                  | `Test-Automation`             |
|                                         | `Invoke-TestFile`             |
|                                         | `Test-CatzcBuild`             |
|                                         | `Test-InIsolation`            |
| responsibility:2 — Repository quality gates     | `Test-GeneratedFiles`         |
|                                         | `Test-Formatting`             |
|                                         | `Test-BuildArtifact`          |
|                                         | `Test-ShippedConfigs`         |
|                                         | `Test-SourceConventions`      |
|                                         | `Test-TestTitles`             |
|                                         | `Test-ManualTestPlan`         |
|                                         | `Test-AnalyzerAdrMap`         |
|                                         | `Test-ScriptAnalyzer`         |
|                                         | `Test-LogicTestIdentity`      |
|                                         | `Test-ConfigIdentityHygiene`  |
| config                                  | `analyzer-adr-map.yml`        |
| responsibility:3 — Document and code formatting | `Test-Spelling`               |
|                                         | `Format-Spelling`             |
|                                         | `Test-Markdownlint`           |
|                                         | `Format-Markdown`             |
|                                         | `Format-MarkdownTitle`        |
|                                         | `Test-MarkdownTitle`          |
|                                         | `Format-Pipelines`            |
|                                         | `Format-Automation`           |
|                                         | `Format-Types`                |
|                                         | `Format-Links`                |
|                                         | `Test-Links`                  |
| config                                  | `links.yml`                   |
| responsibility:4 — Terminology and dictionaries | `Build-TerminologyDictionary` |
|                                         | `Build-EnglishDictionary`     |
|                                         | `Test-Terminology`            |
| config                                  | `terminology.yml`             |
| responsibility:5 — Managed GUIDs                | `Get-ManagedGuids`            |
|                                         | `Test-ManagedGuid`            |
|                                         | `Assert-ManagedGuid`          |
|                                         | `Get-RepositoryGuids`         |
|                                         | `ConvertTo-Guid`              |
|                                         | `Test-ManagedGuids`           |
| config                                  | `guids.yml`                   |
