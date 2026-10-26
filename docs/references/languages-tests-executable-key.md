# The `executable` key of a language's `tests` block: what it said, and where it lives now

## What the key said

A file language with test artifacts names how they run in a `tests` block of its entry in the languages registry
(`pwsh/Base.Languages/configs/languages.yml`):

```yaml
go:
  tests: { runner: Invoke-GoTest, tools: [go], executable: GoExecutable }
```

The `executable` key named the runner's parameter that takes the path of the executable the run located: `GoExecutable` for `Invoke-GoTest`,
`UvExecutable` for `Invoke-PythonTest`, `EngineExecutable` for `Invoke-BashTest`. `LanguagesConfig` read it into
`LanguageTestRunner.executable` and required a parameter name, and `Get-LanguageTestOutcomes` passed the located path under that name.

## Why it goes

The language entry gained its own `executable` flag, `executable: true` on the languages a command may be implemented in
([layers](../drs/automation/layers.md), the rule that defines a command's implementation language). One entry then held two keys of one name
with two meanings, a boolean at the top and a parameter name inside `tests`. The decision, recorded in task-loose-ends step 2's naming note,
is that the key inside `tests` takes the name of what it holds.

## Where it lives now

The same value, under `executable_parameter` in the `tests` block
(`tests: { runner: Invoke-GoTest, tools: [go], executable_parameter: GoExecutable }`), read into `LanguageTestRunner.executable_parameter`.
`executable` inside a `tests` block is now an unknown key and fails the config at load. The module-model ADR's language-registry rule
absorbs this page when it is next restated.
