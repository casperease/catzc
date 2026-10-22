# Catzc.Base.QualityGates

The quality-gate module. It **runs every check the repository applies to itself** — all tests (with tag-enforcement and timestamped
reporting), the repository-wide quality gates, the spell-checker, the Markdown linter, the formatters, the terminology registry, and the
managed-GUID registry. What it deliberately does **not** own is the tests themselves (each module keeps its own `tests/` folder), the
quality gates whose property belongs to another module (the module-graph quality gates live in
[Catzc.Base.ModuleSystem](catzc-base-module-system.md)), or the per-tool configuration (cSpell, markdownlint, and Prettier each carry their
own config at the repository root). A quality gate collects every issue, writes its report through
[Catzc.Base.Reports](catzc-base-reports.md), and throws once listing them all
([test-automation](../../drs/automation/test-automation.md#rule-adr-auto-test-qualitygate)); the tier and category tag rules the Pester
runner enforces are the subject of the same ADR.

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
are the subject of [test-automation](../../drs/automation/test-automation.md); the Go, Python and Bash tests are the subject of
[go-test-artifacts](../../drs/automation/go/go-test-artifacts.md),
[python-test-artifacts](../../drs/automation/python/python-test-artifacts.md) and
[bash-test-artifacts](../../drs/automation/bash/bash-test-artifacts.md).

### responsibility:2 — Repository quality gates

The gates that each check one property of the whole repository: every generated file equals what its generator would write now; every
formatter would leave the repository unchanged; the built artifact builds, loads, and matches its source; every shipped config has a
registered C# config type and loads through it
([module-config-loading](../../drs/configuration/module-config-loading.md#rule-adr-conf-loading-csharpconfigtype)); the source and test
files follow the naming and one-function conventions; test titles carry no unfilled template token; the manual test plan lists every
integrity check once; the analyzer-to-ADR map cites only real rules and maps every custom analyzer rule; the PowerShell passes
PSScriptAnalyzer; and test and production identities never cross — no logic test names a live identity, no shipped config carries a
test-fixture one, and no fixture identity is also a live one. An integrity test runs each gate at its tier, so every default test run and
every CI run includes it.

### responsibility:3 — Document and code formatting

How the repository checks and enforces the style of its written and source content. This responsibility runs the spell-checker (and collects
its flagged tokens into a triage queue), the Markdown linter, the Markdown formatter (which aligns tables and wraps prose in place), the
Markdown title and heading formatter and quality gate, the Markdown meta formatter and its two gates (the block itself and the registry's
processors), the one formatting command (`Format-Code`, which runs the formatter engine `languages.yml` names for each file language —
Prettier, the managed toolchain's `gofmt`, the pinned `ruff`, PSScriptAnalyzer, `dotnet format`, the pinned Bicep CLI — with one private
adapter per engine; [configure-not-program](../../drs/principles/configure-not-program.md)), the C# type-namespace formatter, the Python
lint and type quality gates (`Test-PythonLint`, `ruff check`; `Test-PythonTypes`, `pyright`, the engine Pylance runs in the editor) over
every `.py` file the repository holds, the shell-script quality gate (`Test-ShellScripts`: LF, the executable bit, and ShellCheck) over
every shell script it tracks ([bash-test-artifacts](../../drs/automation/bash/bash-test-artifacts.md)), the idiomatic-names quality gate and
its assertion (`Test-IdiomaticNames`, `Assert-IdiomaticNames`: every tracked file and its folders named in its language's idiom;
[idiomatic-names](../../drs/automation/idiomatic-names.md)), and the link aligner and quality gate, which keep code links repository-rooted
and markdown links relative and resolving ([markdown-links](../../drs/repository/markdown-links.md)), and the comment converters and their
quality gate, which move every long comment into its file's comment page, leaving nothing behind in the file, and write the annotated view
([comments-in-docs](../../drs/repository/comments-in-docs.md)). The responsibility owns the invocation of each tool, not the tool itself or
its per-tool configuration.

### responsibility:4 — Terminology and dictionaries

The terminology registry (`terminology.yml`) is the single authored source of the repository's approved vocabulary, grouped by category.
This responsibility generates the per-category spell-checker dictionaries from it and the committed English word list the spell-out-names
analyzer rule checks identifiers against, and checks the registry: no drift between it and the generated dictionaries, no orphan entries, no
unjustified ones.

### responsibility:5 — Managed GUIDs

The managed-GUID registry (`guids.yml`) names every GUID the repository is allowed to carry
([managed-guids](../../drs/automation/managed-guids.md)). This responsibility reads the registry, answers or asserts whether one GUID is
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
that are already protected, and derives one verdict. A `finally` stamps the run's `run.json` record on every exit from the run.

```yml drawio
description:
  "Both kinds of test run share one harness: it discovers the tests once, checks their tags before any run directory exists, splits the
  files into three phases, drops protected modules, runs the workers and derives one verdict; a finally stamps run.json."
about:
  adrs: [ADR-AUTO-TEST, ADR-REPO-PROTGLOB]
  lens: source
content:
  title: One discovery feeds three phases; finally stamps run.json
  kind: reference
  flow: top-to-bottom
  relation: runs next (code order)
  theme: dark
  bands:
    - { id: band-entry, label: ENTRY }
    - { id: band-before, label: BEFORE TRY }
    - { id: band-try, label: TRY }
    - { id: band-finally, label: FINALLY }
  glyphs:
    - { id: g-automation, kind: code, label: Test-Automation, in: band-entry }
    - { id: g-build, kind: code, label: Test-CatzcBuild, in: band-entry }
    - { id: g-run, kind: private, label: Invoke-TestRun, in: band-before }
    - { id: g-discovery, kind: private, label: Get-TestDiscovery, in: band-before }
    - { id: g-tag-gate, kind: gate, label: Assert-TestTagGate, in: band-before }
    - { id: g-split, kind: private, label: Split-TestAutomationFiles, in: band-try }
    - { id: s-parallel, kind: set, label: Parallel, in: band-try }
    - { id: s-greedy, kind: set, label: Greedy, in: band-try }
    - { id: s-serial, kind: set, label: Serial, in: band-try }
    - { id: g-select, kind: private, label: Select-ProtectedTestFile, in: band-try }
    - { id: g-workers, kind: private, label: Invoke-TestAutomationWorkers, in: band-try }
    - { id: g-verdict, kind: private, label: Get-TestAutomationVerdict, in: band-try }
    - { id: f-run-json, kind: file, label: run.json, in: band-finally }
  edges:
    - { from: g-automation, to: g-run, kind: flow, label: "" }
    - { from: g-build, to: g-run, kind: flow, label: "" }
    - { from: g-run, to: g-discovery, kind: flow, label: "" }
    - { from: g-discovery, to: g-tag-gate, kind: flow, label: "" }
    - { from: g-tag-gate, to: g-split, kind: flow, label: "" }
    - { from: g-split, to: g-select, kind: flow, label: "" }
    - { from: g-select, to: g-workers, kind: flow, label: "" }
    - { from: g-workers, to: g-verdict, kind: flow, label: "" }
  markers:
    - { at: g-run, number: 1 }
    - { at: g-discovery, number: 2 }
    - { at: g-tag-gate, number: 3 }
    - { at: g-split, number: 4 }
    - { at: g-select, number: 5 }
    - { at: g-workers, number: 6 }
    - { at: g-verdict, number: 7 }
    - { at: f-run-json, number: 8 }
  chips:
    - { at: g-discovery, kind: count, text: "4" }
  legend: auto
  minimaps:
    code-locations:
      - cell: .claude/.claude/.
        by: [.claude/CLAUDE.md, ADR-AUTO-TEST]
      - cell: .claude/.claude/agents
        by: [.claude/agents/test-optimization.md, ADR-AUTO-TEST]
      - cell: .claude/.claude/skills/catzc-module
        by: [.claude/skills/catzc-module/SKILL.md, ADR-AUTO-TEST]
      - cell: .claude/.claude/skills/test-speed
        by: [.claude/skills/test-speed/SKILL.md, ADR-AUTO-TEST]
      - cell: ado-pipelines/pipelines/.
        by: [.ado/pipelines/ci-infrastructure.yaml, .ado/pipelines/ci-pwsh.yaml, ADR-AUTO-TEST]
      - cell: docs/-/.
        by:
          - docs/drs/automation/dora-explains.md
          - docs/drs/automation/test-automation.md
          - docs/drs/glossary.md
          - docs/drs/index.md
          - docs/drs/repository/dora-explains.md
          - docs/drs/repository/protected-globs.md
          - docs/how-to/getting-started/pwsh/run-tests-and-checks.md
          - docs/how-to/pwsh/manual-test-plan.md
          - docs/how-to/pwsh/manual-test-plan/azure.md
          - docs/how-to/pwsh/manual-test-plan/test-harness.md
          - docs/references/ado/pipelines/ci-infrastructure.yaml.md
          - docs/references/ado/pipelines/ci-pwsh.yaml.md
          - docs/references/pwsh/catzc-azure-dev-ops-build-validation/tests/types/BuildValidationConfig.Tests.ps1.md
          - docs/references/pwsh/catzc-azure-dev-ops/Test-Pipelines.ps1.md
          - docs/references/pwsh/catzc-azure-dev-ops/configs/identity-tokens.yml.md
          - docs/references/pwsh/catzc-azure-dev-ops/tests/Get-AdoYamlFiles.Tests.ps1.md
          - docs/references/pwsh/catzc-azure-templates/Get-BicepTemplatesOutputRoot.ps1.md
          - docs/references/pwsh/catzc-azure-templates/tests/Assert-BicepTemplate.Tests.ps1.md
          - docs/references/pwsh/catzc-azure-templates/tests/Build-Bicep.Integrity.Tests.ps1.md
          - docs/references/pwsh/catzc-azure-templates/tests/Build-Bicep.L2.Tests.ps1.md
          - docs/references/pwsh/catzc-azure-templates/tests/Build-Bicep.SampleCustomer.Tests.ps1.md
          - docs/references/pwsh/catzc-azure-templates/tests/Build-Bicep.SampleIndexed.Tests.ps1.md
          - docs/references/pwsh/catzc-azure-templates/tests/Build-Bicep.SampleSubscription.Tests.ps1.md
          - docs/references/pwsh/catzc-azure-templates/tests/Build-Bicep.SampleWithModule.Tests.ps1.md
          - docs/references/pwsh/catzc-azure-templates/tests/Build-Bicep.SampleWithPrepost.Tests.ps1.md
          - docs/references/pwsh/catzc-azure-templates/tests/Build-Bicep.Tests.ps1.md
          - docs/references/pwsh/catzc-azure-templates/tests/Deploy-Bicep.SampleSubscription.Tests.ps1.md
          - docs/references/pwsh/catzc-azure-templates/tests/Deploy-Bicep.Tests.ps1.md
          - docs/references/pwsh/catzc-azure-templates/tests/Get-BicepDeploymentContext.Tests.ps1.md
          - docs/references/pwsh/catzc-azure-templates/tests/Get-BicepParameterModel.Shipped.Tests.ps1.md
          - docs/references/pwsh/catzc-azure-templates/tests/Get-BicepParameterModel.Tests.ps1.md
          - docs/references/pwsh/catzc-azure-templates/tests/Get-BicepParameterViolations.Tests.ps1.md
          - docs/references/pwsh/catzc-azure-templates/tests/Get-BicepResourceGroupName.Tests.ps1.md
          - docs/references/pwsh/catzc-azure-templates/tests/Get-BicepResourceName.Tests.ps1.md
          - docs/references/pwsh/catzc-azure-templates/tests/Get-BicepTemplate.Tests.ps1.md
          - docs/references/pwsh/catzc-azure-templates/tests/Get-BicepTemplateConfiguration.Tests.ps1.md
          - docs/references/pwsh/catzc-azure-templates/tests/Get-BicepTemplateCustomers.Tests.ps1.md
          - docs/references/pwsh/catzc-azure-templates/tests/Get-BicepTemplateNames.Tests.ps1.md
          - docs/references/pwsh/catzc-azure-templates/tests/Get-BicepTemplateSlots.Tests.ps1.md
          - docs/references/pwsh/catzc-azure-templates/tests/Get-BicepTemplates.Tests.ps1.md
          - docs/references/pwsh/catzc-azure-templates/tests/Get-BicepTrackTagNameSet.Tests.ps1.md
          - docs/references/pwsh/catzc-azure-templates/tests/Resolve-BicepParameterAddresses.Tests.ps1.md
          - docs/references/pwsh/catzc-azure-templates/tests/Set-BicepTemplateConfiguration.Tests.ps1.md
          - docs/references/pwsh/catzc-azure-templates/tests/types/BicepShortName.Tests.ps1.md
          - docs/references/pwsh/catzc-azure/Test-AzureNetworkPlan.ps1.md
          - docs/references/pwsh/catzc-azure/configs/identity-tokens.yml.md
          - docs/references/pwsh/catzc-azure/tests/Get-AzureBicepMinVersion.Tests.ps1.md
          - docs/references/pwsh/catzc-azure/tests/Get-AzureCustomer.Tests.ps1.md
          - docs/references/pwsh/catzc-azure/tests/Get-AzureCustomers.Tests.ps1.md
          - docs/references/pwsh/catzc-azure/tests/Get-AzureEnvironment.Tests.ps1.md
          - docs/references/pwsh/catzc-azure/tests/Get-AzureSubscription.Tests.ps1.md
          - docs/references/pwsh/catzc-azure/tests/Get-AzureSubscriptionEnvironment.Tests.ps1.md
          - docs/references/pwsh/catzc-azure/tests/Test-AzureNetworkPlan.Tests.ps1.md
          - docs/references/pwsh/catzc-azure/tests/types/AzureConfig.Tests.ps1.md
          - docs/references/pwsh/catzc-azure/tests/types/NetworkConfig.Tests.ps1.md
          - docs/references/pwsh/catzc-base-config-extensions/Test-ConfigValidators.ps1.md
          - docs/references/pwsh/catzc-base-config-extensions/tests/Invoke-ConfigValidator.Tests.ps1.md
          - docs/references/pwsh/catzc-base-config-extensions/tests/Test-ConfigValidators.Tests.ps1.md
          - docs/references/pwsh/catzc-base-config/tests/Config-Conventions.Tests.ps1.md
          - docs/references/pwsh/catzc-base-config/tests/Get-Config.Tests.ps1.md
          - docs/references/pwsh/catzc-base-config/tests/Get-ConfigValue.Tests.ps1.md
          - docs/references/pwsh/catzc-base-contracts/Test-Contracts.ps1.md
          - docs/references/pwsh/catzc-base-contracts/tests/Build-ContractReference.Tests.ps1.md
          - docs/references/pwsh/catzc-base-contracts/tests/ConvertTo-ContractNoteMarkdown.Tests.ps1.md
          - docs/references/pwsh/catzc-base-contracts/tests/Get-ContractAssetNote.Tests.ps1.md
          - docs/references/pwsh/catzc-base-contracts/tests/Get-ContractCheckResults.Assets.Tests.ps1.md
          - docs/references/pwsh/catzc-base-contracts/tests/Get-ContractFreezeFindings.Tests.ps1.md
          - docs/references/pwsh/catzc-base-contracts/tests/Publish-ContractRelease.Tests.ps1.md
          - docs/references/pwsh/catzc-base-contracts/tests/Test-Contracts.Tests.ps1.md
          - docs/references/pwsh/catzc-base-docs.md
          - docs/references/pwsh/catzc-base-docs/Test-AgentDefinitions.ps1.md
          - docs/references/pwsh/catzc-base-docs/Test-GeneratedReadmes.ps1.md
          - docs/references/pwsh/catzc-base-docs/Test-Glossary.ps1.md
          - docs/references/pwsh/catzc-base-docs/private/Get-GlossaryRuleStatements.ps1.md
          - docs/references/pwsh/catzc-base-docs/tests/Build-Glossary.Tests.ps1.md
          - docs/references/pwsh/catzc-base-docs/tests/Get-AgentFrontMatter.Tests.ps1.md
          - docs/references/pwsh/catzc-base-docs/tests/Get-CatsRuleEnforcers.Tests.ps1.md
          - docs/references/pwsh/catzc-base-docs/tests/Get-ClaudeMdAgentNames.Tests.ps1.md
          - docs/references/pwsh/catzc-base-docs/tests/Get-Glossary.Tests.ps1.md
          - docs/references/pwsh/catzc-base-docs/tests/Get-GlossaryAnchorViolations.Tests.ps1.md
          - docs/references/pwsh/catzc-base-docs/tests/Get-GlossaryDefinitionViolations.Tests.ps1.md
          - docs/references/pwsh/catzc-base-docs/tests/Get-GlossaryEnforcementViolations.Tests.ps1.md
          - docs/references/pwsh/catzc-base-docs/tests/Get-GlossaryFormViolations.Tests.ps1.md
          - docs/references/pwsh/catzc-base-docs/tests/Get-GlossaryPhrasingViolations.Tests.ps1.md
          - docs/references/pwsh/catzc-base-docs/tests/Get-GlossaryRuleStatements.Tests.ps1.md
          - docs/references/pwsh/catzc-base-docs/tests/Get-GlossarySourceViolations.Tests.ps1.md
          - docs/references/pwsh/catzc-base-docs/tests/Get-GlossarySources.Tests.ps1.md
          - docs/references/pwsh/catzc-base-docs/tests/Test-AgentDefinitions.Tests.ps1.md
          - docs/references/pwsh/catzc-base-docs/tests/Test-GeneratedReadmes.Tests.ps1.md
          - docs/references/pwsh/catzc-base-docs/tests/Test-Glossary.Tests.ps1.md
          - docs/references/pwsh/catzc-base-docs/tests/types/AgentEntry.Tests.ps1.md
          - docs/references/pwsh/catzc-base-docs/tests/types/AgentsConfig.Tests.ps1.md
          - docs/references/pwsh/catzc-base-docs/tests/types/GlossaryConfig.Tests.ps1.md
          - docs/references/pwsh/catzc-base-docs/tests/types/GlossaryEntry.Tests.ps1.md
          - docs/references/pwsh/catzc-base-docs/types/GlossaryConcept.cs.md
          - docs/references/pwsh/catzc-base-drs/Test-DrsEngineNeutrality.ps1.md
          - docs/references/pwsh/catzc-base-drs/Test-DrsRegistry.ps1.md
          - docs/references/pwsh/catzc-base-drs/configs/drs-checks.yml.md
          - docs/references/pwsh/catzc-base-drs/tests/ConvertTo-DrsDomainDiagram.Tests.ps1.md
          - docs/references/pwsh/catzc-base-drs/tests/Get-DrsCitationGraphViolations.Tests.ps1.md
          - docs/references/pwsh/catzc-base-drs/tests/Get-DrsCitationMap.Tests.ps1.md
          - docs/references/pwsh/catzc-base-drs/tests/Get-DrsDomainEdges.Tests.ps1.md
          - docs/references/pwsh/catzc-base-drs/tests/Get-DrsDoraCoverageViolations.Tests.ps1.md
          - docs/references/pwsh/catzc-base-drs/tests/Get-DrsFileIndex.Tests.ps1.md
          - docs/references/pwsh/catzc-base-drs/tests/Get-DrsRuleSet.Tests.ps1.md
          - docs/references/pwsh/catzc-base-drs/tests/Get-DrsRuleSummaryLines.Tests.ps1.md
          - docs/references/pwsh/catzc-base-drs/tests/Resolve-DrsLinkTarget.Tests.ps1.md
          - docs/references/pwsh/catzc-base-drs/tests/Test-DrsEngineNeutrality.Tests.ps1.md
          - docs/references/pwsh/catzc-base-drs/tests/Test-DrsRegistry.Tests.ps1.md
          - docs/references/pwsh/catzc-base-drs/tests/Update-DrsCitation.Tests.ps1.md
          - docs/references/pwsh/catzc-base-drs/tests/types/DrsChecksConfig.Tests.ps1.md
          - docs/references/pwsh/catzc-base-drs/tests/types/DrsDomainEdge.Tests.ps1.md
          - docs/references/pwsh/catzc-base-drs/types/DrsChecksConfig.cs.md
          - docs/references/pwsh/catzc-base-execution/Invoke-Executable.ps1.md
          - docs/references/pwsh/catzc-base-execution/tests/Find-Executable.Tests.ps1.md
          - docs/references/pwsh/catzc-base-execution/tests/Get-ExecutableVersion.Tests.ps1.md
          - docs/references/pwsh/catzc-base-execution/tests/Resolve-EngineExecutable.Tests.ps1.md
          - docs/references/pwsh/catzc-base-execution/tests/Resolve-ToolExecutable.Tests.ps1.md
          - docs/references/pwsh/catzc-base-execution/tests/types/CliRunner.Tests.ps1.md
          - docs/references/pwsh/catzc-base-execution/tests/types/ExecutableProbe.Tests.ps1.md
          - docs/references/pwsh/catzc-base-execution/tests/types/ToolConfig.Tests.ps1.md
          - docs/references/pwsh/catzc-base-execution/tests/types/ToolsConfig.Tests.ps1.md
          - docs/references/pwsh/catzc-base-exporter/tests/Assert-CatzcBundle.Tests.ps1.md
          - docs/references/pwsh/catzc-base-exporter/tests/Install-Catzc.Tests.ps1.md
          - docs/references/pwsh/catzc-base-exporter/tests/New-CatzcNuGetPackage.Tests.ps1.md
          - docs/references/pwsh/catzc-base-files/tests/Get-GitChangedPath.Tests.ps1.md
          - docs/references/pwsh/catzc-base-globs.md
          - docs/references/pwsh/catzc-base-globs/Clear-GlobSetProtection.ps1.md
          - docs/references/pwsh/catzc-base-globs/Get-MarkerBlastRadius.ps1.md
          - docs/references/pwsh/catzc-base-globs/Get-ModuleGlobSet.ps1.md
          - docs/references/pwsh/catzc-base-globs/Protect-GlobSet.ps1.md
          - docs/references/pwsh/catzc-base-globs/Test-AdoPipelineTriggerGlob.ps1.md
          - docs/references/pwsh/catzc-base-globs/Test-GitHubWorkflowTriggerGlob.ps1.md
          - docs/references/pwsh/catzc-base-globs/Test-GlobSetIndependence.ps1.md
          - docs/references/pwsh/catzc-base-globs/Test-GlobSetProtection.ps1.md
          - docs/references/pwsh/catzc-base-globs/Test-GlobSetTriggerCoverage.ps1.md
          - docs/references/pwsh/catzc-base-globs/configs/globs.yml.md
          - docs/references/pwsh/catzc-base-globs/tests/Get-ChangedGlobSet.Tests.ps1.md
          - docs/references/pwsh/catzc-base-globs/tests/Get-GlobSet.Tests.ps1.md
          - docs/references/pwsh/catzc-base-globs/tests/Get-ModuleGlobSet.Tests.ps1.md
          - docs/references/pwsh/catzc-base-globs/tests/GlobSetTrigger-Coverage.Tests.ps1.md
          - docs/references/pwsh/catzc-base-globs/tests/Test-AdoPipelineTriggerGlob.Tests.ps1.md
          - docs/references/pwsh/catzc-base-globs/tests/Test-GitHubWorkflowTriggerGlob.Tests.ps1.md
          - docs/references/pwsh/catzc-base-globs/tests/Test-GlobSetAffected.Tests.ps1.md
          - docs/references/pwsh/catzc-base-globs/tests/Test-GlobSetIndependence.Tests.ps1.md
          - docs/references/pwsh/catzc-base-globs/tests/Test-GlobSetProtection.Tests.ps1.md
          - docs/references/pwsh/catzc-base-globs/tests/Test-GlobSetTriggerCoverage.Tests.ps1.md
          - docs/references/pwsh/catzc-base-globs/tests/types/GlobsConfig.Tests.ps1.md
          - docs/references/pwsh/catzc-base-globs/types/GlobSet.cs.md
          - docs/references/pwsh/catzc-base-globs/types/GlobsConfig.cs.md
          - docs/references/pwsh/catzc-base-languages.md
          - docs/references/pwsh/catzc-base-languages/tests/ConvertFrom-BatsJunit.Tests.ps1.md
          - docs/references/pwsh/catzc-base-languages/tests/ConvertFrom-PytestJunit.Tests.ps1.md
          - docs/references/pwsh/catzc-base-languages/tests/Get-EngineContract.Tests.ps1.md
          - docs/references/pwsh/catzc-base-languages/tests/Invoke-BashTest.Tests.ps1.md
          - docs/references/pwsh/catzc-base-languages/tests/Invoke-GoTest.Tests.ps1.md
          - docs/references/pwsh/catzc-base-languages/tests/Invoke-PythonTest.Tests.ps1.md
          - docs/references/pwsh/catzc-base-languages/tests/New-GoWorkspace.Tests.ps1.md
          - docs/references/pwsh/catzc-base-languages/tests/New-PythonProject.Tests.ps1.md
          - docs/references/pwsh/catzc-base-languages/types/BashTestResult.cs.md
          - docs/references/pwsh/catzc-base-languages/types/GoTestResult.cs.md
          - docs/references/pwsh/catzc-base-languages/types/PythonTestResult.cs.md
          - docs/references/pwsh/catzc-base-maps/Get-ValueChainHighlight.ps1.md
          - docs/references/pwsh/catzc-base-maps/Test-ValueChainMap.ps1.md
          - docs/references/pwsh/catzc-base-maps/Test-WorldMap.ps1.md
          - docs/references/pwsh/catzc-base-maps/tests/Get-ValueChainHighlight.Tests.ps1.md
          - docs/references/pwsh/catzc-base-maps/tests/Get-ValueChainMap.Tests.ps1.md
          - docs/references/pwsh/catzc-base-maps/tests/Test-ValueChainMap.Tests.ps1.md
          - docs/references/pwsh/catzc-base-maps/tests/Test-WorldMap.Tests.ps1.md
          - docs/references/pwsh/catzc-base-maps/tests/types/ValueChainHighlight.Tests.ps1.md
          - docs/references/pwsh/catzc-base-maps/tests/types/ValueChainMap.Tests.ps1.md
          - docs/references/pwsh/catzc-base-module-system.md
          - docs/references/pwsh/catzc-base-module-system/Get-FunctionDependency.ps1.md
          - docs/references/pwsh/catzc-base-module-system/Test-CheckedInBinaries.ps1.md
          - docs/references/pwsh/catzc-base-module-system/Test-FolderConventions.ps1.md
          - docs/references/pwsh/catzc-base-module-system/Test-FunctionDependency.ps1.md
          - docs/references/pwsh/catzc-base-module-system/Test-InternalAssetDependency.ps1.md
          - docs/references/pwsh/catzc-base-module-system/Test-ModuleCycles.ps1.md
          - docs/references/pwsh/catzc-base-module-system/Test-ModuleDependency.ps1.md
          - docs/references/pwsh/catzc-base-module-system/configs/artifacts.yml.md
          - docs/references/pwsh/catzc-base-module-system/private/Get-UncoveredInternalAssetDependency.ps1.md
          - docs/references/pwsh/catzc-base-module-system/tests/Get-InternalAssetDependency.Integrity.Tests.ps1.md
          - docs/references/pwsh/catzc-base-module-system/tests/Get-InternalAssetDependency.Tests.ps1.md
          - docs/references/pwsh/catzc-base-module-system/tests/Get-UncoveredInternalAssetDependency.Tests.ps1.md
          - docs/references/pwsh/catzc-base-module-system/tests/Test-CheckedInBinaries.Tests.ps1.md
          - docs/references/pwsh/catzc-base-module-system/tests/Test-FolderConventions.Tests.ps1.md
          - docs/references/pwsh/catzc-base-module-system/tests/Test-FunctionDependency.Tests.ps1.md
          - docs/references/pwsh/catzc-base-module-system/tests/Test-InternalAssetDependency.Tests.ps1.md
          - docs/references/pwsh/catzc-base-module-system/tests/Test-ModuleCycles.Tests.ps1.md
          - docs/references/pwsh/catzc-base-module-system/tests/Test-ModuleDependency.Tests.ps1.md
          - docs/references/pwsh/catzc-base-module-system/types/ArtifactsConfig.cs.md
          - docs/references/pwsh/catzc-base-objects/tests/types/ConsoleText.Tests.ps1.md
          - docs/references/pwsh/catzc-base-objects/tests/types/DictionaryRecord.Tests.ps1.md
          - docs/references/pwsh/catzc-base-overlay/tests/Overlay.Fixture.ps1.md
          - docs/references/pwsh/catzc-base-quality-gates/Get-TestTargetSkipReason.ps1.md
          - docs/references/pwsh/catzc-base-quality-gates/Invoke-TestFile.ps1.md
          - docs/references/pwsh/catzc-base-quality-gates/Test-AnalyzerDrsMap.ps1.md
          - docs/references/pwsh/catzc-base-quality-gates/Test-Automation.ps1.md
          - docs/references/pwsh/catzc-base-quality-gates/Test-BuildArtifact.ps1.md
          - docs/references/pwsh/catzc-base-quality-gates/Test-CatzcBuild.ps1.md
          - docs/references/pwsh/catzc-base-quality-gates/Test-Change.ps1.md
          - docs/references/pwsh/catzc-base-quality-gates/Test-Comments.ps1.md
          - docs/references/pwsh/catzc-base-quality-gates/Test-ConfigIdentityHygiene.ps1.md
          - docs/references/pwsh/catzc-base-quality-gates/Test-FileMeta.ps1.md
          - docs/references/pwsh/catzc-base-quality-gates/Test-FileMetaProcessors.ps1.md
          - docs/references/pwsh/catzc-base-quality-gates/Test-Formatting.ps1.md
          - docs/references/pwsh/catzc-base-quality-gates/Test-GeneratedFiles.ps1.md
          - docs/references/pwsh/catzc-base-quality-gates/Test-Links.ps1.md
          - docs/references/pwsh/catzc-base-quality-gates/Test-LogicTestIdentity.ps1.md
          - docs/references/pwsh/catzc-base-quality-gates/Test-ManagedGuids.ps1.md
          - docs/references/pwsh/catzc-base-quality-gates/Test-ManualTestPlan.ps1.md
          - docs/references/pwsh/catzc-base-quality-gates/Test-MarkdownTitle.ps1.md
          - docs/references/pwsh/catzc-base-quality-gates/Test-Markdownlint.ps1.md
          - docs/references/pwsh/catzc-base-quality-gates/Test-ParameterConsistency.ps1.md
          - docs/references/pwsh/catzc-base-quality-gates/Test-Plans.ps1.md
          - docs/references/pwsh/catzc-base-quality-gates/Test-ScriptAnalyzer.ps1.md
          - docs/references/pwsh/catzc-base-quality-gates/Test-ShippedConfigs.ps1.md
          - docs/references/pwsh/catzc-base-quality-gates/Test-SourceConventions.ps1.md
          - docs/references/pwsh/catzc-base-quality-gates/Test-Spelling.ps1.md
          - docs/references/pwsh/catzc-base-quality-gates/Test-Terminology.ps1.md
          - docs/references/pwsh/catzc-base-quality-gates/Test-TestTitles.ps1.md
          - docs/references/pwsh/catzc-base-quality-gates/configs/generated-files.yml.md
          - docs/references/pwsh/catzc-base-quality-gates/configs/source-conventions.yml.md
          - docs/references/pwsh/catzc-base-quality-gates/configs/terminology.yml.md
          - docs/references/pwsh/catzc-base-quality-gates/configs/test-policy.yml.md
          - docs/references/pwsh/catzc-base-quality-gates/private/Assert-TestTagGate.ps1.md
          - docs/references/pwsh/catzc-base-quality-gates/private/Enter-SystemTestLock.ps1.md
          - docs/references/pwsh/catzc-base-quality-gates/private/Enter-TestRunLocation.ps1.md
          - docs/references/pwsh/catzc-base-quality-gates/private/Get-GeneratedFileGenerator.ps1.md
          - docs/references/pwsh/catzc-base-quality-gates/private/Get-LanguageTestOutcomes.ps1.md
          - docs/references/pwsh/catzc-base-quality-gates/private/Get-LiveIdentityTokens.ps1.md
          - docs/references/pwsh/catzc-base-quality-gates/private/Get-LogicTestIdentityFinding.ps1.md
          - docs/references/pwsh/catzc-base-quality-gates/private/Get-ModuleProtectionIdentity.ps1.md
          - docs/references/pwsh/catzc-base-quality-gates/private/Get-NeutralCodeFinding.ps1.md
          - docs/references/pwsh/catzc-base-quality-gates/private/Get-TestFileModule.ps1.md
          - docs/references/pwsh/catzc-base-quality-gates/private/Get-TestOptOutExclusion.ps1.md
          - docs/references/pwsh/catzc-base-quality-gates/private/Get-TestRunLocationEntry.ps1.md
          - docs/references/pwsh/catzc-base-quality-gates/private/Invoke-BuildArtifactProbe.ps1.md
          - docs/references/pwsh/catzc-base-quality-gates/private/Invoke-TestAutomationWorkers.ps1.md
          - docs/references/pwsh/catzc-base-quality-gates/private/Invoke-TestRun.ps1.md
          - docs/references/pwsh/catzc-base-quality-gates/private/New-PesterRunConfiguration.ps1.md
          - docs/references/pwsh/catzc-base-quality-gates/private/New-TestAutomationShardScript.ps1.md
          - docs/references/pwsh/catzc-base-quality-gates/private/Protect-TestedModule.ps1.md
          - docs/references/pwsh/catzc-base-quality-gates/private/Resolve-TestRunMaxLevel.ps1.md
          - docs/references/pwsh/catzc-base-quality-gates/private/Resolve-TestSuite.ps1.md
          - docs/references/pwsh/catzc-base-quality-gates/private/Select-ProtectedTestFile.ps1.md
          - docs/references/pwsh/catzc-base-quality-gates/private/Select-TestRunFiles.ps1.md
          - docs/references/pwsh/catzc-base-quality-gates/private/Split-TestAutomationFiles.ps1.md
          - docs/references/pwsh/catzc-base-quality-gates/private/Test-TestRunOverBudget.ps1.md
          - docs/references/pwsh/catzc-base-quality-gates/private/Write-TestAutomationHeader.ps1.md
          - docs/references/pwsh/catzc-base-quality-gates/private/Write-TestAutomationReport.ps1.md
          - docs/references/pwsh/catzc-base-quality-gates/private/Write-TestOptOutExclusion.ps1.md
          - docs/references/pwsh/catzc-base-quality-gates/tests/Build-EnglishDictionary.Tests.ps1.md
          - docs/references/pwsh/catzc-base-quality-gates/tests/ConvertTo-PesterRunTarget.Tests.ps1.md
          - docs/references/pwsh/catzc-base-quality-gates/tests/Format-Code.Tests.ps1.md
          - docs/references/pwsh/catzc-base-quality-gates/tests/Format-Links.Tests.ps1.md
          - docs/references/pwsh/catzc-base-quality-gates/tests/Format-Types.Tests.ps1.md
          - docs/references/pwsh/catzc-base-quality-gates/tests/Get-AnalyzerDrsCoverage.Tests.ps1.md
          - docs/references/pwsh/catzc-base-quality-gates/tests/Get-BashTestCases.Tests.ps1.md
          - docs/references/pwsh/catzc-base-quality-gates/tests/Get-ChangeCheckPlan.Tests.ps1.md
          - docs/references/pwsh/catzc-base-quality-gates/tests/Get-ChangeTestFile.Tests.ps1.md
          - docs/references/pwsh/catzc-base-quality-gates/tests/Get-EngineSetFinding.Tests.ps1.md
          - docs/references/pwsh/catzc-base-quality-gates/tests/Get-FixtureIdentityTokens.Tests.ps1.md
          - docs/references/pwsh/catzc-base-quality-gates/tests/Get-FormatEngineStamp.Tests.ps1.md
          - docs/references/pwsh/catzc-base-quality-gates/tests/Get-FormatScope.Tests.ps1.md
          - docs/references/pwsh/catzc-base-quality-gates/tests/Get-GoTestCases.Tests.ps1.md
          - docs/references/pwsh/catzc-base-quality-gates/tests/Get-LanguageTestExecutable.Tests.ps1.md
          - docs/references/pwsh/catzc-base-quality-gates/tests/Get-LanguageTestFolders.Tests.ps1.md
          - docs/references/pwsh/catzc-base-quality-gates/tests/Get-LanguageTestOutcomes.Tests.ps1.md
          - docs/references/pwsh/catzc-base-quality-gates/tests/Get-LiveIdentityTokens.Tests.ps1.md
          - docs/references/pwsh/catzc-base-quality-gates/tests/Get-ModuleProtectionIdentity.Tests.ps1.md
          - docs/references/pwsh/catzc-base-quality-gates/tests/Get-NeutralCodeFinding.Tests.ps1.md
          - docs/references/pwsh/catzc-base-quality-gates/tests/Get-ParameterTypeConflict.Tests.ps1.md
          - docs/references/pwsh/catzc-base-quality-gates/tests/Get-PythonCheckScope.Tests.ps1.md
          - docs/references/pwsh/catzc-base-quality-gates/tests/Get-PythonTestCases.Tests.ps1.md
          - docs/references/pwsh/catzc-base-quality-gates/tests/Get-RepositoryGuids.Tests.ps1.md
          - docs/references/pwsh/catzc-base-quality-gates/tests/Get-TestAutomationTestPaths.Tests.ps1.md
          - docs/references/pwsh/catzc-base-quality-gates/tests/Get-TestFileModule.Tests.ps1.md
          - docs/references/pwsh/catzc-base-quality-gates/tests/Get-TestRunContext.Tests.ps1.md
          - docs/references/pwsh/catzc-base-quality-gates/tests/Get-TestRunFile.Tests.ps1.md
          - docs/references/pwsh/catzc-base-quality-gates/tests/Get-TestTagViolations.Tests.ps1.md
          - docs/references/pwsh/catzc-base-quality-gates/tests/Invoke-BicepFormat.Tests.ps1.md
          - docs/references/pwsh/catzc-base-quality-gates/tests/Invoke-DotnetFormat.Tests.ps1.md
          - docs/references/pwsh/catzc-base-quality-gates/tests/Invoke-Gofmt.Tests.ps1.md
          - docs/references/pwsh/catzc-base-quality-gates/tests/Invoke-ImprintStep.Tests.ps1.md
          - docs/references/pwsh/catzc-base-quality-gates/tests/Invoke-Prettier.Tests.ps1.md
          - docs/references/pwsh/catzc-base-quality-gates/tests/Invoke-PythonWorkspaceTool.Tests.ps1.md
          - docs/references/pwsh/catzc-base-quality-gates/tests/Invoke-RuffFormat.Tests.ps1.md
          - docs/references/pwsh/catzc-base-quality-gates/tests/Invoke-TestFile.Tests.ps1.md
          - docs/references/pwsh/catzc-base-quality-gates/tests/Language.Bridge.ps1.md
          - docs/references/pwsh/catzc-base-quality-gates/tests/ManualTestPlan-Coverage.Tests.ps1.md
          - docs/references/pwsh/catzc-base-quality-gates/tests/Measure-QualityGates.Tests.ps1.md
          - docs/references/pwsh/catzc-base-quality-gates/tests/New-TestAutomationShardScript.Tests.ps1.md
          - docs/references/pwsh/catzc-base-quality-gates/tests/New-TestRunFinalManifest.Tests.ps1.md
          - docs/references/pwsh/catzc-base-quality-gates/tests/Save-TestDurationHistory.Tests.ps1.md
          - docs/references/pwsh/catzc-base-quality-gates/tests/Select-TestShardAssignment.Tests.ps1.md
          - docs/references/pwsh/catzc-base-quality-gates/tests/Split-CachedFile.Tests.ps1.md
          - docs/references/pwsh/catzc-base-quality-gates/tests/Test-AnalyzerDrsMap.Tests.ps1.md
          - docs/references/pwsh/catzc-base-quality-gates/tests/Test-Automation.Tests.ps1.md
          - docs/references/pwsh/catzc-base-quality-gates/tests/Test-BuildArtifact.Tests.ps1.md
          - docs/references/pwsh/catzc-base-quality-gates/tests/Test-Change.Tests.ps1.md
          - docs/references/pwsh/catzc-base-quality-gates/tests/Test-ConfigIdentityHygiene.Tests.ps1.md
          - docs/references/pwsh/catzc-base-quality-gates/tests/Test-FileMetaProcessors.Tests.ps1.md
          - docs/references/pwsh/catzc-base-quality-gates/tests/Test-Formatting.Tests.ps1.md
          - docs/references/pwsh/catzc-base-quality-gates/tests/Test-GeneratedFiles.Tests.ps1.md
          - docs/references/pwsh/catzc-base-quality-gates/tests/Test-Links.Tests.ps1.md
          - docs/references/pwsh/catzc-base-quality-gates/tests/Test-Links.Untracked.Tests.ps1.md
          - docs/references/pwsh/catzc-base-quality-gates/tests/Test-LogicTestIdentity.Tests.ps1.md
          - docs/references/pwsh/catzc-base-quality-gates/tests/Test-ManagedGuids.Tests.ps1.md
          - docs/references/pwsh/catzc-base-quality-gates/tests/Test-ManualTestPlan.Tests.ps1.md
          - docs/references/pwsh/catzc-base-quality-gates/tests/Test-Markdownlint.Tests.ps1.md
          - docs/references/pwsh/catzc-base-quality-gates/tests/Test-ParameterConsistency.Tests.ps1.md
          - docs/references/pwsh/catzc-base-quality-gates/tests/Test-PythonLint.Tests.ps1.md
          - docs/references/pwsh/catzc-base-quality-gates/tests/Test-ShellScripts.Tests.ps1.md
          - docs/references/pwsh/catzc-base-quality-gates/tests/Test-ShippedConfigs.Tests.ps1.md
          - docs/references/pwsh/catzc-base-quality-gates/tests/Test-SourceConventions.Tests.ps1.md
          - docs/references/pwsh/catzc-base-quality-gates/tests/Test-Spelling.Tests.ps1.md
          - docs/references/pwsh/catzc-base-quality-gates/tests/Test-TestTitles.Tests.ps1.md
          - docs/references/pwsh/catzc-base-quality-gates/tests/TestTitle-TemplateTokens.Tests.ps1.md
          - docs/references/pwsh/catzc-base-quality-gates/tests/Write-TestRunFailures.Tests.ps1.md
          - docs/references/pwsh/catzc-base-quality-gates/tests/types/EngineSetCheck.Tests.ps1.md
          - docs/references/pwsh/catzc-base-quality-gates/tests/types/SpellingOracle.Tests.ps1.md
          - docs/references/pwsh/catzc-base-quality-gates/types/IdentityTokenRule.cs.md
          - docs/references/pwsh/catzc-base-quality-gates/types/SourceConventionsConfig.cs.md
          - docs/references/pwsh/catzc-base-quality-gates/types/TestPolicyConfig.cs.md
          - docs/references/pwsh/catzc-base-reports/Write-QualityGateReport.ps1.md
          - docs/references/pwsh/catzc-base-reports/configs/reports.yml.md
          - docs/references/pwsh/catzc-base-reports/tests/Write-QualityGateReport.Tests.ps1.md
          - docs/references/pwsh/catzc-base-reports/tests/types/CheckModes.Tests.ps1.md
          - docs/references/pwsh/catzc-base-reports/types/CheckMode.cs.md
          - docs/references/pwsh/catzc-base-reports/types/ReportsConfig.cs.md
          - docs/references/pwsh/catzc-base-repository/tests/Get-RepositoryFile.Tests.ps1.md
          - docs/references/pwsh/catzc-base-repository/tests/Get-RepositoryFolder.Tests.ps1.md
          - docs/references/pwsh/catzc-base-repository/tests/types/ParsedScripts.Tests.ps1.md
          - docs/references/pwsh/catzc-base-repository/tests/types/SyntaxSearch.Tests.ps1.md
          - docs/references/pwsh/catzc-base-root-config.md
          - docs/references/pwsh/catzc-base-root-config/Test-RootAnalyzerSettings.ps1.md
          - docs/references/pwsh/catzc-base-root-config/Test-RootConfigFiles.ps1.md
          - docs/references/pwsh/catzc-base-root-config/tests/Build-RootConfig.Tests.ps1.md
          - docs/references/pwsh/catzc-base-root-config/tests/Get-RootConfigRenderedFile.Tests.ps1.md
          - docs/references/pwsh/catzc-base-root-config/tests/Test-RootAnalyzerSettings.Tests.ps1.md
          - docs/references/pwsh/catzc-base-root-config/tests/Test-RootConfigFiles.Tests.ps1.md
          - docs/references/pwsh/catzc-base-root-config/tests/Test-RootConfigIntegrity.Tests.ps1.md
          - docs/references/pwsh/catzc-base-timeouts/types/TestTiers.cs.md
          - docs/references/pwsh/catzc-base-types-system/Test-ShippedTypes.ps1.md
          - docs/references/pwsh/catzc-base-types-system/tests/Assert-LoadedTypesCurrent.Tests.ps1.md
          - docs/references/pwsh/catzc-base-types-system/tests/Test-ConsoleReadyType.Tests.ps1.md
          - docs/references/pwsh/catzc-base-types-system/tests/Test-LoadedTypesCurrent.Tests.ps1.md
          - docs/references/pwsh/catzc-base-types-system/tests/Test-ShippedTypes.Tests.ps1.md
          - docs/references/pwsh/catzc-tooling-core/Remove-SystemInstallation.ps1.md
          - docs/references/pwsh/catzc-tooling-core/tests/Assert-Tool.Tests.ps1.md
          - docs/references/pwsh/catzc-tooling-core/tests/Assert-ToolVersion.Tests.ps1.md
          - docs/references/pwsh/catzc-tooling-core/tests/Get-ToolConfig.Tests.ps1.md
          - docs/references/pwsh/catzc-tooling-core/tests/Get-ToolInstallOrder.Tests.ps1.md
          - docs/references/pwsh/catzc-tooling-core/tests/Remove-LinuxToolInstall.Tests.ps1.md
          - docs/references/pwsh/catzc-tooling-core/tests/Remove-MacToolInstall.Tests.ps1.md
          - docs/references/pwsh/catzc-tooling-core/tests/Test-ExpectedPackageManager.Tests.ps1.md
          - docs/references/pwsh/catzc-tooling-core/tests/Write-ToolProbeReport.Tests.ps1.md
          - docs/references/pwsh/catzc-tooling-inspiration/tests/Get-Inspiration.Tests.ps1.md
          - docs/references/pwsh/catzc-tooling-inspiration/tests/Resolve-InspirationRoot.Tests.ps1.md
          - docs/references/pwsh/catzc-tooling-inspiration/tests/types/InspirationConfig.Tests.ps1.md
          - docs/references/pwsh/catzc-tooling-inspiration/tests/types/InspirationRoot.Tests.ps1.md
          - docs/references/pwsh/catzc-tooling-key-handler/private/Select-SupportedKeyHandler.ps1.md
          - docs/references/pwsh/catzc-tooling-key-handler/tests/Import-PsReadLineKeyHandlerSet.Tests.ps1.md
          - docs/references/pwsh/catzc-tooling-key-handler/tests/Select-SupportedKeyHandler.Tests.ps1.md
          - docs/references/pwsh/catzc-tooling-provisioning/Uninstall-Chocolatey.ps1.md
          - docs/references/pwsh/catzc-tooling-provisioning/tests/Get-PackageTreePlan.Tests.ps1.md
          - docs/references/pwsh/catzc-tooling-provisioning/tests/Get-ToolsStatus.Tests.ps1.md
          - docs/references/pwsh/catzc-tooling-provisioning/tests/Get-ZshInstallLayout.Tests.ps1.md
          - docs/references/pwsh/catzc-tooling-provisioning/tests/Install-Zsh.Tests.ps1.md
          - docs/references/pwsh/catzc-tooling-provisioning/tests/Uninstall-Chocolatey.Tests.ps1.md
          - docs/references/pwsh/catzc-tooling-provisioning/tests/Uninstall-Zsh.Tests.ps1.md
          - docs/references/pwsh/catzc-tooling-python/tests/Install-PipTool.Tests.ps1.md
          - docs/references/pwsh/catzc-tooling-toolchain/tests/Install-BicepStandalone.Tests.ps1.md
          - docs/references/pwsh/catzc-tooling-toolchain/tests/Update-BatsVendor.Tests.ps1.md
          - docs/references/pwsh/internal/tests/Import-AllModules.Tests.ps1.md
          - docs/references/pwsh/internal/tests/Test-FolderConventions.Tests.ps1.md
          - ADR-AUTO-TEST
          - ADR-REPO-PROTGLOB
      - cell: pwsh/-/.
        by: [pwsh/.scriptanalyzer/tests/AnnounceStateChange.Tests.ps1, ADR-AUTO-TEST]
      - cell: pwsh/Catzc.Azure/.
        by: [pwsh/Catzc.Azure/Test-AzureNetworkPlan.ps1, ADR-AUTO-TEST]
      - cell: pwsh/Catzc.Azure/configs
        by: [pwsh/Catzc.Azure/configs/identity-tokens.yml, ADR-AUTO-TEST]
      - cell: pwsh/Catzc.Azure/tests
        by:
          - pwsh/Catzc.Azure/tests/Get-AzureBicepMinVersion.Tests.ps1
          - pwsh/Catzc.Azure/tests/Get-AzureCustomer.Tests.ps1
          - pwsh/Catzc.Azure/tests/Get-AzureCustomers.Tests.ps1
          - pwsh/Catzc.Azure/tests/Get-AzureEnvironment.Tests.ps1
          - pwsh/Catzc.Azure/tests/Get-AzureSubscription.Tests.ps1
          - pwsh/Catzc.Azure/tests/Get-AzureSubscriptionEnvironment.Tests.ps1
          - pwsh/Catzc.Azure/tests/Test-AzureNetworkPlan.Tests.ps1
          - ADR-AUTO-TEST
      - cell: pwsh/Catzc.Azure/tests/types
        by: [pwsh/Catzc.Azure/tests/types/AzureConfig.Tests.ps1, pwsh/Catzc.Azure/tests/types/NetworkConfig.Tests.ps1, ADR-AUTO-TEST]
      - cell: pwsh/Catzc.Azure.DevOps/.
        by: [pwsh/Catzc.Azure.DevOps/Test-Pipelines.ps1, ADR-AUTO-TEST]
      - cell: pwsh/Catzc.Azure.DevOps/configs
        by: [pwsh/Catzc.Azure.DevOps/configs/identity-tokens.yml, ADR-AUTO-TEST]
      - cell: pwsh/Catzc.Azure.DevOps/tests
        by:
          - pwsh/Catzc.Azure.DevOps/tests/Get-AdoYamlFiles.Tests.ps1
          - pwsh/Catzc.Azure.DevOps/tests/Test-Pipelines.Tests.ps1
          - ADR-AUTO-TEST
      - cell: pwsh/Catzc.Azure.DevOps.BuildValidation/tests/types
        by: [pwsh/Catzc.Azure.DevOps.BuildValidation/tests/types/BuildValidationConfig.Tests.ps1, ADR-AUTO-TEST]
      - cell: pwsh/Catzc.Azure.Templates/.
        by: [pwsh/Catzc.Azure.Templates/Get-BicepTemplatesOutputRoot.ps1, ADR-AUTO-TEST]
      - cell: pwsh/Catzc.Azure.Templates/tests
        by:
          - pwsh/Catzc.Azure.Templates/tests/Assert-BicepTemplate.Tests.ps1
          - pwsh/Catzc.Azure.Templates/tests/Build-Bicep.Integrity.Tests.ps1
          - pwsh/Catzc.Azure.Templates/tests/Build-Bicep.L2.Tests.ps1
          - pwsh/Catzc.Azure.Templates/tests/Build-Bicep.SampleCustomer.Tests.ps1
          - pwsh/Catzc.Azure.Templates/tests/Build-Bicep.SampleIndexed.Tests.ps1
          - pwsh/Catzc.Azure.Templates/tests/Build-Bicep.SampleSubscription.Tests.ps1
          - pwsh/Catzc.Azure.Templates/tests/Build-Bicep.SampleWithModule.Tests.ps1
          - pwsh/Catzc.Azure.Templates/tests/Build-Bicep.SampleWithPrepost.Tests.ps1
          - pwsh/Catzc.Azure.Templates/tests/Build-Bicep.Tests.ps1
          - pwsh/Catzc.Azure.Templates/tests/Deploy-Bicep.SampleSubscription.Tests.ps1
          - pwsh/Catzc.Azure.Templates/tests/Deploy-Bicep.Tests.ps1
          - pwsh/Catzc.Azure.Templates/tests/Get-BicepDeploymentContext.Tests.ps1
          - pwsh/Catzc.Azure.Templates/tests/Get-BicepParameterModel.Shipped.Tests.ps1
          - pwsh/Catzc.Azure.Templates/tests/Get-BicepParameterModel.Tests.ps1
          - pwsh/Catzc.Azure.Templates/tests/Get-BicepParameterViolations.Tests.ps1
          - pwsh/Catzc.Azure.Templates/tests/Get-BicepResourceGroupName.Tests.ps1
          - pwsh/Catzc.Azure.Templates/tests/Get-BicepResourceName.Tests.ps1
          - pwsh/Catzc.Azure.Templates/tests/Get-BicepTemplate.Tests.ps1
          - pwsh/Catzc.Azure.Templates/tests/Get-BicepTemplateConfiguration.Tests.ps1
          - pwsh/Catzc.Azure.Templates/tests/Get-BicepTemplateCustomers.Tests.ps1
          - pwsh/Catzc.Azure.Templates/tests/Get-BicepTemplateNames.Tests.ps1
          - pwsh/Catzc.Azure.Templates/tests/Get-BicepTemplateSlots.Tests.ps1
          - pwsh/Catzc.Azure.Templates/tests/Get-BicepTemplates.Tests.ps1
          - pwsh/Catzc.Azure.Templates/tests/Get-BicepTrackTagNameSet.Tests.ps1
          - pwsh/Catzc.Azure.Templates/tests/Resolve-BicepParameterAddresses.Tests.ps1
          - pwsh/Catzc.Azure.Templates/tests/Set-BicepTemplateConfiguration.Tests.ps1
          - ADR-AUTO-TEST
      - cell: pwsh/Catzc.Azure.Templates/tests/assets
        by: [pwsh/Catzc.Azure.Templates/tests/assets/Get-AzureResourceName.Content.yml, ADR-AUTO-TEST]
      - cell: pwsh/Catzc.Azure.Templates/tests/types
        by: [pwsh/Catzc.Azure.Templates/tests/types/BicepShortName.Tests.ps1, ADR-AUTO-TEST]
      - cell: pwsh/Catzc.Base.Config/tests
        by:
          - pwsh/Catzc.Base.Config/tests/Config-Conventions.Tests.ps1
          - pwsh/Catzc.Base.Config/tests/Get-Config.Tests.ps1
          - pwsh/Catzc.Base.Config/tests/Get-ConfigValue.Tests.ps1
          - ADR-AUTO-TEST
      - cell: pwsh/Catzc.Base.ConfigExtensions/.
        by: [pwsh/Catzc.Base.ConfigExtensions/Test-ConfigValidators.ps1, ADR-AUTO-TEST]
      - cell: pwsh/Catzc.Base.ConfigExtensions/tests
        by:
          - pwsh/Catzc.Base.ConfigExtensions/tests/Invoke-ConfigValidator.Tests.ps1
          - pwsh/Catzc.Base.ConfigExtensions/tests/Test-ConfigValidators.Tests.ps1
          - ADR-AUTO-TEST
      - cell: pwsh/Catzc.Base.Contracts/.
        by: [pwsh/Catzc.Base.Contracts/Test-Contracts.ps1, ADR-AUTO-TEST]
      - cell: pwsh/Catzc.Base.Contracts/tests
        by:
          - pwsh/Catzc.Base.Contracts/tests/Build-ContractReference.Tests.ps1
          - pwsh/Catzc.Base.Contracts/tests/ConvertTo-ContractNoteMarkdown.Tests.ps1
          - pwsh/Catzc.Base.Contracts/tests/Get-ContractAssetNote.Tests.ps1
          - pwsh/Catzc.Base.Contracts/tests/Get-ContractCheckResults.Assets.Tests.ps1
          - pwsh/Catzc.Base.Contracts/tests/Get-ContractFreezeFindings.Tests.ps1
          - pwsh/Catzc.Base.Contracts/tests/Publish-ContractRelease.Tests.ps1
          - pwsh/Catzc.Base.Contracts/tests/Test-Contracts.Tests.ps1
          - ADR-AUTO-TEST
      - cell: pwsh/Catzc.Base.Docs/.
        by:
          - pwsh/Catzc.Base.Docs/Test-AgentDefinitions.ps1
          - pwsh/Catzc.Base.Docs/Test-GeneratedReadmes.ps1
          - pwsh/Catzc.Base.Docs/Test-Glossary.ps1
          - ADR-AUTO-TEST
      - cell: pwsh/Catzc.Base.Docs/configs
        by: [pwsh/Catzc.Base.Docs/configs/agents.yml, pwsh/Catzc.Base.Docs/configs/capabilities.yml, ADR-AUTO-TEST]
      - cell: pwsh/Catzc.Base.Docs/private
        by: [pwsh/Catzc.Base.Docs/private/Get-GlossaryRuleStatements.ps1, ADR-AUTO-TEST]
      - cell: pwsh/Catzc.Base.Docs/tests
        by:
          - pwsh/Catzc.Base.Docs/tests/Build-Glossary.Tests.ps1
          - pwsh/Catzc.Base.Docs/tests/Get-AgentFrontMatter.Tests.ps1
          - pwsh/Catzc.Base.Docs/tests/Get-CatsRuleEnforcers.Tests.ps1
          - pwsh/Catzc.Base.Docs/tests/Get-ClaudeMdAgentNames.Tests.ps1
          - pwsh/Catzc.Base.Docs/tests/Get-Glossary.Tests.ps1
          - pwsh/Catzc.Base.Docs/tests/Get-GlossaryAnchorViolations.Tests.ps1
          - pwsh/Catzc.Base.Docs/tests/Get-GlossaryDefinitionViolations.Tests.ps1
          - pwsh/Catzc.Base.Docs/tests/Get-GlossaryEnforcementViolations.Tests.ps1
          - pwsh/Catzc.Base.Docs/tests/Get-GlossaryFormViolations.Tests.ps1
          - pwsh/Catzc.Base.Docs/tests/Get-GlossaryPhrasingViolations.Tests.ps1
          - pwsh/Catzc.Base.Docs/tests/Get-GlossaryRuleStatements.Tests.ps1
          - pwsh/Catzc.Base.Docs/tests/Get-GlossarySourceViolations.Tests.ps1
          - pwsh/Catzc.Base.Docs/tests/Get-GlossarySources.Tests.ps1
          - pwsh/Catzc.Base.Docs/tests/Test-AgentDefinitions.Tests.ps1
          - pwsh/Catzc.Base.Docs/tests/Test-GeneratedReadmes.Tests.ps1
          - pwsh/Catzc.Base.Docs/tests/Test-Glossary.Tests.ps1
          - ADR-AUTO-TEST
      - cell: pwsh/Catzc.Base.Docs/tests/assets/glossary/gadget
        by: [pwsh/Catzc.Base.Docs/tests/assets/glossary/gadget/glossary.yml, ADR-AUTO-TEST]
      - cell: pwsh/Catzc.Base.Docs/tests/assets/glossary/widget
        by: [pwsh/Catzc.Base.Docs/tests/assets/glossary/widget/glossary.yml, ADR-AUTO-TEST]
      - cell: pwsh/Catzc.Base.Docs/tests/types
        by:
          - pwsh/Catzc.Base.Docs/tests/types/AgentEntry.Tests.ps1
          - pwsh/Catzc.Base.Docs/tests/types/AgentsConfig.Tests.ps1
          - pwsh/Catzc.Base.Docs/tests/types/CapabilitiesConfig.Tests.ps1
          - pwsh/Catzc.Base.Docs/tests/types/GlossaryConfig.Tests.ps1
          - pwsh/Catzc.Base.Docs/tests/types/GlossaryEntry.Tests.ps1
          - ADR-AUTO-TEST
      - cell: pwsh/Catzc.Base.Docs/types
        by: [pwsh/Catzc.Base.Docs/types/GlossaryConcept.cs, ADR-AUTO-TEST]
      - cell: pwsh/Catzc.Base.Drs/.
        by: [pwsh/Catzc.Base.Drs/Test-DrsEngineNeutrality.ps1, pwsh/Catzc.Base.Drs/Test-DrsRegistry.ps1, ADR-AUTO-TEST]
      - cell: pwsh/Catzc.Base.Drs/configs
        by: [pwsh/Catzc.Base.Drs/configs/drs-checks.yml, pwsh/Catzc.Base.Drs/configs/drs.yml, ADR-AUTO-TEST, ADR-REPO-PROTGLOB]
      - cell: pwsh/Catzc.Base.Drs/tests
        by:
          - pwsh/Catzc.Base.Drs/tests/ConvertTo-DrsDomainDiagram.Tests.ps1
          - pwsh/Catzc.Base.Drs/tests/Get-DrsCitationGraphViolations.Tests.ps1
          - pwsh/Catzc.Base.Drs/tests/Get-DrsCitationMap.Tests.ps1
          - pwsh/Catzc.Base.Drs/tests/Get-DrsDomainEdges.Tests.ps1
          - pwsh/Catzc.Base.Drs/tests/Get-DrsDoraCoverageViolations.Tests.ps1
          - pwsh/Catzc.Base.Drs/tests/Get-DrsFileIndex.Tests.ps1
          - pwsh/Catzc.Base.Drs/tests/Get-DrsRuleSet.Tests.ps1
          - pwsh/Catzc.Base.Drs/tests/Get-DrsRuleSummaryLines.Tests.ps1
          - pwsh/Catzc.Base.Drs/tests/Resolve-DrsLinkTarget.Tests.ps1
          - pwsh/Catzc.Base.Drs/tests/Test-DrsEngineNeutrality.Tests.ps1
          - pwsh/Catzc.Base.Drs/tests/Test-DrsRegistry.Tests.ps1
          - pwsh/Catzc.Base.Drs/tests/Update-DrsCitation.Tests.ps1
          - ADR-AUTO-TEST
      - cell: pwsh/Catzc.Base.Drs/tests/types
        by:
          - pwsh/Catzc.Base.Drs/tests/types/DrsChecksConfig.Tests.ps1
          - pwsh/Catzc.Base.Drs/tests/types/DrsDomainEdge.Tests.ps1
          - ADR-AUTO-TEST
      - cell: pwsh/Catzc.Base.Drs/types
        by: [pwsh/Catzc.Base.Drs/types/DrsChecksConfig.cs, ADR-AUTO-TEST]
      - cell: pwsh/Catzc.Base.Engines/tests/assets/engine-cases
        by: [pwsh/Catzc.Base.Engines/tests/assets/engine-cases/engine-start.yml, ADR-AUTO-TEST]
      - cell: pwsh/Catzc.Base.Environment/tests
        by: [pwsh/Catzc.Base.Environment/tests/Set-PermanentEnvironmentVariable.Tests.ps1, ADR-AUTO-TEST]
      - cell: pwsh/Catzc.Base.Execution/.
        by: [pwsh/Catzc.Base.Execution/Invoke-Executable.ps1, ADR-AUTO-TEST]
      - cell: pwsh/Catzc.Base.Execution/tests
        by:
          - pwsh/Catzc.Base.Execution/tests/Find-Executable.Tests.ps1
          - pwsh/Catzc.Base.Execution/tests/Get-ExecutableVersion.Tests.ps1
          - pwsh/Catzc.Base.Execution/tests/Invoke-Executable.Tests.ps1
          - pwsh/Catzc.Base.Execution/tests/Resolve-EngineExecutable.Tests.ps1
          - pwsh/Catzc.Base.Execution/tests/Resolve-ToolExecutable.Tests.ps1
          - ADR-AUTO-TEST
      - cell: pwsh/Catzc.Base.Execution/tests/types
        by:
          - pwsh/Catzc.Base.Execution/tests/types/CliRunner.Tests.ps1
          - pwsh/Catzc.Base.Execution/tests/types/ExecutableProbe.Tests.ps1
          - pwsh/Catzc.Base.Execution/tests/types/ToolConfig.Tests.ps1
          - pwsh/Catzc.Base.Execution/tests/types/ToolsConfig.Tests.ps1
          - ADR-AUTO-TEST
      - cell: pwsh/Catzc.Base.Exporter/tests
        by:
          - pwsh/Catzc.Base.Exporter/tests/Assert-CatzcBundle.Tests.ps1
          - pwsh/Catzc.Base.Exporter/tests/Install-Catzc.Tests.ps1
          - pwsh/Catzc.Base.Exporter/tests/New-CatzcNuGetPackage.Tests.ps1
          - ADR-AUTO-TEST
      - cell: pwsh/Catzc.Base.Files/tests
        by: [pwsh/Catzc.Base.Files/tests/Get-GitChangedPath.Tests.ps1, ADR-AUTO-TEST]
      - cell: pwsh/Catzc.Base.Globs/.
        by:
          - pwsh/Catzc.Base.Globs/Clear-GlobSetProtection.ps1
          - pwsh/Catzc.Base.Globs/Get-MarkerBlastRadius.ps1
          - pwsh/Catzc.Base.Globs/Get-ModuleGlobSet.ps1
          - pwsh/Catzc.Base.Globs/Protect-GlobSet.ps1
          - pwsh/Catzc.Base.Globs/Test-AdoPipelineTriggerGlob.ps1
          - pwsh/Catzc.Base.Globs/Test-GitHubWorkflowTriggerGlob.ps1
          - pwsh/Catzc.Base.Globs/Test-GlobSetIndependence.ps1
          - pwsh/Catzc.Base.Globs/Test-GlobSetProtection.ps1
          - pwsh/Catzc.Base.Globs/Test-GlobSetTriggerCoverage.ps1
          - ADR-AUTO-TEST
          - ADR-REPO-PROTGLOB
      - cell: pwsh/Catzc.Base.Globs/configs
        by: [pwsh/Catzc.Base.Globs/configs/globs.yml, ADR-REPO-PROTGLOB]
      - cell: pwsh/Catzc.Base.Globs/tests
        by:
          - pwsh/Catzc.Base.Globs/tests/Get-ChangedGlobSet.Tests.ps1
          - pwsh/Catzc.Base.Globs/tests/Get-GlobSet.Tests.ps1
          - pwsh/Catzc.Base.Globs/tests/Get-ModuleGlobSet.Tests.ps1
          - pwsh/Catzc.Base.Globs/tests/GlobSetTrigger-Coverage.Tests.ps1
          - pwsh/Catzc.Base.Globs/tests/Test-AdoPipelineTriggerGlob.Tests.ps1
          - pwsh/Catzc.Base.Globs/tests/Test-GitHubWorkflowTriggerGlob.Tests.ps1
          - pwsh/Catzc.Base.Globs/tests/Test-GlobSetAffected.Tests.ps1
          - pwsh/Catzc.Base.Globs/tests/Test-GlobSetIndependence.Tests.ps1
          - pwsh/Catzc.Base.Globs/tests/Test-GlobSetProtection.Tests.ps1
          - pwsh/Catzc.Base.Globs/tests/Test-GlobSetTriggerCoverage.Tests.ps1
          - ADR-AUTO-TEST
          - ADR-REPO-PROTGLOB
      - cell: pwsh/Catzc.Base.Globs/tests/types
        by: [pwsh/Catzc.Base.Globs/tests/types/GlobsConfig.Tests.ps1, ADR-AUTO-TEST]
      - cell: pwsh/Catzc.Base.Globs/types
        by: [pwsh/Catzc.Base.Globs/types/GlobSet.cs, pwsh/Catzc.Base.Globs/types/GlobsConfig.cs, ADR-REPO-PROTGLOB]
      - cell: pwsh/Catzc.Base.Languages/tests
        by:
          - pwsh/Catzc.Base.Languages/tests/ConvertFrom-BatsJunit.Tests.ps1
          - pwsh/Catzc.Base.Languages/tests/ConvertFrom-PytestJunit.Tests.ps1
          - pwsh/Catzc.Base.Languages/tests/Get-EngineContract.Tests.ps1
          - pwsh/Catzc.Base.Languages/tests/Invoke-BashTest.Tests.ps1
          - pwsh/Catzc.Base.Languages/tests/Invoke-GoTest.Tests.ps1
          - pwsh/Catzc.Base.Languages/tests/Invoke-PythonTest.Tests.ps1
          - pwsh/Catzc.Base.Languages/tests/New-GoWorkspace.Tests.ps1
          - pwsh/Catzc.Base.Languages/tests/New-PythonProject.Tests.ps1
          - ADR-AUTO-TEST
      - cell: pwsh/Catzc.Base.Languages/types
        by:
          - pwsh/Catzc.Base.Languages/types/BashTestResult.cs
          - pwsh/Catzc.Base.Languages/types/GoTestResult.cs
          - pwsh/Catzc.Base.Languages/types/PythonTestResult.cs
          - ADR-AUTO-TEST
      - cell: pwsh/Catzc.Base.Maps/.
        by:
          - pwsh/Catzc.Base.Maps/Get-ValueChainHighlight.ps1
          - pwsh/Catzc.Base.Maps/Test-ValueChainMap.ps1
          - pwsh/Catzc.Base.Maps/Test-WorldMap.ps1
          - ADR-AUTO-TEST
      - cell: pwsh/Catzc.Base.Maps/tests
        by:
          - pwsh/Catzc.Base.Maps/tests/Get-ValueChainHighlight.Tests.ps1
          - pwsh/Catzc.Base.Maps/tests/Get-ValueChainMap.Tests.ps1
          - pwsh/Catzc.Base.Maps/tests/Test-ValueChainMap.Tests.ps1
          - pwsh/Catzc.Base.Maps/tests/Test-WorldMap.Tests.ps1
          - ADR-AUTO-TEST
      - cell: pwsh/Catzc.Base.Maps/tests/types
        by:
          - pwsh/Catzc.Base.Maps/tests/types/ValueChainHighlight.Tests.ps1
          - pwsh/Catzc.Base.Maps/tests/types/ValueChainMap.Tests.ps1
          - ADR-AUTO-TEST
      - cell: pwsh/Catzc.Base.Modules/tests
        by: [pwsh/Catzc.Base.Modules/tests/Get-CatzcModule.Tests.ps1, ADR-AUTO-TEST]
      - cell: pwsh/Catzc.Base.ModuleSystem/.
        by:
          - pwsh/Catzc.Base.ModuleSystem/Get-FunctionDependency.ps1
          - pwsh/Catzc.Base.ModuleSystem/Test-CheckedInBinaries.ps1
          - pwsh/Catzc.Base.ModuleSystem/Test-FolderConventions.ps1
          - pwsh/Catzc.Base.ModuleSystem/Test-FunctionDependency.ps1
          - pwsh/Catzc.Base.ModuleSystem/Test-InternalAssetDependency.ps1
          - pwsh/Catzc.Base.ModuleSystem/Test-ModuleCycles.ps1
          - pwsh/Catzc.Base.ModuleSystem/Test-ModuleDependency.ps1
          - ADR-AUTO-TEST
      - cell: pwsh/Catzc.Base.ModuleSystem/configs
        by: [pwsh/Catzc.Base.ModuleSystem/configs/artifacts.yml, ADR-AUTO-TEST]
      - cell: pwsh/Catzc.Base.ModuleSystem/private
        by: [pwsh/Catzc.Base.ModuleSystem/private/Get-UncoveredInternalAssetDependency.ps1, ADR-AUTO-TEST]
      - cell: pwsh/Catzc.Base.ModuleSystem/tests
        by:
          - pwsh/Catzc.Base.ModuleSystem/tests/Get-InternalAssetDependency.Integrity.Tests.ps1
          - pwsh/Catzc.Base.ModuleSystem/tests/Get-InternalAssetDependency.Tests.ps1
          - pwsh/Catzc.Base.ModuleSystem/tests/Get-UncoveredInternalAssetDependency.Tests.ps1
          - pwsh/Catzc.Base.ModuleSystem/tests/Test-CheckedInBinaries.Tests.ps1
          - pwsh/Catzc.Base.ModuleSystem/tests/Test-FolderConventions.Tests.ps1
          - pwsh/Catzc.Base.ModuleSystem/tests/Test-FunctionDependency.Tests.ps1
          - pwsh/Catzc.Base.ModuleSystem/tests/Test-InternalAssetDependency.Tests.ps1
          - pwsh/Catzc.Base.ModuleSystem/tests/Test-ModuleCycles.Tests.ps1
          - pwsh/Catzc.Base.ModuleSystem/tests/Test-ModuleDependency.Tests.ps1
          - ADR-AUTO-TEST
      - cell: pwsh/Catzc.Base.ModuleSystem/types
        by: [pwsh/Catzc.Base.ModuleSystem/types/ArtifactsConfig.cs, ADR-AUTO-TEST]
      - cell: pwsh/Catzc.Base.Objects/tests/types
        by:
          - pwsh/Catzc.Base.Objects/tests/types/ConsoleText.Tests.ps1
          - pwsh/Catzc.Base.Objects/tests/types/DictionaryRecord.Tests.ps1
          - ADR-AUTO-TEST
      - cell: pwsh/Catzc.Base.Overlay/tests
        by: [pwsh/Catzc.Base.Overlay/tests/Overlay.Fixture.ps1, ADR-AUTO-TEST]
      - cell: pwsh/Catzc.Base.QualityGates/.
        by:
          - pwsh/Catzc.Base.QualityGates/Get-TestTargetSkipReason.ps1
          - pwsh/Catzc.Base.QualityGates/Invoke-TestFile.ps1
          - pwsh/Catzc.Base.QualityGates/Test-AnalyzerDrsMap.ps1
          - pwsh/Catzc.Base.QualityGates/Test-Automation.ps1
          - pwsh/Catzc.Base.QualityGates/Test-BuildArtifact.ps1
          - pwsh/Catzc.Base.QualityGates/Test-CatzcBuild.ps1
          - pwsh/Catzc.Base.QualityGates/Test-Change.ps1
          - pwsh/Catzc.Base.QualityGates/Test-Comments.ps1
          - pwsh/Catzc.Base.QualityGates/Test-ConfigIdentityHygiene.ps1
          - pwsh/Catzc.Base.QualityGates/Test-FileMeta.ps1
          - pwsh/Catzc.Base.QualityGates/Test-FileMetaProcessors.ps1
          - pwsh/Catzc.Base.QualityGates/Test-Formatting.ps1
          - pwsh/Catzc.Base.QualityGates/Test-GeneratedFiles.ps1
          - pwsh/Catzc.Base.QualityGates/Test-Links.ps1
          - pwsh/Catzc.Base.QualityGates/Test-LogicTestIdentity.ps1
          - pwsh/Catzc.Base.QualityGates/Test-ManagedGuids.ps1
          - pwsh/Catzc.Base.QualityGates/Test-ManualTestPlan.ps1
          - pwsh/Catzc.Base.QualityGates/Test-MarkdownTitle.ps1
          - pwsh/Catzc.Base.QualityGates/Test-Markdownlint.ps1
          - pwsh/Catzc.Base.QualityGates/Test-ParameterConsistency.ps1
          - pwsh/Catzc.Base.QualityGates/Test-Plans.ps1
          - pwsh/Catzc.Base.QualityGates/Test-ScriptAnalyzer.ps1
          - pwsh/Catzc.Base.QualityGates/Test-ShippedConfigs.ps1
          - pwsh/Catzc.Base.QualityGates/Test-SourceConventions.ps1
          - pwsh/Catzc.Base.QualityGates/Test-Spelling.ps1
          - pwsh/Catzc.Base.QualityGates/Test-Terminology.ps1
          - pwsh/Catzc.Base.QualityGates/Test-TestTitles.ps1
          - ADR-AUTO-TEST
          - ADR-REPO-PROTGLOB
      - cell: pwsh/Catzc.Base.QualityGates/configs
        by:
          - pwsh/Catzc.Base.QualityGates/configs/analyzer-drs-map.yml
          - pwsh/Catzc.Base.QualityGates/configs/generated-files.yml
          - pwsh/Catzc.Base.QualityGates/configs/glossary.yml
          - pwsh/Catzc.Base.QualityGates/configs/source-conventions.yml
          - pwsh/Catzc.Base.QualityGates/configs/terminology.yml
          - pwsh/Catzc.Base.QualityGates/configs/test-policy.yml
          - ADR-AUTO-TEST
          - ADR-REPO-PROTGLOB
      - cell: pwsh/Catzc.Base.QualityGates/private
        by:
          - pwsh/Catzc.Base.QualityGates/private/Assert-TestTagGate.ps1
          - pwsh/Catzc.Base.QualityGates/private/Enter-SystemTestLock.ps1
          - pwsh/Catzc.Base.QualityGates/private/Enter-TestRunLocation.ps1
          - pwsh/Catzc.Base.QualityGates/private/Get-GeneratedFileGenerator.ps1
          - pwsh/Catzc.Base.QualityGates/private/Get-LanguageTestOutcomes.ps1
          - pwsh/Catzc.Base.QualityGates/private/Get-LiveIdentityTokens.ps1
          - pwsh/Catzc.Base.QualityGates/private/Get-LogicTestIdentityFinding.ps1
          - pwsh/Catzc.Base.QualityGates/private/Get-ModuleProtectionIdentity.ps1
          - pwsh/Catzc.Base.QualityGates/private/Get-NeutralCodeFinding.ps1
          - pwsh/Catzc.Base.QualityGates/private/Get-TestFileModule.ps1
          - pwsh/Catzc.Base.QualityGates/private/Get-TestOptOutExclusion.ps1
          - pwsh/Catzc.Base.QualityGates/private/Get-TestRunLocationEntry.ps1
          - pwsh/Catzc.Base.QualityGates/private/Invoke-BuildArtifactProbe.ps1
          - pwsh/Catzc.Base.QualityGates/private/Invoke-TestAutomationWorkers.ps1
          - pwsh/Catzc.Base.QualityGates/private/Invoke-TestRun.ps1
          - pwsh/Catzc.Base.QualityGates/private/New-PesterRunConfiguration.ps1
          - pwsh/Catzc.Base.QualityGates/private/New-TestAutomationShardScript.ps1
          - pwsh/Catzc.Base.QualityGates/private/Protect-TestedModule.ps1
          - pwsh/Catzc.Base.QualityGates/private/Resolve-TestRunMaxLevel.ps1
          - pwsh/Catzc.Base.QualityGates/private/Resolve-TestSuite.ps1
          - pwsh/Catzc.Base.QualityGates/private/Select-ProtectedTestFile.ps1
          - pwsh/Catzc.Base.QualityGates/private/Select-TestRunFiles.ps1
          - pwsh/Catzc.Base.QualityGates/private/Split-TestAutomationFiles.ps1
          - pwsh/Catzc.Base.QualityGates/private/Test-TestRunOverBudget.ps1
          - pwsh/Catzc.Base.QualityGates/private/Write-TestAutomationHeader.ps1
          - pwsh/Catzc.Base.QualityGates/private/Write-TestAutomationReport.ps1
          - pwsh/Catzc.Base.QualityGates/private/Write-TestOptOutExclusion.ps1
          - ADR-AUTO-TEST
          - ADR-REPO-PROTGLOB
      - cell: pwsh/Catzc.Base.QualityGates/tests
        by:
          - pwsh/Catzc.Base.QualityGates/tests/Assert-TestTagGate.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Build-EnglishDictionary.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/ConvertTo-PesterRunTarget.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Enter-SystemTestLock.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Format-Code.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Format-FileMeta.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Format-Links.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Format-MarkdownTitle.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Format-Types.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Get-AnalyzerDrsCoverage.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Get-BashTestCases.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Get-ChangeCheckPlan.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Get-ChangeTestFile.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Get-EngineSetFinding.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Get-FixtureIdentityTokens.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Get-FormatEngineStamp.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Get-FormatScope.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Get-GoTestCases.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Get-LanguageTestExecutable.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Get-LanguageTestFolders.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Get-LanguageTestOutcomes.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Get-LiveIdentityTokens.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Get-ModuleProtectionIdentity.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Get-NeutralCodeFinding.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Get-ParameterTypeConflict.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Get-PythonCheckScope.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Get-PythonTestCases.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Get-RepositoryGuids.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Get-TestAutomationTestPaths.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Get-TestBlockTag.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Get-TestExcludeTag.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Get-TestFileModule.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Get-TestOptOutExclusion.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Get-TestRuleTags.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Get-TestRunContext.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Get-TestRunFile.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Get-TestTagViolations.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Get-TestTargetSkipReason.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Invoke-BicepFormat.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Invoke-DotnetFormat.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Invoke-Gofmt.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Invoke-ImprintStep.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Invoke-Prettier.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Invoke-PythonWorkspaceTool.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Invoke-RuffFormat.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Invoke-TestFile.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Invoke-TestRun.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Language.Bridge.ps1
          - pwsh/Catzc.Base.QualityGates/tests/ManualTestPlan-Coverage.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Measure-QualityGates.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/New-TestAutomationShardScript.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/New-TestRunFinalManifest.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Resolve-TestSuite.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Save-TestDurationHistory.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Select-RuleTaggedFiles.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Select-TestShardAssignment.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Split-CachedFile.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Split-TestAutomationFiles.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Test-AnalyzerDrsMap.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Test-Automation.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Test-BuildArtifact.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Test-CatzcBuild.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Test-Change.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Test-ConfigIdentityHygiene.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Test-FileMetaProcessors.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Test-Formatting.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Test-GeneratedFiles.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Test-Links.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Test-Links.Untracked.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Test-LogicTestIdentity.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Test-ManagedGuids.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Test-ManualTestPlan.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Test-Markdownlint.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Test-ParameterConsistency.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Test-Plans.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Test-PythonLint.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Test-PythonTypes.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Test-ScriptAnalyzer.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Test-ShellScripts.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Test-ShippedConfigs.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Test-SourceConventions.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Test-Spelling.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Test-TestRunOverBudget.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Test-TestTitles.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/TestTitle-TemplateTokens.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Write-TestAutomationRuleCoverage.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Write-TestRunFailures.Tests.ps1
          - ADR-AUTO-TEST
          - ADR-REPO-PROTGLOB
      - cell: pwsh/Catzc.Base.QualityGates/tests/types
        by:
          - pwsh/Catzc.Base.QualityGates/tests/types/EngineSetCheck.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/types/SpellingOracle.Tests.ps1
          - ADR-AUTO-TEST
      - cell: pwsh/Catzc.Base.QualityGates/types
        by:
          - pwsh/Catzc.Base.QualityGates/types/IdentityTokenRule.cs
          - pwsh/Catzc.Base.QualityGates/types/SourceConventionsConfig.cs
          - pwsh/Catzc.Base.QualityGates/types/TestPolicyConfig.cs
          - ADR-AUTO-TEST
      - cell: pwsh/Catzc.Base.Reports/.
        by: [pwsh/Catzc.Base.Reports/Write-QualityGateReport.ps1, ADR-AUTO-TEST]
      - cell: pwsh/Catzc.Base.Reports/configs
        by: [pwsh/Catzc.Base.Reports/configs/reports.yml, ADR-AUTO-TEST]
      - cell: pwsh/Catzc.Base.Reports/tests
        by: [pwsh/Catzc.Base.Reports/tests/Write-QualityGateReport.Tests.ps1, ADR-AUTO-TEST]
      - cell: pwsh/Catzc.Base.Reports/tests/types
        by:
          - pwsh/Catzc.Base.Reports/tests/types/CheckModes.Tests.ps1
          - pwsh/Catzc.Base.Reports/tests/types/ReportsConfig.Tests.ps1
          - ADR-AUTO-TEST
      - cell: pwsh/Catzc.Base.Reports/types
        by: [pwsh/Catzc.Base.Reports/types/CheckMode.cs, pwsh/Catzc.Base.Reports/types/ReportsConfig.cs, ADR-AUTO-TEST]
      - cell: pwsh/Catzc.Base.Repository/tests
        by:
          - pwsh/Catzc.Base.Repository/tests/Get-RepositoryFile.Tests.ps1
          - pwsh/Catzc.Base.Repository/tests/Get-RepositoryFolder.Tests.ps1
          - ADR-AUTO-TEST
      - cell: pwsh/Catzc.Base.Repository/tests/types
        by:
          - pwsh/Catzc.Base.Repository/tests/types/ParsedScripts.Tests.ps1
          - pwsh/Catzc.Base.Repository/tests/types/SyntaxSearch.Tests.ps1
          - ADR-AUTO-TEST
      - cell: pwsh/Catzc.Base.RootConfig/.
        by: [pwsh/Catzc.Base.RootConfig/Test-RootAnalyzerSettings.ps1, pwsh/Catzc.Base.RootConfig/Test-RootConfigFiles.ps1, ADR-AUTO-TEST]
      - cell: pwsh/Catzc.Base.RootConfig/assets/root
        by: [pwsh/Catzc.Base.RootConfig/assets/root/.markdownlint.yml, ADR-AUTO-TEST]
      - cell: pwsh/Catzc.Base.RootConfig/tests
        by:
          - pwsh/Catzc.Base.RootConfig/tests/Build-RootConfig.Tests.ps1
          - pwsh/Catzc.Base.RootConfig/tests/Get-RootConfigRenderedFile.Tests.ps1
          - pwsh/Catzc.Base.RootConfig/tests/Test-RootAnalyzerSettings.Tests.ps1
          - pwsh/Catzc.Base.RootConfig/tests/Test-RootConfigFiles.Tests.ps1
          - pwsh/Catzc.Base.RootConfig/tests/Test-RootConfigIntegrity.Tests.ps1
          - ADR-AUTO-TEST
      - cell: pwsh/Catzc.Base.Timeouts/types
        by: [pwsh/Catzc.Base.Timeouts/types/TestTiers.cs, ADR-AUTO-TEST]
      - cell: pwsh/Catzc.Base.TypesSystem/.
        by: [pwsh/Catzc.Base.TypesSystem/Test-ShippedTypes.ps1, ADR-AUTO-TEST]
      - cell: pwsh/Catzc.Base.TypesSystem/tests
        by:
          - pwsh/Catzc.Base.TypesSystem/tests/Assert-LoadedTypesCurrent.Tests.ps1
          - pwsh/Catzc.Base.TypesSystem/tests/Test-ConsoleReadyType.Tests.ps1
          - pwsh/Catzc.Base.TypesSystem/tests/Test-LoadedTypesCurrent.Tests.ps1
          - pwsh/Catzc.Base.TypesSystem/tests/Test-ShippedTypes.Tests.ps1
          - ADR-AUTO-TEST
      - cell: pwsh/Catzc.Internal.Tests/.
        by:
          - pwsh/.internal/tests/Import-AllModules.Tests.ps1
          - pwsh/.internal/tests/New-BuiltCatzcRoot.Tests.ps1
          - pwsh/.internal/tests/Test-FolderConventions.Tests.ps1
          - ADR-AUTO-TEST
      - cell: pwsh/Catzc.Tooling.Core/.
        by: [pwsh/Catzc.Tooling.Core/Remove-SystemInstallation.ps1, ADR-AUTO-TEST]
      - cell: pwsh/Catzc.Tooling.Core/tests
        by:
          - pwsh/Catzc.Tooling.Core/tests/Assert-Tool.Tests.ps1
          - pwsh/Catzc.Tooling.Core/tests/Assert-ToolVersion.Tests.ps1
          - pwsh/Catzc.Tooling.Core/tests/Get-ToolConfig.Tests.ps1
          - pwsh/Catzc.Tooling.Core/tests/Get-ToolInstallOrder.Tests.ps1
          - pwsh/Catzc.Tooling.Core/tests/Remove-LinuxToolInstall.Tests.ps1
          - pwsh/Catzc.Tooling.Core/tests/Remove-MacToolInstall.Tests.ps1
          - pwsh/Catzc.Tooling.Core/tests/Remove-SystemInstallation.Tests.ps1
          - pwsh/Catzc.Tooling.Core/tests/Test-ExpectedPackageManager.Tests.ps1
          - pwsh/Catzc.Tooling.Core/tests/Test-ToolLocationManaged.Tests.ps1
          - pwsh/Catzc.Tooling.Core/tests/Write-ToolProbeReport.Tests.ps1
          - ADR-AUTO-TEST
      - cell: pwsh/Catzc.Tooling.Inspiration/tests
        by:
          - pwsh/Catzc.Tooling.Inspiration/tests/Get-Inspiration.Tests.ps1
          - pwsh/Catzc.Tooling.Inspiration/tests/Resolve-InspirationRoot.Tests.ps1
          - ADR-AUTO-TEST
      - cell: pwsh/Catzc.Tooling.Inspiration/tests/types
        by:
          - pwsh/Catzc.Tooling.Inspiration/tests/types/InspirationConfig.Tests.ps1
          - pwsh/Catzc.Tooling.Inspiration/tests/types/InspirationRoot.Tests.ps1
          - ADR-AUTO-TEST
      - cell: pwsh/Catzc.Tooling.KeyHandler/private
        by: [pwsh/Catzc.Tooling.KeyHandler/private/Select-SupportedKeyHandler.ps1, ADR-AUTO-TEST]
      - cell: pwsh/Catzc.Tooling.KeyHandler/tests
        by:
          - pwsh/Catzc.Tooling.KeyHandler/tests/Import-PSReadLineKeyHandlerSet.Tests.ps1
          - pwsh/Catzc.Tooling.KeyHandler/tests/Select-SupportedKeyHandler.Tests.ps1
          - ADR-AUTO-TEST
      - cell: pwsh/Catzc.Tooling.Provisioning/.
        by: [pwsh/Catzc.Tooling.Provisioning/Uninstall-Chocolatey.ps1, ADR-AUTO-TEST]
      - cell: pwsh/Catzc.Tooling.Provisioning/tests
        by:
          - pwsh/Catzc.Tooling.Provisioning/tests/Get-PackageTreePlan.Tests.ps1
          - pwsh/Catzc.Tooling.Provisioning/tests/Get-ToolsStatus.Tests.ps1
          - pwsh/Catzc.Tooling.Provisioning/tests/Get-ZshInstallLayout.Tests.ps1
          - pwsh/Catzc.Tooling.Provisioning/tests/Install-Zsh.Tests.ps1
          - pwsh/Catzc.Tooling.Provisioning/tests/Uninstall-Chocolatey.Tests.ps1
          - pwsh/Catzc.Tooling.Provisioning/tests/Uninstall-Zsh.Tests.ps1
          - ADR-AUTO-TEST
      - cell: pwsh/Catzc.Tooling.Python/tests
        by: [pwsh/Catzc.Tooling.Python/tests/Install-PipTool.Tests.ps1, ADR-AUTO-TEST]
      - cell: pwsh/Catzc.Tooling.Toolchain/tests
        by:
          - pwsh/Catzc.Tooling.Toolchain/tests/Install-BicepStandalone.Tests.ps1
          - pwsh/Catzc.Tooling.Toolchain/tests/Update-BatsVendor.Tests.ps1
          - ADR-AUTO-TEST
    module-neighbourhood:
      - cell: subject/.claude
        by:
          - .claude/CLAUDE.md
          - .claude/agents/test-optimization.md
          - .claude/skills/catzc-module/SKILL.md
          - .claude/skills/test-speed/SKILL.md
          - ADR-AUTO-TEST
      - cell: subject/Catzc.Azure
        by:
          - pwsh/Catzc.Azure/Test-AzureNetworkPlan.ps1
          - pwsh/Catzc.Azure/configs/identity-tokens.yml
          - pwsh/Catzc.Azure/tests/Get-AzureBicepMinVersion.Tests.ps1
          - pwsh/Catzc.Azure/tests/Get-AzureCustomer.Tests.ps1
          - pwsh/Catzc.Azure/tests/Get-AzureCustomers.Tests.ps1
          - pwsh/Catzc.Azure/tests/Get-AzureEnvironment.Tests.ps1
          - pwsh/Catzc.Azure/tests/Get-AzureSubscription.Tests.ps1
          - pwsh/Catzc.Azure/tests/Get-AzureSubscriptionEnvironment.Tests.ps1
          - pwsh/Catzc.Azure/tests/Test-AzureNetworkPlan.Tests.ps1
          - pwsh/Catzc.Azure/tests/types/AzureConfig.Tests.ps1
          - pwsh/Catzc.Azure/tests/types/NetworkConfig.Tests.ps1
          - ADR-AUTO-TEST
      - cell: subject/Catzc.Azure.DevOps
        by:
          - pwsh/Catzc.Azure.DevOps/Test-Pipelines.ps1
          - pwsh/Catzc.Azure.DevOps/configs/identity-tokens.yml
          - pwsh/Catzc.Azure.DevOps/tests/Get-AdoYamlFiles.Tests.ps1
          - pwsh/Catzc.Azure.DevOps/tests/Test-Pipelines.Tests.ps1
          - ADR-AUTO-TEST
      - cell: subject/Catzc.Azure.DevOps.BuildValidation
        by: [pwsh/Catzc.Azure.DevOps.BuildValidation/tests/types/BuildValidationConfig.Tests.ps1, ADR-AUTO-TEST]
      - cell: subject/Catzc.Azure.Templates
        by:
          - pwsh/Catzc.Azure.Templates/Get-BicepTemplatesOutputRoot.ps1
          - pwsh/Catzc.Azure.Templates/tests/Assert-BicepTemplate.Tests.ps1
          - pwsh/Catzc.Azure.Templates/tests/Build-Bicep.Integrity.Tests.ps1
          - pwsh/Catzc.Azure.Templates/tests/Build-Bicep.L2.Tests.ps1
          - pwsh/Catzc.Azure.Templates/tests/Build-Bicep.SampleCustomer.Tests.ps1
          - pwsh/Catzc.Azure.Templates/tests/Build-Bicep.SampleIndexed.Tests.ps1
          - pwsh/Catzc.Azure.Templates/tests/Build-Bicep.SampleSubscription.Tests.ps1
          - pwsh/Catzc.Azure.Templates/tests/Build-Bicep.SampleWithModule.Tests.ps1
          - pwsh/Catzc.Azure.Templates/tests/Build-Bicep.SampleWithPrepost.Tests.ps1
          - pwsh/Catzc.Azure.Templates/tests/Build-Bicep.Tests.ps1
          - pwsh/Catzc.Azure.Templates/tests/Deploy-Bicep.SampleSubscription.Tests.ps1
          - pwsh/Catzc.Azure.Templates/tests/Deploy-Bicep.Tests.ps1
          - pwsh/Catzc.Azure.Templates/tests/Get-BicepDeploymentContext.Tests.ps1
          - pwsh/Catzc.Azure.Templates/tests/Get-BicepParameterModel.Shipped.Tests.ps1
          - pwsh/Catzc.Azure.Templates/tests/Get-BicepParameterModel.Tests.ps1
          - pwsh/Catzc.Azure.Templates/tests/Get-BicepParameterViolations.Tests.ps1
          - pwsh/Catzc.Azure.Templates/tests/Get-BicepResourceGroupName.Tests.ps1
          - pwsh/Catzc.Azure.Templates/tests/Get-BicepResourceName.Tests.ps1
          - pwsh/Catzc.Azure.Templates/tests/Get-BicepTemplate.Tests.ps1
          - pwsh/Catzc.Azure.Templates/tests/Get-BicepTemplateConfiguration.Tests.ps1
          - pwsh/Catzc.Azure.Templates/tests/Get-BicepTemplateCustomers.Tests.ps1
          - pwsh/Catzc.Azure.Templates/tests/Get-BicepTemplateNames.Tests.ps1
          - pwsh/Catzc.Azure.Templates/tests/Get-BicepTemplateSlots.Tests.ps1
          - pwsh/Catzc.Azure.Templates/tests/Get-BicepTemplates.Tests.ps1
          - pwsh/Catzc.Azure.Templates/tests/Get-BicepTrackTagNameSet.Tests.ps1
          - pwsh/Catzc.Azure.Templates/tests/Resolve-BicepParameterAddresses.Tests.ps1
          - pwsh/Catzc.Azure.Templates/tests/Set-BicepTemplateConfiguration.Tests.ps1
          - pwsh/Catzc.Azure.Templates/tests/assets/Get-AzureResourceName.Content.yml
          - pwsh/Catzc.Azure.Templates/tests/types/BicepShortName.Tests.ps1
          - ADR-AUTO-TEST
      - cell: subject/Catzc.Base.Config
        by:
          - pwsh/Catzc.Base.Config/tests/Config-Conventions.Tests.ps1
          - pwsh/Catzc.Base.Config/tests/Get-Config.Tests.ps1
          - pwsh/Catzc.Base.Config/tests/Get-ConfigValue.Tests.ps1
          - ADR-AUTO-TEST
      - cell: subject/Catzc.Base.ConfigExtensions
        by:
          - pwsh/Catzc.Base.ConfigExtensions/Test-ConfigValidators.ps1
          - pwsh/Catzc.Base.ConfigExtensions/tests/Invoke-ConfigValidator.Tests.ps1
          - pwsh/Catzc.Base.ConfigExtensions/tests/Test-ConfigValidators.Tests.ps1
          - ADR-AUTO-TEST
      - cell: subject/Catzc.Base.Contracts
        by:
          - pwsh/Catzc.Base.Contracts/Test-Contracts.ps1
          - pwsh/Catzc.Base.Contracts/tests/Build-ContractReference.Tests.ps1
          - pwsh/Catzc.Base.Contracts/tests/ConvertTo-ContractNoteMarkdown.Tests.ps1
          - pwsh/Catzc.Base.Contracts/tests/Get-ContractAssetNote.Tests.ps1
          - pwsh/Catzc.Base.Contracts/tests/Get-ContractCheckResults.Assets.Tests.ps1
          - pwsh/Catzc.Base.Contracts/tests/Get-ContractFreezeFindings.Tests.ps1
          - pwsh/Catzc.Base.Contracts/tests/Publish-ContractRelease.Tests.ps1
          - pwsh/Catzc.Base.Contracts/tests/Test-Contracts.Tests.ps1
          - ADR-AUTO-TEST
      - cell: subject/Catzc.Base.Docs
        by:
          - pwsh/Catzc.Base.Docs/Test-AgentDefinitions.ps1
          - pwsh/Catzc.Base.Docs/Test-GeneratedReadmes.ps1
          - pwsh/Catzc.Base.Docs/Test-Glossary.ps1
          - pwsh/Catzc.Base.Docs/configs/agents.yml
          - pwsh/Catzc.Base.Docs/configs/capabilities.yml
          - pwsh/Catzc.Base.Docs/private/Get-GlossaryRuleStatements.ps1
          - pwsh/Catzc.Base.Docs/tests/Build-Glossary.Tests.ps1
          - pwsh/Catzc.Base.Docs/tests/Get-AgentFrontMatter.Tests.ps1
          - pwsh/Catzc.Base.Docs/tests/Get-CatsRuleEnforcers.Tests.ps1
          - pwsh/Catzc.Base.Docs/tests/Get-ClaudeMdAgentNames.Tests.ps1
          - pwsh/Catzc.Base.Docs/tests/Get-Glossary.Tests.ps1
          - pwsh/Catzc.Base.Docs/tests/Get-GlossaryAnchorViolations.Tests.ps1
          - pwsh/Catzc.Base.Docs/tests/Get-GlossaryDefinitionViolations.Tests.ps1
          - pwsh/Catzc.Base.Docs/tests/Get-GlossaryEnforcementViolations.Tests.ps1
          - pwsh/Catzc.Base.Docs/tests/Get-GlossaryFormViolations.Tests.ps1
          - pwsh/Catzc.Base.Docs/tests/Get-GlossaryPhrasingViolations.Tests.ps1
          - pwsh/Catzc.Base.Docs/tests/Get-GlossaryRuleStatements.Tests.ps1
          - pwsh/Catzc.Base.Docs/tests/Get-GlossarySourceViolations.Tests.ps1
          - pwsh/Catzc.Base.Docs/tests/Get-GlossarySources.Tests.ps1
          - pwsh/Catzc.Base.Docs/tests/Test-AgentDefinitions.Tests.ps1
          - pwsh/Catzc.Base.Docs/tests/Test-GeneratedReadmes.Tests.ps1
          - pwsh/Catzc.Base.Docs/tests/Test-Glossary.Tests.ps1
          - pwsh/Catzc.Base.Docs/tests/assets/glossary/gadget/glossary.yml
          - pwsh/Catzc.Base.Docs/tests/assets/glossary/widget/glossary.yml
          - pwsh/Catzc.Base.Docs/tests/types/AgentEntry.Tests.ps1
          - pwsh/Catzc.Base.Docs/tests/types/AgentsConfig.Tests.ps1
          - pwsh/Catzc.Base.Docs/tests/types/CapabilitiesConfig.Tests.ps1
          - pwsh/Catzc.Base.Docs/tests/types/GlossaryConfig.Tests.ps1
          - pwsh/Catzc.Base.Docs/tests/types/GlossaryEntry.Tests.ps1
          - pwsh/Catzc.Base.Docs/types/GlossaryConcept.cs
          - ADR-AUTO-TEST
      - cell: subject/Catzc.Base.Drs
        by:
          - pwsh/Catzc.Base.Drs/Test-DrsEngineNeutrality.ps1
          - pwsh/Catzc.Base.Drs/Test-DrsRegistry.ps1
          - pwsh/Catzc.Base.Drs/configs/drs-checks.yml
          - pwsh/Catzc.Base.Drs/configs/drs.yml
          - pwsh/Catzc.Base.Drs/tests/ConvertTo-DrsDomainDiagram.Tests.ps1
          - pwsh/Catzc.Base.Drs/tests/Get-DrsCitationGraphViolations.Tests.ps1
          - pwsh/Catzc.Base.Drs/tests/Get-DrsCitationMap.Tests.ps1
          - pwsh/Catzc.Base.Drs/tests/Get-DrsDomainEdges.Tests.ps1
          - pwsh/Catzc.Base.Drs/tests/Get-DrsDoraCoverageViolations.Tests.ps1
          - pwsh/Catzc.Base.Drs/tests/Get-DrsFileIndex.Tests.ps1
          - pwsh/Catzc.Base.Drs/tests/Get-DrsRuleSet.Tests.ps1
          - pwsh/Catzc.Base.Drs/tests/Get-DrsRuleSummaryLines.Tests.ps1
          - pwsh/Catzc.Base.Drs/tests/Resolve-DrsLinkTarget.Tests.ps1
          - pwsh/Catzc.Base.Drs/tests/Test-DrsEngineNeutrality.Tests.ps1
          - pwsh/Catzc.Base.Drs/tests/Test-DrsRegistry.Tests.ps1
          - pwsh/Catzc.Base.Drs/tests/Update-DrsCitation.Tests.ps1
          - pwsh/Catzc.Base.Drs/tests/types/DrsChecksConfig.Tests.ps1
          - pwsh/Catzc.Base.Drs/tests/types/DrsDomainEdge.Tests.ps1
          - pwsh/Catzc.Base.Drs/types/DrsChecksConfig.cs
          - ADR-AUTO-TEST
          - ADR-REPO-PROTGLOB
      - cell: subject/Catzc.Base.Engines
        by: [pwsh/Catzc.Base.Engines/tests/assets/engine-cases/engine-start.yml, ADR-AUTO-TEST]
      - cell: subject/Catzc.Base.Environment
        by: [pwsh/Catzc.Base.Environment/tests/Set-PermanentEnvironmentVariable.Tests.ps1, ADR-AUTO-TEST]
      - cell: subject/Catzc.Base.Execution
        by:
          - pwsh/Catzc.Base.Execution/Invoke-Executable.ps1
          - pwsh/Catzc.Base.Execution/tests/Find-Executable.Tests.ps1
          - pwsh/Catzc.Base.Execution/tests/Get-ExecutableVersion.Tests.ps1
          - pwsh/Catzc.Base.Execution/tests/Invoke-Executable.Tests.ps1
          - pwsh/Catzc.Base.Execution/tests/Resolve-EngineExecutable.Tests.ps1
          - pwsh/Catzc.Base.Execution/tests/Resolve-ToolExecutable.Tests.ps1
          - pwsh/Catzc.Base.Execution/tests/types/CliRunner.Tests.ps1
          - pwsh/Catzc.Base.Execution/tests/types/ExecutableProbe.Tests.ps1
          - pwsh/Catzc.Base.Execution/tests/types/ToolConfig.Tests.ps1
          - pwsh/Catzc.Base.Execution/tests/types/ToolsConfig.Tests.ps1
          - ADR-AUTO-TEST
      - cell: subject/Catzc.Base.Exporter
        by:
          - pwsh/Catzc.Base.Exporter/tests/Assert-CatzcBundle.Tests.ps1
          - pwsh/Catzc.Base.Exporter/tests/Install-Catzc.Tests.ps1
          - pwsh/Catzc.Base.Exporter/tests/New-CatzcNuGetPackage.Tests.ps1
          - ADR-AUTO-TEST
      - cell: subject/Catzc.Base.Files
        by: [pwsh/Catzc.Base.Files/tests/Get-GitChangedPath.Tests.ps1, ADR-AUTO-TEST]
      - cell: subject/Catzc.Base.Globs
        by:
          - pwsh/Catzc.Base.Globs/Clear-GlobSetProtection.ps1
          - pwsh/Catzc.Base.Globs/Get-MarkerBlastRadius.ps1
          - pwsh/Catzc.Base.Globs/Get-ModuleGlobSet.ps1
          - pwsh/Catzc.Base.Globs/Protect-GlobSet.ps1
          - pwsh/Catzc.Base.Globs/Test-AdoPipelineTriggerGlob.ps1
          - pwsh/Catzc.Base.Globs/Test-GitHubWorkflowTriggerGlob.ps1
          - pwsh/Catzc.Base.Globs/Test-GlobSetIndependence.ps1
          - pwsh/Catzc.Base.Globs/Test-GlobSetProtection.ps1
          - pwsh/Catzc.Base.Globs/Test-GlobSetTriggerCoverage.ps1
          - pwsh/Catzc.Base.Globs/configs/globs.yml
          - pwsh/Catzc.Base.Globs/tests/Get-ChangedGlobSet.Tests.ps1
          - pwsh/Catzc.Base.Globs/tests/Get-GlobSet.Tests.ps1
          - pwsh/Catzc.Base.Globs/tests/Get-ModuleGlobSet.Tests.ps1
          - pwsh/Catzc.Base.Globs/tests/GlobSetTrigger-Coverage.Tests.ps1
          - pwsh/Catzc.Base.Globs/tests/Test-AdoPipelineTriggerGlob.Tests.ps1
          - pwsh/Catzc.Base.Globs/tests/Test-GitHubWorkflowTriggerGlob.Tests.ps1
          - pwsh/Catzc.Base.Globs/tests/Test-GlobSetAffected.Tests.ps1
          - pwsh/Catzc.Base.Globs/tests/Test-GlobSetIndependence.Tests.ps1
          - pwsh/Catzc.Base.Globs/tests/Test-GlobSetProtection.Tests.ps1
          - pwsh/Catzc.Base.Globs/tests/Test-GlobSetTriggerCoverage.Tests.ps1
          - pwsh/Catzc.Base.Globs/tests/types/GlobsConfig.Tests.ps1
          - pwsh/Catzc.Base.Globs/types/GlobSet.cs
          - pwsh/Catzc.Base.Globs/types/GlobsConfig.cs
          - ADR-AUTO-TEST
          - ADR-REPO-PROTGLOB
      - cell: subject/Catzc.Base.Languages
        by:
          - pwsh/Catzc.Base.Languages/tests/ConvertFrom-BatsJunit.Tests.ps1
          - pwsh/Catzc.Base.Languages/tests/ConvertFrom-PytestJunit.Tests.ps1
          - pwsh/Catzc.Base.Languages/tests/Get-EngineContract.Tests.ps1
          - pwsh/Catzc.Base.Languages/tests/Invoke-BashTest.Tests.ps1
          - pwsh/Catzc.Base.Languages/tests/Invoke-GoTest.Tests.ps1
          - pwsh/Catzc.Base.Languages/tests/Invoke-PythonTest.Tests.ps1
          - pwsh/Catzc.Base.Languages/tests/New-GoWorkspace.Tests.ps1
          - pwsh/Catzc.Base.Languages/tests/New-PythonProject.Tests.ps1
          - pwsh/Catzc.Base.Languages/types/BashTestResult.cs
          - pwsh/Catzc.Base.Languages/types/GoTestResult.cs
          - pwsh/Catzc.Base.Languages/types/PythonTestResult.cs
          - ADR-AUTO-TEST
      - cell: subject/Catzc.Base.Maps
        by:
          - pwsh/Catzc.Base.Maps/Get-ValueChainHighlight.ps1
          - pwsh/Catzc.Base.Maps/Test-ValueChainMap.ps1
          - pwsh/Catzc.Base.Maps/Test-WorldMap.ps1
          - pwsh/Catzc.Base.Maps/tests/Get-ValueChainHighlight.Tests.ps1
          - pwsh/Catzc.Base.Maps/tests/Get-ValueChainMap.Tests.ps1
          - pwsh/Catzc.Base.Maps/tests/Test-ValueChainMap.Tests.ps1
          - pwsh/Catzc.Base.Maps/tests/Test-WorldMap.Tests.ps1
          - pwsh/Catzc.Base.Maps/tests/types/ValueChainHighlight.Tests.ps1
          - pwsh/Catzc.Base.Maps/tests/types/ValueChainMap.Tests.ps1
          - ADR-AUTO-TEST
      - cell: subject/Catzc.Base.ModuleSystem
        by:
          - pwsh/Catzc.Base.ModuleSystem/Get-FunctionDependency.ps1
          - pwsh/Catzc.Base.ModuleSystem/Test-CheckedInBinaries.ps1
          - pwsh/Catzc.Base.ModuleSystem/Test-FolderConventions.ps1
          - pwsh/Catzc.Base.ModuleSystem/Test-FunctionDependency.ps1
          - pwsh/Catzc.Base.ModuleSystem/Test-InternalAssetDependency.ps1
          - pwsh/Catzc.Base.ModuleSystem/Test-ModuleCycles.ps1
          - pwsh/Catzc.Base.ModuleSystem/Test-ModuleDependency.ps1
          - pwsh/Catzc.Base.ModuleSystem/configs/artifacts.yml
          - pwsh/Catzc.Base.ModuleSystem/private/Get-UncoveredInternalAssetDependency.ps1
          - pwsh/Catzc.Base.ModuleSystem/tests/Get-InternalAssetDependency.Integrity.Tests.ps1
          - pwsh/Catzc.Base.ModuleSystem/tests/Get-InternalAssetDependency.Tests.ps1
          - pwsh/Catzc.Base.ModuleSystem/tests/Get-UncoveredInternalAssetDependency.Tests.ps1
          - pwsh/Catzc.Base.ModuleSystem/tests/Test-CheckedInBinaries.Tests.ps1
          - pwsh/Catzc.Base.ModuleSystem/tests/Test-FolderConventions.Tests.ps1
          - pwsh/Catzc.Base.ModuleSystem/tests/Test-FunctionDependency.Tests.ps1
          - pwsh/Catzc.Base.ModuleSystem/tests/Test-InternalAssetDependency.Tests.ps1
          - pwsh/Catzc.Base.ModuleSystem/tests/Test-ModuleCycles.Tests.ps1
          - pwsh/Catzc.Base.ModuleSystem/tests/Test-ModuleDependency.Tests.ps1
          - pwsh/Catzc.Base.ModuleSystem/types/ArtifactsConfig.cs
          - ADR-AUTO-TEST
      - cell: subject/Catzc.Base.Modules
        by: [pwsh/Catzc.Base.Modules/tests/Get-CatzcModule.Tests.ps1, ADR-AUTO-TEST]
      - cell: subject/Catzc.Base.Objects
        by:
          - pwsh/Catzc.Base.Objects/tests/types/ConsoleText.Tests.ps1
          - pwsh/Catzc.Base.Objects/tests/types/DictionaryRecord.Tests.ps1
          - ADR-AUTO-TEST
      - cell: subject/Catzc.Base.Overlay
        by: [pwsh/Catzc.Base.Overlay/tests/Overlay.Fixture.ps1, ADR-AUTO-TEST]
      - cell: subject/Catzc.Base.QualityGates
        by:
          - pwsh/Catzc.Base.QualityGates/Get-TestTargetSkipReason.ps1
          - pwsh/Catzc.Base.QualityGates/Invoke-TestFile.ps1
          - pwsh/Catzc.Base.QualityGates/Test-AnalyzerDrsMap.ps1
          - pwsh/Catzc.Base.QualityGates/Test-Automation.ps1
          - pwsh/Catzc.Base.QualityGates/Test-BuildArtifact.ps1
          - pwsh/Catzc.Base.QualityGates/Test-CatzcBuild.ps1
          - pwsh/Catzc.Base.QualityGates/Test-Change.ps1
          - pwsh/Catzc.Base.QualityGates/Test-Comments.ps1
          - pwsh/Catzc.Base.QualityGates/Test-ConfigIdentityHygiene.ps1
          - pwsh/Catzc.Base.QualityGates/Test-FileMeta.ps1
          - pwsh/Catzc.Base.QualityGates/Test-FileMetaProcessors.ps1
          - pwsh/Catzc.Base.QualityGates/Test-Formatting.ps1
          - pwsh/Catzc.Base.QualityGates/Test-GeneratedFiles.ps1
          - pwsh/Catzc.Base.QualityGates/Test-Links.ps1
          - pwsh/Catzc.Base.QualityGates/Test-LogicTestIdentity.ps1
          - pwsh/Catzc.Base.QualityGates/Test-ManagedGuids.ps1
          - pwsh/Catzc.Base.QualityGates/Test-ManualTestPlan.ps1
          - pwsh/Catzc.Base.QualityGates/Test-MarkdownTitle.ps1
          - pwsh/Catzc.Base.QualityGates/Test-Markdownlint.ps1
          - pwsh/Catzc.Base.QualityGates/Test-ParameterConsistency.ps1
          - pwsh/Catzc.Base.QualityGates/Test-Plans.ps1
          - pwsh/Catzc.Base.QualityGates/Test-ScriptAnalyzer.ps1
          - pwsh/Catzc.Base.QualityGates/Test-ShippedConfigs.ps1
          - pwsh/Catzc.Base.QualityGates/Test-SourceConventions.ps1
          - pwsh/Catzc.Base.QualityGates/Test-Spelling.ps1
          - pwsh/Catzc.Base.QualityGates/Test-Terminology.ps1
          - pwsh/Catzc.Base.QualityGates/Test-TestTitles.ps1
          - pwsh/Catzc.Base.QualityGates/configs/analyzer-drs-map.yml
          - pwsh/Catzc.Base.QualityGates/configs/generated-files.yml
          - pwsh/Catzc.Base.QualityGates/configs/glossary.yml
          - pwsh/Catzc.Base.QualityGates/configs/source-conventions.yml
          - pwsh/Catzc.Base.QualityGates/configs/terminology.yml
          - pwsh/Catzc.Base.QualityGates/configs/test-policy.yml
          - pwsh/Catzc.Base.QualityGates/private/Assert-TestTagGate.ps1
          - pwsh/Catzc.Base.QualityGates/private/Enter-SystemTestLock.ps1
          - pwsh/Catzc.Base.QualityGates/private/Enter-TestRunLocation.ps1
          - pwsh/Catzc.Base.QualityGates/private/Get-GeneratedFileGenerator.ps1
          - pwsh/Catzc.Base.QualityGates/private/Get-LanguageTestOutcomes.ps1
          - pwsh/Catzc.Base.QualityGates/private/Get-LiveIdentityTokens.ps1
          - pwsh/Catzc.Base.QualityGates/private/Get-LogicTestIdentityFinding.ps1
          - pwsh/Catzc.Base.QualityGates/private/Get-ModuleProtectionIdentity.ps1
          - pwsh/Catzc.Base.QualityGates/private/Get-NeutralCodeFinding.ps1
          - pwsh/Catzc.Base.QualityGates/private/Get-TestFileModule.ps1
          - pwsh/Catzc.Base.QualityGates/private/Get-TestOptOutExclusion.ps1
          - pwsh/Catzc.Base.QualityGates/private/Get-TestRunLocationEntry.ps1
          - pwsh/Catzc.Base.QualityGates/private/Invoke-BuildArtifactProbe.ps1
          - pwsh/Catzc.Base.QualityGates/private/Invoke-TestAutomationWorkers.ps1
          - pwsh/Catzc.Base.QualityGates/private/Invoke-TestRun.ps1
          - pwsh/Catzc.Base.QualityGates/private/New-PesterRunConfiguration.ps1
          - pwsh/Catzc.Base.QualityGates/private/New-TestAutomationShardScript.ps1
          - pwsh/Catzc.Base.QualityGates/private/Protect-TestedModule.ps1
          - pwsh/Catzc.Base.QualityGates/private/Resolve-TestRunMaxLevel.ps1
          - pwsh/Catzc.Base.QualityGates/private/Resolve-TestSuite.ps1
          - pwsh/Catzc.Base.QualityGates/private/Select-ProtectedTestFile.ps1
          - pwsh/Catzc.Base.QualityGates/private/Select-TestRunFiles.ps1
          - pwsh/Catzc.Base.QualityGates/private/Split-TestAutomationFiles.ps1
          - pwsh/Catzc.Base.QualityGates/private/Test-TestRunOverBudget.ps1
          - pwsh/Catzc.Base.QualityGates/private/Write-TestAutomationHeader.ps1
          - pwsh/Catzc.Base.QualityGates/private/Write-TestAutomationReport.ps1
          - pwsh/Catzc.Base.QualityGates/private/Write-TestOptOutExclusion.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Assert-TestTagGate.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Build-EnglishDictionary.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/ConvertTo-PesterRunTarget.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Enter-SystemTestLock.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Format-Code.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Format-FileMeta.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Format-Links.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Format-MarkdownTitle.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Format-Types.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Get-AnalyzerDrsCoverage.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Get-BashTestCases.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Get-ChangeCheckPlan.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Get-ChangeTestFile.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Get-EngineSetFinding.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Get-FixtureIdentityTokens.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Get-FormatEngineStamp.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Get-FormatScope.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Get-GoTestCases.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Get-LanguageTestExecutable.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Get-LanguageTestFolders.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Get-LanguageTestOutcomes.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Get-LiveIdentityTokens.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Get-ModuleProtectionIdentity.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Get-NeutralCodeFinding.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Get-ParameterTypeConflict.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Get-PythonCheckScope.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Get-PythonTestCases.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Get-RepositoryGuids.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Get-TestAutomationTestPaths.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Get-TestBlockTag.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Get-TestExcludeTag.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Get-TestFileModule.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Get-TestOptOutExclusion.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Get-TestRuleTags.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Get-TestRunContext.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Get-TestRunFile.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Get-TestTagViolations.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Get-TestTargetSkipReason.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Invoke-BicepFormat.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Invoke-DotnetFormat.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Invoke-Gofmt.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Invoke-ImprintStep.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Invoke-Prettier.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Invoke-PythonWorkspaceTool.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Invoke-RuffFormat.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Invoke-TestFile.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Invoke-TestRun.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Language.Bridge.ps1
          - pwsh/Catzc.Base.QualityGates/tests/ManualTestPlan-Coverage.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Measure-QualityGates.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/New-TestAutomationShardScript.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/New-TestRunFinalManifest.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Resolve-TestSuite.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Save-TestDurationHistory.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Select-RuleTaggedFiles.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Select-TestShardAssignment.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Split-CachedFile.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Split-TestAutomationFiles.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Test-AnalyzerDrsMap.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Test-Automation.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Test-BuildArtifact.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Test-CatzcBuild.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Test-Change.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Test-ConfigIdentityHygiene.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Test-FileMetaProcessors.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Test-Formatting.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Test-GeneratedFiles.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Test-Links.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Test-Links.Untracked.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Test-LogicTestIdentity.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Test-ManagedGuids.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Test-ManualTestPlan.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Test-Markdownlint.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Test-ParameterConsistency.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Test-Plans.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Test-PythonLint.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Test-PythonTypes.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Test-ScriptAnalyzer.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Test-ShellScripts.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Test-ShippedConfigs.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Test-SourceConventions.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Test-Spelling.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Test-TestRunOverBudget.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Test-TestTitles.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/TestTitle-TemplateTokens.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Write-TestAutomationRuleCoverage.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/Write-TestRunFailures.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/types/EngineSetCheck.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/tests/types/SpellingOracle.Tests.ps1
          - pwsh/Catzc.Base.QualityGates/types/IdentityTokenRule.cs
          - pwsh/Catzc.Base.QualityGates/types/SourceConventionsConfig.cs
          - pwsh/Catzc.Base.QualityGates/types/TestPolicyConfig.cs
          - ADR-AUTO-TEST
          - ADR-REPO-PROTGLOB
      - cell: subject/Catzc.Base.Reports
        by:
          - pwsh/Catzc.Base.Reports/Write-QualityGateReport.ps1
          - pwsh/Catzc.Base.Reports/configs/reports.yml
          - pwsh/Catzc.Base.Reports/tests/Write-QualityGateReport.Tests.ps1
          - pwsh/Catzc.Base.Reports/tests/types/CheckModes.Tests.ps1
          - pwsh/Catzc.Base.Reports/tests/types/ReportsConfig.Tests.ps1
          - pwsh/Catzc.Base.Reports/types/CheckMode.cs
          - pwsh/Catzc.Base.Reports/types/ReportsConfig.cs
          - ADR-AUTO-TEST
      - cell: subject/Catzc.Base.Repository
        by:
          - pwsh/Catzc.Base.Repository/tests/Get-RepositoryFile.Tests.ps1
          - pwsh/Catzc.Base.Repository/tests/Get-RepositoryFolder.Tests.ps1
          - pwsh/Catzc.Base.Repository/tests/types/ParsedScripts.Tests.ps1
          - pwsh/Catzc.Base.Repository/tests/types/SyntaxSearch.Tests.ps1
          - ADR-AUTO-TEST
      - cell: subject/Catzc.Base.RootConfig
        by:
          - pwsh/Catzc.Base.RootConfig/Test-RootAnalyzerSettings.ps1
          - pwsh/Catzc.Base.RootConfig/Test-RootConfigFiles.ps1
          - pwsh/Catzc.Base.RootConfig/assets/root/.markdownlint.yml
          - pwsh/Catzc.Base.RootConfig/tests/Build-RootConfig.Tests.ps1
          - pwsh/Catzc.Base.RootConfig/tests/Get-RootConfigRenderedFile.Tests.ps1
          - pwsh/Catzc.Base.RootConfig/tests/Test-RootAnalyzerSettings.Tests.ps1
          - pwsh/Catzc.Base.RootConfig/tests/Test-RootConfigFiles.Tests.ps1
          - pwsh/Catzc.Base.RootConfig/tests/Test-RootConfigIntegrity.Tests.ps1
          - ADR-AUTO-TEST
      - cell: subject/Catzc.Base.Timeouts
        by: [pwsh/Catzc.Base.Timeouts/types/TestTiers.cs, ADR-AUTO-TEST]
      - cell: subject/Catzc.Base.TypesSystem
        by:
          - pwsh/Catzc.Base.TypesSystem/Test-ShippedTypes.ps1
          - pwsh/Catzc.Base.TypesSystem/tests/Assert-LoadedTypesCurrent.Tests.ps1
          - pwsh/Catzc.Base.TypesSystem/tests/Test-ConsoleReadyType.Tests.ps1
          - pwsh/Catzc.Base.TypesSystem/tests/Test-LoadedTypesCurrent.Tests.ps1
          - pwsh/Catzc.Base.TypesSystem/tests/Test-ShippedTypes.Tests.ps1
          - ADR-AUTO-TEST
      - cell: subject/Catzc.Internal.Tests
        by:
          - pwsh/.internal/tests/Import-AllModules.Tests.ps1
          - pwsh/.internal/tests/New-BuiltCatzcRoot.Tests.ps1
          - pwsh/.internal/tests/Test-FolderConventions.Tests.ps1
          - ADR-AUTO-TEST
      - cell: subject/Catzc.Tooling.Core
        by:
          - pwsh/Catzc.Tooling.Core/Remove-SystemInstallation.ps1
          - pwsh/Catzc.Tooling.Core/tests/Assert-Tool.Tests.ps1
          - pwsh/Catzc.Tooling.Core/tests/Assert-ToolVersion.Tests.ps1
          - pwsh/Catzc.Tooling.Core/tests/Get-ToolConfig.Tests.ps1
          - pwsh/Catzc.Tooling.Core/tests/Get-ToolInstallOrder.Tests.ps1
          - pwsh/Catzc.Tooling.Core/tests/Remove-LinuxToolInstall.Tests.ps1
          - pwsh/Catzc.Tooling.Core/tests/Remove-MacToolInstall.Tests.ps1
          - pwsh/Catzc.Tooling.Core/tests/Remove-SystemInstallation.Tests.ps1
          - pwsh/Catzc.Tooling.Core/tests/Test-ExpectedPackageManager.Tests.ps1
          - pwsh/Catzc.Tooling.Core/tests/Test-ToolLocationManaged.Tests.ps1
          - pwsh/Catzc.Tooling.Core/tests/Write-ToolProbeReport.Tests.ps1
          - ADR-AUTO-TEST
      - cell: subject/Catzc.Tooling.Inspiration
        by:
          - pwsh/Catzc.Tooling.Inspiration/tests/Get-Inspiration.Tests.ps1
          - pwsh/Catzc.Tooling.Inspiration/tests/Resolve-InspirationRoot.Tests.ps1
          - pwsh/Catzc.Tooling.Inspiration/tests/types/InspirationConfig.Tests.ps1
          - pwsh/Catzc.Tooling.Inspiration/tests/types/InspirationRoot.Tests.ps1
          - ADR-AUTO-TEST
      - cell: subject/Catzc.Tooling.KeyHandler
        by:
          - pwsh/Catzc.Tooling.KeyHandler/private/Select-SupportedKeyHandler.ps1
          - pwsh/Catzc.Tooling.KeyHandler/tests/Import-PSReadLineKeyHandlerSet.Tests.ps1
          - pwsh/Catzc.Tooling.KeyHandler/tests/Select-SupportedKeyHandler.Tests.ps1
          - ADR-AUTO-TEST
      - cell: subject/Catzc.Tooling.Provisioning
        by:
          - pwsh/Catzc.Tooling.Provisioning/Uninstall-Chocolatey.ps1
          - pwsh/Catzc.Tooling.Provisioning/tests/Get-PackageTreePlan.Tests.ps1
          - pwsh/Catzc.Tooling.Provisioning/tests/Get-ToolsStatus.Tests.ps1
          - pwsh/Catzc.Tooling.Provisioning/tests/Get-ZshInstallLayout.Tests.ps1
          - pwsh/Catzc.Tooling.Provisioning/tests/Install-Zsh.Tests.ps1
          - pwsh/Catzc.Tooling.Provisioning/tests/Uninstall-Chocolatey.Tests.ps1
          - pwsh/Catzc.Tooling.Provisioning/tests/Uninstall-Zsh.Tests.ps1
          - ADR-AUTO-TEST
      - cell: subject/Catzc.Tooling.Python
        by: [pwsh/Catzc.Tooling.Python/tests/Install-PipTool.Tests.ps1, ADR-AUTO-TEST]
      - cell: subject/Catzc.Tooling.Toolchain
        by:
          - pwsh/Catzc.Tooling.Toolchain/tests/Install-BicepStandalone.Tests.ps1
          - pwsh/Catzc.Tooling.Toolchain/tests/Update-BatsVendor.Tests.ps1
          - ADR-AUTO-TEST
      - cell: subject/pipelines
        by: [.ado/pipelines/ci-infrastructure.yaml, .ado/pipelines/ci-pwsh.yaml, ADR-AUTO-TEST]
    axis:
      - cell: AUTO/quality-control
        by: [ADR-AUTO-TEST]
      - cell: AUTO/*
        by: [ADR-REPO-PROTGLOB]
layout:
  band-entry: { x: 20, y: 84, w: 200, h: 140 }
  band-before: { x: 230, y: 84, w: 1050, h: 140 }
  band-try: { x: 20, y: 248, w: 1260, h: 140 }
  band-finally: { x: 20, y: 408, w: 1260, h: 96 }
  g-automation: { x: 30, y: 114, w: 150, h: 40 }
  g-build: { x: 30, y: 166, w: 150, h: 40 }
  g-run: { x: 290, y: 136, w: 140, h: 36 }
  g-discovery: { x: 500, y: 136, w: 150, h: 36 }
  g-tag-gate: { x: 722, y: 111, w: 196, h: 86 }
  g-split: { x: 130, y: 286, w: 190, h: 36 }
  s-parallel: { x: 130, y: 340, w: 64, h: 28 }
  s-greedy: { x: 198, y: 340, w: 64, h: 28 }
  s-serial: { x: 266, y: 340, w: 64, h: 28 }
  g-select: { x: 380, y: 286, w: 185, h: 36 }
  g-workers: { x: 625, y: 286, w: 215, h: 36 }
  g-verdict: { x: 900, y: 286, w: 195, h: 36 }
  f-run-json: { x: 130, y: 434, w: 110, h: 52 }
```

![One discovery feeds three phases; finally stamps run.json](.assets/test-automation-one-run-pipeline.drawio.png)

## Division

The module's public functions and configuration files, sorted into the responsibilities above.

| Responsibility                                  | Function                      |
| ----------------------------------------------- | ----------------------------- |
| responsibility:1 — Test runner                  | `Test-Automation`             |
|                                                 | `Invoke-TestFile`             |
|                                                 | `Test-CatzcBuild`             |
|                                                 | `Test-InIsolation`            |
|                                                 | `Get-TestTargetSkipReason`    |
|                                                 | `Test-Change`                 |
| config                                          | `test-policy.yml`             |
| responsibility:2 — Repository quality gates     | `Test-GeneratedFiles`         |
|                                                 | `Test-Formatting`             |
|                                                 | `Test-BclReferences`          |
|                                                 | `Test-BuildArtifact`          |
|                                                 | `Test-ShippedConfigs`         |
|                                                 | `Test-SourceConventions`      |
|                                                 | `Test-TestTitles`             |
|                                                 | `Test-ManualTestPlan`         |
|                                                 | `Test-AnalyzerDrsMap`         |
|                                                 | `Test-ScriptAnalyzer`         |
|                                                 | `Test-Parsing`                |
|                                                 | `Test-LogicTestIdentity`      |
|                                                 | `Test-ConfigIdentityHygiene`  |
|                                                 | `Test-ParameterConsistency`   |
|                                                 | `Test-Plans`                  |
|                                                 | `New-Plan`                    |
|                                                 | `Get-DrsUsage`                |
|                                                 | `Measure-QualityGates`        |
| config                                          | `analyzer-drs-map.yml`        |
|                                                 | `generated-files.yml`         |
|                                                 | `source-conventions.yml`      |
|                                                 | `parameter-consistency.yml`   |
|                                                 | `plans.yml`                   |
|                                                 | `edit-reminders.yml`          |
| responsibility:3 — Document and code formatting | `Test-Spelling`               |
|                                                 | `Export-SpellingTriage`       |
|                                                 | `Test-Markdownlint`           |
|                                                 | `Format-Code`                 |
|                                                 | `Format-MarkdownTitle`        |
|                                                 | `Test-MarkdownTitle`          |
|                                                 | `Format-FileMeta`             |
|                                                 | `Get-FileMetaFact`            |
|                                                 | `Sync-FileMeta`               |
|                                                 | `Test-FileMeta`               |
|                                                 | `Test-FileMetaProcessors`     |
|                                                 | `Format-Types`                |
|                                                 | `Test-PythonLint`             |
|                                                 | `Test-PythonTypes`            |
|                                                 | `Test-ShellScripts`           |
|                                                 | `Test-IdiomaticNames`         |
|                                                 | `Assert-IdiomaticNames`       |
|                                                 | `Repair-IdiomaticNames`       |
|                                                 | `Format-Links`                |
|                                                 | `Test-Links`                  |
|                                                 | `Export-Comments`             |
|                                                 | `Build-CommentView`           |
|                                                 | `Test-Comments`               |
| config                                          | `links.yml`                   |
|                                                 | `comments.yml`                |
|                                                 | `file-meta.yml`               |
| responsibility:4 — Terminology and dictionaries | `Build-TerminologyDictionary` |
|                                                 | `Build-EnglishDictionary`     |
|                                                 | `Test-Terminology`            |
| config                                          | `terminology.yml`             |
| responsibility:5 — Managed GUIDs                | `Test-ManagedGuid`            |
|                                                 | `Assert-ManagedGuid`          |
|                                                 | `Get-RepositoryGuids`         |
|                                                 | `ConvertTo-Guid`              |
|                                                 | `Test-ManagedGuids`           |
| config                                          | `guids.yml`                   |
