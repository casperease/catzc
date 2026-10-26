# pwsh/Base.QualityGates/private/Get-LanguageTestOutcomes.ps1

Runs a module's tests in one test language once and returns the outcome of every discovered test, keyed by the test's key. The language
bridge calls it once per test folder, and each generated Pester test reports its own outcome from the result.

## help

### synopsis

Runs a module's tests in one test language once and returns the Pester outcome of every discovered test.

### description

The language bridge's run step (tests/Language.Bridge.ps1 calls it once per test folder, in its BeforeAll); each generated Pester test then
reports its own outcome:

- tool missing: when -Executable is empty (the run's source session found no managed tool at the tools.yml pin, Get-LanguageTestExecutable),
  nothing runs and every case is skipped with the constrained skip key tool_go_missing, tool_uv_missing or tool_bash_missing; when
  -EngineExecutable is empty for an engine other than pwsh, that engine's run skips every case with `tool_<engine>_missing`
  ([ADR-AUTO-TEST-TAGBYOUTERMOSTRING](../../../../drs/automation/test-automation.md#rule-adr-auto-test-tagbyoutermostring));
- otherwise the language's runner runs the module's tests (against -EntryScript in a build run): Invoke-GoTest for go, Invoke-PythonTest for
  python, Invoke-BashTest for bash (under the bash engine only: a Bash test is Bash). Each case takes the outcome of its result — the result
  types share the shape Package/Name/Outcome/Output — pass; fail, with the test output; or skip, with the skip key go_test_skipped,
  python_test_skipped or bash_test_skipped and the test output.

Throws when the runner reports a test the discovery did not list (a declaration the static discovery cannot read), so no result goes
unreported; a listed case with no result fails with that message. A failure of the runner itself (go vet or ruff check, a package that does
not build) propagates, which fails every test of the module with the tool output.

### parameter `Language`

The test language: go, python or bash.

### parameter `Module`

The catzc module whose tests run.

### parameter `Case`

The module's discovered cases (Get-GoTestCases, Get-PythonTestCases, Get-BashTestCases).

### parameter `EntryScript`

The engine entry of a build run (the build's Import-Catzc.ps1); empty for the source run.

### parameter `Executable`

The managed tool the run's source session located and checked against the pin (go, uv for python, the bash engine for bash), handed down
through the shard and the bridge container; empty when there is none. The worker never locates the tool itself: a build run's engine does
not carry the tools.yml entry.

### parameter `Engine`

The execution engine the tests start ([ADR-AUTO-ENGINE](../../../../drs/automation/execution-engines.md)): one of the model's engines, pwsh
by default. Every test runs once per engine.

### parameter `EngineExecutable`

The engine's executable the run's source session located; empty for an engine it did not find, whose run of the tests then skips with
`tool_<engine>_missing`. pwsh, the engine running the harness, needs none.

### parameter `Folder`

The test folder the discovery named, a module's own `tests/` or the holder's, handed to the runner as its `-Folder`; when empty the runner
finds the holder's folder of the module itself.

### outputs

`[hashtable]` Case key -> `[pscustomobject]` { Outcome (pass|fail|skip); Reason (the skip key, or empty); Message (the failure text, or the
test output of a skip) }.

### example 1

```powershell
$outcomes = Get-LanguageTestOutcomes -Language go -Module Catzc.Base.Repository -Case $cases -Executable $go
```

## the runner

The language registry names the runner. A language without a `tests` entry has no test artifacts to run, so the function throws for it
([ADR-AUTO-MODULE-CHECKSBYLANGUAGE](../../../../drs/automation/module-model.md#rule-adr-auto-module-checksbylanguage)).

## the folder

`-Folder` is the test folder the discovery named, a module's own `tests/` or the holder's. When it is empty, the runner finds the holder's.

## engines

A language that is an engine runs its tests under that engine only, with the executable the source session located, so the `Engine`
parameter is dropped from the call. A runner whose tests run in no engine (JavaScript's, in node) declares no engine parameters, so it gets
only the parameters it declares.
