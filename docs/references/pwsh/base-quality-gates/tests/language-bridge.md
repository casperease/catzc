# pwsh/Base.QualityGates/tests/Language.Bridge.ps1

The language bridge: one shared Pester file that the harness runs once per test folder of a test language beside PowerShell (Go, Python,
Bash). It runs as a Pester container whose data names the language, the folder, the engine entry, and the tool the run's source session
located (`ConvertTo-PesterRunTarget`). It is not a `*.Tests.ps1` file, so no path scan runs it without that data.

## Discovery

Discovery reads the folder's tests from its source files (`Get-GoTestCases`, `Get-PythonTestCases`, `Get-BashTestCases`). Every test becomes
one Pester test per engine it runs under, tagged L2, because it uses a real tool and a real engine
([ADR-AUTO-TEST-NOCLOUDBELOWLTHREE](../../../../drs/automation/test-automation.md#rule-adr-auto-test-nocloudbelowlthree)), plus a category
from its name: `TestIntegrity*`, `test_integrity*` or `integrity: …` is integrity, and everything else is logic.

## Engines

Every test runs once per execution engine
([ADR-AUTO-ENGINE-STARTENVIRONMENT](../../../../drs/automation/execution-engines.md#rule-adr-auto-engine-startenvironment)): the same test,
a different contract. A Bash test is Bash, so it runs under the bash engine only. A JavaScript test runs once, under the pwsh engine. Every
other language runs under each engine. The `EngineExecutable` parameter holds the executables of the engines other than pwsh, by engine
name, as the run's source session located them. An empty or missing entry means that engine's run of the tests skips.

## The run

The run calls the language's runner once for the module (`Get-LanguageTestOutcomes`). Each test then passes, fails with the test output, or
skips as the test did. When the source session handed down no managed tool at the pinned version, every test skips with `tool_go_missing`,
`tool_uv_missing` or `tool_bash_missing`
([ADR-AUTO-TEST-TAGBYOUTERMOSTRING](../../../../drs/automation/test-automation.md#rule-adr-auto-test-tagbyoutermostring)).

A run that throws, such as a ruff or pytest error or a sync that fails, fails each of its cases with its message. The results then name the
cause instead of one `BeforeAll` failure hiding it, and the other engines still run.

The tests start the engine in processes of their own, so the file runs in the greedy phase
([ADR-AUTO-TEST-ONESCHEDULINGPOOL](../../../../drs/automation/test-automation.md#rule-adr-auto-test-oneschedulingpool)).

## comment:1

Above `$runs = & (Get-Module Catzc.Base.QualityGates) {`, written with `#`.

```text
Every test runs once per execution engine: the same test, a different contract.
The engines run side by side, each in its own process under its own contract, so the folder takes its slowest engine.
```
