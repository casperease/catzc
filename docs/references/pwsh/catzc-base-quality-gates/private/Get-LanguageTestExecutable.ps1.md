# pwsh/Catzc.Base.QualityGates/private/Get-LanguageTestExecutable.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Returns the managed tool a test run hands to each test language's tests: a path per language, or an empty string.

### description

A test run's source session locates each test language's tool once (Resolve-ToolExecutable, the tools.yml entry) and hands the paths down to
every worker through the shard script and the language bridge container, beside the engine entry. The worker never locates a tool itself: a
build run's engine carries only the modules under test, not the tools.yml entries, and the tools belong to the harness, not to what ships
([ADR-AUTO-GO-LANGUAGEBRIDGE](../../../../drs/automation/go/go-test-artifacts.md#rule-adr-auto-go-languagebridge),
[ADR-AUTO-PY-LANGUAGEBRIDGE](../../../../drs/automation/python/python-test-artifacts.md#rule-adr-auto-py-languagebridge)):

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

## comment:1

Above `$pwsh = [Catzc.Base.Engines.ExecutionEngines]::Pwsh.Name`, written with `#`.

```text
The engines other than the running pwsh, which every language's tests also run under
([ADR-AUTO-ENGINE-THREEENGINES](/docs/drs/automation/execution-engines.md#rule-adr-auto-engine-threeengines): the model's engines, never
a restated list): each located once here, since a build run's worker cannot locate it (its tools.yml entry is
not in the build).
```
