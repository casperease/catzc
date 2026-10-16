---
catzc:
  immutable:
    with_body_sha: "9f8a3f50e4a6"
    path: docs/references/automation/catzc-base-qualitygates.md
    folder: docs/references/automation
    name: catzc-base-qualitygates
    filetype: md
    kind: reference
    language: markdown
    track: docs
    tracktype: documentation
  edges:
    links:
      - docs/.assets/references/automation/catzc-base-qualitygates/test-automation-one-run-pipeline.drawio.md
      - docs/.assets/references/automation/catzc-base-qualitygates/test-automation-one-run-pipeline.drawio.png
      - docs/adr/automation/bash/bash-test-artifacts.md
      - docs/adr/automation/go/go-test-artifacts.md
      - docs/adr/automation/managed-guids.md
      - docs/adr/automation/python/python-test-artifacts.md
      - docs/adr/automation/test-automation.md
      - docs/adr/automation/test-automation.md#rule-adr-auto-test35
      - docs/adr/configuration/module-config-loading.md#rule-adr-conf-loading4
      - docs/adr/principles/configure-not-program.md
      - docs/adr/repository/comments-in-docs.md
      - docs/adr/repository/markdown-links.md
      - docs/references/automation/catzc-base-languages.md
      - docs/references/automation/catzc-base-modulesystem.md
      - docs/references/automation/catzc-base-reports.md
---

# Catzc.Base.QualityGates

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

