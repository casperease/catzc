# Catzc.Base.QualityGates

The quality-gate module. It **runs every check the repository applies to itself** — the Pester test suite (with tag-enforcement and
timestamped reporting), the spell-checker, the Markdown linter, the Markdown formatter, and the PowerShell auto-formatter. What it
deliberately sdfdoes **not** own is the tests themselves (each module keeps its own `tests/` folder) or the per-tool configuration (cSpell,
markdownlint, and Prettier each carry their own config at the repository root). This module owns the gate invocations, and nothing more. The
tier and category tag rules that the Pester runner enforces are the subject of [test-automation](../../adr/automation/test-automation.md).

## Domains

| Domain   | Area   | Name                                                                               |
| -------- | ------ | ---------------------------------------------------------------------------------- |
| domain:1 | runner | [Test suite runner](#domain1--test-suite-runner)                                   |
| domain:2 | gates  | [Document and code formatting gates](#domain2--document-and-code-formatting-gates) |

### domain:1 — Test suite runner

How the repository runs and validates its Pester test suite. This domain discovers tests across every module, runs them at the requested
tier level (L0–L3) and optional category filter (`logic`/`integrity`), and writes a timestamped report. Before any test executes, a
discovery-only pass inspects the full test tree and throws if any test is missing or ambiguous on either of the two mandatory tag axes —
exactly one tier (`L0|L1|L2|L3`) and exactly one category (`logic|integrity`). The tag model, the two-axis tagging contract, and the tier
definitions are the subject of [test-automation](../../adr/automation/test-automation.md).

### domain:2 — Document and code formatting gates

How the repository checks and enforces the style of its written and source content. This domain runs the spell-checker, the Markdown linter,
the Markdown formatter (which aligns tables and wraps prose in-place), and the PowerShell auto-formatter. These are the same style gates CI
runs; a contributor runs them locally before pushing, and CI runs them on every pull request. The domain owns the invocation of each tool,
not the tool itself or its per-tool configuration.

## What the module does

The module is the repository's self-check harness. Its two domains are ordered by scope: the test runner (domain 1) checks behaviour — does
every function do what it claims? — while the formatting gates (domain 2) check form — are the prose, markup, and source consistently
shaped? Both answer to the same contract: these are the gates a change is measured against before it merges.

Domain 1 carries the most machinery. The test runner does not simply invoke Pester; it enforces the two-tag contract on every run. A
discovery-only pass — driven by private helpers that perform nearest-contributing-block tag resolution across the `Describe`/`Context` chain
— inspects every test before a single one executes, so a missing or ambiguous tag fails the run immediately rather than silently skipping a
tier. The L0–L3 tier filter and the `logic`/`integrity` category filter are orthogonal run parameters: a contributor can run `L1 logic` for
a fast, hermetic unit-only pass, or `L2 integrity` to drive CLI tools against the real repository files, and the enforcement pass always
covers the full tree regardless of which subset is requested. The private tag-resolution and skip-report helpers are the mechanism behind
that enforcement, not part of the public gate contract.

Domain 2 is a set of thin wrappers, one per external tool, deliberately kept separate so each gate can be run in isolation or combined.
`Format-Markdown` is both a gate and a mutation — it reformats files in-place, so it belongs to the authoring workflow as well as CI.
`Format-Automation` does the same for PowerShell source. The others (`Test-Spelling`, `Test-Markdownlint`) read without writing.

The module's neighbours are the rest of the `Base` group — `Catzc.Base.ModuleSystem`, `Catzc.Base.Repository`, `Catzc.Base.Execution`,
`Catzc.Base.Writers`, and `Catzc.Base.Asserts` — which supply the primitives (file location, process invocation, console output, and
assertions) this module composes. It does not depend on any domain module.

## Division

The module's public functions, sorted into the domains above.

| Domain                                        | Function            |
| --------------------------------------------- | ------------------- |
| domain:1 — Test suite runner                  | `Test-Automation`   |
|                                               | `Invoke-TestFile`   |
| domain:2 — Document and code formatting gates | `Test-Spelling`     |
|                                               | `Test-Markdownlint` |
|                                               | `Format-Markdown`   |
|                                               | `Format-Automation` |
