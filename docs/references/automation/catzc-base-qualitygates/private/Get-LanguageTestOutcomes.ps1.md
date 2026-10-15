---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/private/Get-LanguageTestOutcomes.ps1.md
    kind: comment-page
    body_sha: e2e5be7ffc82
    adrs:
      - ADR-AUTO-TEST#8
---

# automation/Catzc.Base.QualityGates/private/Get-LanguageTestOutcomes.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The language bridge's run step (tests/Language.Bridge.ps1 calls it once per test folder, in its BeforeAll); each
generated Pester test then reports its own outcome:

  - tool missing: when -Executable is empty (the run's source session found no managed tool at the tools.yml pin,
    Get-LanguageTestExecutable), nothing runs and every case is skipped with the constrained skip key
    tool_go_missing, tool_uv_missing or tool_bash_missing; when -EngineExecutable is empty for an engine other
    than pwsh, that engine's run skips every case with tool_<engine>_missing
    ([ADR-AUTO-TEST#8](/docs/adr/automation/test-automation.md#rule-adr-auto-test8));
  - otherwise the language's runner runs the module's tests (against -EntryScript in a build run): Invoke-GoTest
    for go, Invoke-PythonTest for python, Invoke-BashTest for bash (under the bash engine only: a Bash test is
    Bash). Each case takes the outcome of its result — the result types share the shape
    Package/Name/Outcome/Output — pass; fail, with the test output; or skip, with the skip key
    go_test_skipped, python_test_skipped or bash_test_skipped and the test output.

Throws when the runner reports a test the discovery did not list (a declaration the static discovery cannot
read), so no result goes unreported; a listed case with no result fails with that message. A failure of the
runner itself (go vet or ruff check, a package that does not build) propagates, which fails every test of the
module with the tool output.
```

## comment:2

Section `.PARAMETER Executable` of the comment-based help.

```text
The managed tool the run's source session located and checked against the pin (go, uv for python, the bash
engine for bash), handed
down through the shard and the bridge container; empty when there is none. The worker never locates the tool
itself: a build run's engine does not carry the tools.yml entry.
```

## comment:3

Section `.PARAMETER Engine` of the comment-based help.

```text
The execution engine the tests start ([ADR-AUTO-ENGINE](/docs/adr/automation/execution-engines.md)): one of the
model's engines, pwsh by default. Every test runs once per engine.
```

## comment:4

Section `.PARAMETER EngineExecutable` of the comment-based help.

```text
The engine's executable the run's source session located; empty for an engine it did not find, whose run of the
tests then skips with tool_<engine>_missing. pwsh, the engine running the harness, needs none.
```
