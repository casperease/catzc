# pwsh/Base.QualityGates/private/Get-LanguageTestExecutable.ps1

Locates, once, the managed tool each test language needs and the executable of each execution engine other than the running pwsh. A test
run's source session hands the result down to every worker, because a worker cannot locate them itself.

## help

### synopsis

Returns the managed tool a test run hands to each test language's tests: a path per language, or an empty string.

### description

A test run's source session locates each test language's tool once (Resolve-ToolExecutable, the tools.yml entry) and hands the paths down to
every worker through the shard script and the language bridge container, beside the engine entry. The worker never locates a tool itself: a
build run's engine carries only the modules under test, not the tools.yml entries, and the tools belong to the harness, not to what ships
([ADR-AUTO-GO-GOBRIDGE](../../../../drs/automation/go/go-test-artifacts.md#rule-adr-auto-go-gobridge),
[ADR-AUTO-PY-PYBRIDGE](../../../../drs/automation/python/python-test-artifacts.md#rule-adr-auto-py-pybridge)):

```text
go      the managed go at the pin;
python  the managed uv at the pin, handed down only when the uv-managed python at the tools.yml pin is there
        too, since uv never downloads an interpreter in a test run;
<engine>  every execution engine other than the running pwsh, by its name (Resolve-EngineExecutable): each
        language's tests also run under each of them
        ([ADR-AUTO-ENGINE-STARTENVIRONMENT](/docs/drs/automation/execution-engines.md#rule-adr-auto-engine-startenvironment)), and the bash
        engine runs the Bash tests.
```

An entry is empty when the repository has no test folder (nothing is probed), or when its tool or engine is missing or misses the pin; the
bridge then skips those tests with tool_go_missing, tool_uv_missing or `tool_<engine>_missing`.

### outputs

`[hashtable]` @{ go = `<path or ''>`; python = `<path or ''>`; `<engine>` = `<path or ''>` per engine other than pwsh }.

### example 1

```powershell
$executables = Get-LanguageTestExecutable
```

## why it is located here

A build run's worker cannot locate a tool: its engine carries only the modules under test, not the `tools.yml` entries. So each executable
is resolved once in the source session. An entry stays empty when the repository has no test folder in that language, or when the tool or
engine is missing, and the bridge then skips those tests.

## the engines

Every engine of the model except the running pwsh is resolved by its name
([ADR-AUTO-ENGINE-THREEENGINES](../../../../drs/automation/execution-engines.md#rule-adr-auto-engine-threeengines)): the list is read from
the model and never restated. An engine that cannot be resolved is logged to the verbose stream and left empty.

## the languages

The languages whose tests need a tool come from the languages registry: those with a `tests` entry that names no engine. A language that is
an engine resolves with the engines instead. Every tool the entry names must resolve at its locked version, and the first one's path is the
one the runner takes.