| Responsibility   | Area        | Name                                                                           |
| ---------------- | ----------- | ------------------------------------------------------------------------------ |
| responsibility:1 | runner      | [Test runner](#responsibility1--test-runner)                                   |
| responsibility:2 | gates       | [Repository quality gates](#responsibility2--repository-quality-gates)         |
| responsibility:3 | formatting  | [Document and code formatting](#responsibility3--document-and-code-formatting) |
| responsibility:4 | terminology | [Terminology and dictionaries](#responsibility4--terminology-and-dictionaries) |
| responsibility:5 | guids       | [Managed GUIDs](#responsibility5--managed-guids)                               |

### responsibility:1 — Test runner

How the repository runs and validates all its tests. This responsibility discovers tests across every module, runs them at the requested
tier level (L0–L3 by default, the opt-in L4 when asked) and optional category filter (`logic`/`integrity`), and writes a timestamped report
— as a source run, as a build run against a fresh build of the selected modules, one test file at a time, or for a module profile copied
into an isolated sandbox. Before any test executes, a discovery-only pass inspects the full test tree and throws if any test is missing or
ambiguous on either of the two mandatory tag axes — exactly one tier (`L0|L1|L2|L3|L4`) and exactly one category (`logic|integrity`). An L4
test, which tests the released system after final approval, asks `Get-TestTargetSkipReason` first and self-skips when the console cannot
reach its target or the target's `test-policy.yml` mode does not allow what it does. A module's Go, Python and Bash tests, in the Go test
module and the Python and Bash test folders named for it, count as that module's tests: one shared Pester bridge, the language bridge, runs
them and turns every test into one Pester test. The tag model, the two-axis tagging contract, the two run modes, and the tier definitions
are the subject of [test-automation](../../adr/automation/test-automation.md); the Go, Python and Bash tests are the subject of
[go-test-artifacts](../../adr/automation/go/go-test-artifacts.md),
[python-test-artifacts](../../adr/automation/python/python-test-artifacts.md) and
[bash-test-artifacts](../../adr/automation/bash/bash-test-artifacts.md).

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

How the repository checks and enforces the style of its written and source content. This responsibility runs the spell-checker (and collects
its flagged tokens into a triage queue), the Markdown linter, the Markdown formatter (which aligns tables and wraps prose in place), the
Markdown title and heading formatter and quality gate, the Markdown meta formatter and its two gates (the block itself and the registry's
processors), the one formatting command (`Format-Code`, which runs the formatter engine `languages.yml` names for each file language —
Prettier, the managed toolchain's `gofmt`, the pinned `ruff`, PSScriptAnalyzer, `dotnet format`, the pinned Bicep CLI — with one private
adapter per engine; [configure-not-program](../../adr/principles/configure-not-program.md)), the C# type-namespace formatter, the Python
lint quality gate (`Test-PythonLint`, `ruff check`) over every `.py` file the repository holds, the shell-script quality gate
(`Test-ShellScripts`: LF, the executable bit, and ShellCheck) over every shell script it tracks
([bash-test-artifacts](../../adr/automation/bash/bash-test-artifacts.md)), and the link aligner and quality gate, which keep code links
repository-rooted and markdown links relative and resolving ([markdown-links](../../adr/repository/markdown-links.md)), and the comment
converters and their quality gate, which move every long comment into its file's comment page, leaving nothing behind in the file, and write
the annotated view ([comments-in-docs](../../adr/repository/comments-in-docs.md)). The responsibility owns the invocation of each tool, not
the tool itself or its per-tool configuration.

### responsibility:4 — Terminology and dictionaries

The terminology registry (`terminology.yml`) is the single authored source of the repository's approved vocabulary, grouped by category.
This responsibility generates the per-category spell-checker dictionaries from it and the committed English word list the spell-out-names
analyzer rule checks identifiers against, and checks the registry: no drift between it and the generated dictionaries, no orphan entries, no
unjustified ones.

### responsibility:5 — Managed GUIDs

The managed-GUID registry (`guids.yml`) names every GUID the repository is allowed to carry
([managed-guids](../../adr/automation/managed-guids.md)). This responsibility reads the registry, answers or asserts whether one GUID is
registered, scans tracked text for GUID literals, mints a readable GUID from a sentence, and checks the repository: every GUID in tracked
text is registered, none is denied, and every entry is live.

## What the module does

The module is the repository's self-check harness. The test runner (responsibility 1) checks behaviour — does every function do what it
claims? — and runs every gate through the integrity tests that call it. The repository quality gates (responsibility 2) check the properties
no single function owns: generated files, formatting, the built artifact, the shipped configs, and the conventions. The formatting quality
gates (responsibility 3) check form — are the prose, markup, and source consistently shaped? The terminology (responsibility 4) and
managed-GUID (responsibility 5) registries turn two open-ended vocabularies — accepted words and allowed GUIDs — into reviewed, checked
lists. All answer to the same contract: these are the gates a change is measured against before it merges.

Responsibility 1 carries the most machinery. The test runner does not simply invoke Pester; it enforces the two-tag contract on every run. A
discovery-only pass — driven by private helpers that perform nearest-contributing-block tag resolution across the `Describe`/`Context` chain
— inspects every test before a single one executes, so a missing or ambiguous tag fails the run immediately rather than silently skipping a
tier. The L0–L3 tier filter and the `logic`/`integrity` category filter are orthogonal run parameters, and the enforcement pass always
covers the full tree regardless of which subset is requested.

The runner reaches past PowerShell for the Go and Python tests, through one language bridge. Discovery maps each Go test module and Python
test folder to the catzc module it is named for (in kebab case), so module selection, test suites, ordering, and protection treat it like
that module's `tests/` folder, and a test folder that names no catzc module stops the run. The bridge reads the tests from their source, so
discovery needs no tool, and runs them once per module through [Catzc.Base.Languages](catzc-base-languages.md): every test becomes one `L2`
Pester test with the category its name gives, and passes, fails with the tool output, or skips as the test did. The run's source session
locates the tools once — the managed `go`, `uv` with the pinned interpreter, and the bash engine — and hands them to the bridge; without
one, that language's tests skip with `tool_go_missing`, `tool_uv_missing` or `tool_bash_missing`. The Go and Python tests run once under
each of the three execution engines, pwsh, bash and zsh; the Bash tests run under bash only. In a build run the bridge hands the build's
entry script on, so the tests start the built engine.

Responsibility 3 is a set of thin wrappers, one per external tool, deliberately kept separate so each can be run in isolation;
`Test-Formatting` (responsibility 2) runs every formatter in its report-only mode as one gate. A `Format-*` function is both a check and a
mutation — it rewrites files in place, so it belongs to the authoring workflow as well as CI.

The module's neighbours are the rest of the `Base` group, which supply the primitives (file location, process invocation, console output,
reports, and assertions) this module composes. It does not depend on any feature module.

The diagram below draws one test run of responsibility 1 from the source. Both kinds of run share one harness. It discovers the tests once
and checks their tags before any run directory exists, then splits the files into the parallel, greedy and serial phases, drops the modules
that are already protected, and derives one verdict. A `finally` stamps the run's `run.json` record on every exit from the run. Its
[description](../../.assets/references/automation/catzc-base-qualitygates/test-automation-one-run-pipeline.drawio.md) walks it step by step.

![One discovery feeds three phases; finally stamps run.json](../../.assets/references/automation/catzc-base-qualitygates/test-automation-one-run-pipeline.drawio.png)

## Division

The module's public functions and configuration files, sorted into the responsibilities above.

| Responsibility                                  | Function                      |
| ----------------------------------------------- | ----------------------------- |
| responsibility:1 — Test runner                  | `Test-Automation`             |
|                                                 | `Invoke-TestFile`             |
|                                                 | `Test-CatzcBuild`             |
|                                                 | `Test-InIsolation`            |
|                                                 | `Get-TestTargetSkipReason`    |
| config                                          | `test-policy.yml`             |
| responsibility:2 — Repository quality gates     | `Test-GeneratedFiles`         |
|                                                 | `Test-Formatting`             |
|                                                 | `Test-BuildArtifact`          |
|                                                 | `Test-ShippedConfigs`         |
|                                                 | `Test-SourceConventions`      |
|                                                 | `Test-TestTitles`             |
|                                                 | `Test-ManualTestPlan`         |
|                                                 | `Test-AnalyzerAdrMap`         |
|                                                 | `Test-ScriptAnalyzer`         |
|                                                 | `Test-LogicTestIdentity`      |
|                                                 | `Test-ConfigIdentityHygiene`  |
| config                                          | `analyzer-adr-map.yml`        |
| responsibility:3 — Document and code formatting | `Test-Spelling`               |
|                                                 | `Export-SpellingTriage`       |
|                                                 | `Test-Markdownlint`           |
|                                                 | `Format-Code`                 |
|                                                 | `Format-MarkdownTitle`        |
|                                                 | `Test-MarkdownTitle`          |
|                                                 | `Format-FileMeta`             |
|                                                 | `Test-FileMeta`               |
|                                                 | `Test-FileMetaProcessors`     |
|                                                 | `Format-Types`                |
|                                                 | `Test-PythonLint`             |
|                                                 | `Test-ShellScripts`           |
|                                                 | `Format-Links`                |
|                                                 | `Test-Links`                  |
|                                                 | `Export-Comments`             |
|                                                 | `Build-CommentView`           |
|                                                 | `Test-Comments`               |
| config                                          | `links.yml`                   |
|                                                 | `comments.yml`                |
| responsibility:4 — Terminology and dictionaries | `Build-TerminologyDictionary` |
|                                                 | `Build-EnglishDictionary`     |
|                                                 | `Test-Terminology`            |
| config                                          | `terminology.yml`             |
| responsibility:5 — Managed GUIDs                | `Get-ManagedGuids`            |
|                                                 | `Test-ManagedGuid`            |
|                                                 | `Assert-ManagedGuid`          |
|                                                 | `Get-RepositoryGuids`         |
|                                                 | `ConvertTo-Guid`              |
|                                                 | `Test-ManagedGuids`           |
| config                                          | `guids.yml`                   |
