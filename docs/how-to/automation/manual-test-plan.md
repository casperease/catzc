---
catzc:
  derived:
    path: docs/how-to/automation/manual-test-plan.md
    folder: docs/how-to/automation
    name: manual-test-plan
    filetype: md
    kind: how-to
    language: markdown
    track: docs
    body_sha: "63acd364cda0"
    links:
      - docs/how-to/automation/manual-test-plan/adr-registry.md
      - docs/how-to/automation/manual-test-plan/azure.md
      - docs/how-to/automation/manual-test-plan/configs.md
      - docs/how-to/automation/manual-test-plan/csharp-types.md
      - docs/how-to/automation/manual-test-plan/docs-and-links.md
      - docs/how-to/automation/manual-test-plan/module-system.md
      - docs/how-to/automation/manual-test-plan/pipelines-and-globs.md
      - docs/how-to/automation/manual-test-plan/repository-conventions.md
      - docs/how-to/automation/manual-test-plan/root-config-and-editor.md
      - docs/how-to/automation/manual-test-plan/spelling-and-language.md
      - docs/how-to/automation/manual-test-plan/static-analysis.md
      - docs/how-to/automation/manual-test-plan/test-harness.md
      - docs/how-to/automation/manual-test-plan/tooling.md
---

# Manual test plan — integrity assertions

This plan lists every **integrity** check among all tests. These are the tests that read the _real repository contents_: the shipped
`azure.yml`/`network.yml`/`tools.yml`/`ado.yml`/`dependencies.yml`, real templates, the module/type/function graph, checked-in binaries, and
file & folder conventions. Logic tests (hermetic, run on mocks and fixtures) are out of scope.

The checks are split by subject into category files, one per category and at most 13. Each category file has an index table followed by
details. In the details, section _N_ corresponds to row _N_ of that file's index, and the row gives the `Test file` and `FullNameFilter` to
paste into the single-check command.

The whole plan is just one command (`Test-Automation -Category Integrity -Level 2`) decomposed so a tester can run, and reason about, each
check on its own.

## Categories

| Category                                                             | Covers                                                                                    |
| -------------------------------------------------------------------- | ----------------------------------------------------------------------------------------- |
| [Repository conventions](manual-test-plan/repository-conventions.md) | Folder, file, and naming conventions, repository paths, the git index, managed GUIDs      |
| [C# types](manual-test-plan/csharp-types.md)                         | Shipped C# types and the committed combined assembly                                      |
| [Configs](manual-test-plan/configs.md)                               | Config discovery, the config registry, and the shipped non-Azure configs                  |
| [Module system](manual-test-plan/module-system.md)                   | Module and function dependency graphs, test order, profiles, asset deps, the built bundle |
| [Tooling](manual-test-plan/tooling.md)                               | The shipped `tools.yml` and tool install machinery                                        |
| [Azure](manual-test-plan/azure.md)                                   | The shipped Azure configs and bicep templates                                             |
| [Pipelines and globs](manual-test-plan/pipelines-and-globs.md)       | Azure DevOps configs, the pipelines tree, and globset trigger projections                 |
| [Static analysis](manual-test-plan/static-analysis.md)               | PSScriptAnalyzer, the formatter, and the analyzer-to-ADR map                              |
| [Spelling and language](manual-test-plan/spelling-and-language.md)   | Spell-checking, terminology, dictionaries, and the glossary                               |
| [ADR registry](manual-test-plan/adr-registry.md)                     | ADR rule-sets, the domain graph, the ADR index, and rule enforcers                        |
| [Docs and links](manual-test-plan/docs-and-links.md)                 | Generated READMEs and `.gitkeep` files, Markdown lint and titles, links                   |
| [Root config and editor](manual-test-plan/root-config-and-editor.md) | Managed root config files, the importer, `.gitignore`, and VS Code registries             |
| [Test harness](manual-test-plan/test-harness.md)                     | The test runner, vendored Pester, fixture-identity hygiene, and this plan's drift guard   |

## How to run a check

There are two ways: run a whole group, or run one check at a time.

**Run a group (the supported path):**

```powershell
. ./importer.ps1
Test-Automation -Category Integrity -Level 2                    # every integrity check (the whole plan)
Test-Automation -Category Integrity -Modules Catzc.Azure        # one module's integrity checks
Test-Automation -Category Integrity -Level 2 -Output Detailed   # one line per assertion
```

**Run one check (precise):** take the `Test file` and `FullNameFilter` from the row in its category file and hand them to the single-check
entry point:

```powershell
. ./importer.ps1
Invoke-TestFile <Test file> -FullNameFilter '<FullNameFilter>'
```

`Invoke-TestFile` runs the file as a one-shard worker, exactly the way `Test-Automation` does: the same generated runner, the same Pester
configuration builder, and strict mode per `ADR-AUTO-TEST:25`. Do **not** call `Invoke-Pester` directly from an importer session. The tests
would run against whatever that session has accumulated, such as warm caches and leftover state, instead of a fresh worker's.

A check **passes** when its assertions are green. A few L2 checks shell out to a tool (git, PSScriptAnalyzer, cspell, markdownlint-cli2) and
**self-skip** when that tool is absent. A skip is not a failure (see the end-of-run skip report).

**While another run is going.** A test run never waits for another (`ADR-AUTO-TEST:32`). When another test run or session already holds the
working folder, your run says who holds it and runs in a verified snapshot of your working folder instead. The snapshot includes your
uncommitted changes, frozen at the moment the run started. The artifacts still land in `out/test-automation/<stamp>/` (or
`out/test-file/<stamp>/`). A `Test-Automation` run's `run.json` and `summary.md` record the snapshot location and provenance, and
`Invoke-TestFile` names the location on its closing line. Add `-KeepSandbox` to keep the snapshot for a post-mortem (its path is printed at
the end), or `-Isolated` to run in a snapshot even when the working folder is free.
