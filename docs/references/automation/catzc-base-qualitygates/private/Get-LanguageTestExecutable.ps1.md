---
catzc:
  derived:
    path: docs/references/automation/catzc-base-qualitygates/private/Get-LanguageTestExecutable.ps1.md
    kind: comment-page
    body_sha: "391c737f765b"
    adrs:
      - ADR-AUTO-ENGINE#1
      - ADR-AUTO-ENGINE#4
      - ADR-AUTO-GO#7
      - ADR-AUTO-PY#7
---

# automation/Catzc.Base.QualityGates/private/Get-LanguageTestExecutable.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
A test run's source session locates each test language's tool once (Resolve-ToolExecutable, the tools.yml entry)
and hands the paths down to every worker through the shard script and the language bridge container, beside the
engine entry. The worker never locates a tool itself: a build run's engine carries only the modules under test,
not the tools.yml entries, and the tools belong to the harness, not to what ships
([ADR-AUTO-GO#7](/docs/adr/automation/go/go-test-artifacts.md#rule-adr-auto-go7),
[ADR-AUTO-PY#7](/docs/adr/automation/python/python-test-artifacts.md#rule-adr-auto-py7)):

  go      the managed go at the pin;
  python  the managed uv at the pin, handed down only when the uv-managed python at the tools.yml pin is there
          too, since uv never downloads an interpreter in a test run;
  <engine>  every execution engine other than the running pwsh, by its name (Resolve-EngineExecutable): each
          language's tests also run under each of them
          ([ADR-AUTO-ENGINE#4](/docs/adr/automation/execution-engines.md#rule-adr-auto-engine4)), and the bash
          engine runs the Bash tests.

An entry is empty when the repository has no test folder (nothing is probed), or when its tool or engine is
missing or misses the pin; the bridge then skips those tests with tool_go_missing, tool_uv_missing or
tool_<engine>_missing.
```

## comment:2

Above `$pwsh = [Catzc.Base.Engines.ExecutionEngines]::Pwsh.Name`.

```text
The engines other than the running pwsh, which every language's tests also run under
([ADR-AUTO-ENGINE#1](/docs/adr/automation/execution-engines.md#rule-adr-auto-engine1): the model's engines, never
a restated list): each located once here, since a build run's worker cannot locate it (its tools.yml entry is
not in the build).
```
