# pwsh/Catzc.Base.QualityGates/tests/Language.Bridge.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter',...`, written with `#`.

```text
The language bridge: one shared Pester file the harness runs once per test folder of a test language beside
PowerShell (Go, Python, Bash), as a Pester container whose data names the language, the folder, the engine entry, and the
tool the run's source session located (ConvertTo-PesterRunTarget). It is not a *.Tests.ps1 file, so no path scan
runs it without that data.

Discovery reads the folder's tests from its source files (Get-GoTestCases, Get-PythonTestCases, Get-BashTestCases),
so every test becomes one Pester test per engine it runs under (every engine; Bash tests the bash engine only), tagged
L2 (a real tool and a real engine, [ADR-AUTO-TEST-NOCLOUDBELOWLTHREE](/docs/drs/automation/test-automation.md#rule-adr-auto-test-nocloudbelowlthree))
plus its category from its name (TestIntegrity*, test_integrity* or "integrity: …" is integrity, everything else
logic). The run calls the language's runner once
for the module (Get-LanguageTestOutcomes): each test then passes, fails with the test output, or skips as the test
did; when the source session handed down no managed tool at the pinned version, every test skips with
tool_go_missing, tool_uv_missing or tool_bash_missing ([ADR-AUTO-TEST-TAGBYOUTERMOSTRING](/docs/drs/automation/test-automation.md#rule-adr-auto-test-tagbyoutermostring)).
The tests start the engine in processes of their own, so the file runs in the greedy phase
([ADR-AUTO-TEST-ONESCHEDULINGPOOL](/docs/drs/automation/test-automation.md#rule-adr-auto-test-oneschedulingpool)).
```

## comment:2

Above `[hashtable] $EngineExecutable = @{}`, written with `#`.

```text
The executables of the engines other than pwsh, by engine name, as the run's source session located them; an empty
or missing entry means that engine's run of the tests skips.
```

## comment:3

Above `$script:languageOutcomes = @{}`, written with `#`.

```text
Every test runs once per execution engine
([ADR-AUTO-ENGINE-STARTENVIRONMENT](/docs/drs/automation/execution-engines.md#rule-adr-auto-engine-startenvironment)): the same test, a
different contract.
```

## comment:4

Above `$script:languageErrors = @{}`, written with `#`.

```text
A run that throws (a ruff or pytest error, a sync that fails) fails each of its cases with its message, so the results name the
cause instead of one BeforeAll failure hiding it; the other engines still run.
```

## comment:5

Above `Engines     = if ($Language -eq 'bash') {`, written with `#`.

```text
A Bash test is Bash, so it runs under the bash engine only; a JavaScript test runs in node, once; every other
language's under each.
```
