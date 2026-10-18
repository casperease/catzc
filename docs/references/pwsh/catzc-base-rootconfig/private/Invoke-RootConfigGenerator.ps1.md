# pwsh/Catzc.Base.RootConfig/private/Invoke-RootConfigGenerator.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Renders the content of a generator-produced managed root file — the registry's generator dispatch.

### description

A rootconfig entry with a `generator` names a function that renders the target's whole content (header included) rather than an authored
source file to copy. This dispatch is the one place a generator name is bound to its invocation, so Build-RootConfig stays generic and an
unknown name fails loudly instead of invoking an arbitrary command. Each generator is called in its content-returning form (never its
writing form) — Build-RootConfig owns the write, through the same Write-FileIfChanged path as every copy-in.

A generator returns either one string (the content of the entry's single target) or one { Target; Content } record per file it renders (a
multi-file generator, e.g. New-GoWorkspace with its Catzc.Base.Languages.GoWorkspaceFile records). The entry's target is passed on, so a
multi-file generator renders only the files the entry names; a wildcard target (e.g. `go/tests/*/go.mod`) selects a set of files.

### parameter `Name`

The generator function name from the registry entry (e.g. 'New-Importer').

### parameter `Target`

The entry's target: a repository-relative path, or a wildcard pattern over a multi-file generator's files.

### outputs

`[string]` The rendered target content, or `[object[]]` one { Target; Content } record per rendered file.

## comment:1

Above `New-Importer -DryRun`, written with `#`.

```text
The importer.ps1 shim, rendered from the Invoke-Importer overlay's param block (-DryRun returns
the content without writing).
```

## comment:2

Above `$config = Get-Config -Config rootconfig`, written with `#`.

```text
The root .gitignore, rendered from the gitignore section registry (Catzc.Base.Git). The managed-
copies section is injected HERE, from this module's own registry — the committed:false targets,
root-anchored — so the ignored-copies list lives once in rootconfig.yml and the dependency edge
stays one-way (RootConfig -> Git; New-GitIgnore never reads rootconfig.yml).
```

## comment:3

Above `$config = Get-Config -Config rootconfig` (occurrence 2), written with `#`.

```text
The VS Code workspace settings, rendered from the vscode-settings registry (Catzc.Base.VSCode).
Every opted-in managed target is injected into search.exclude HERE, from this module's own
registry — find-all lands on sources of truth, never generated copies — and the dependency
edge stays one-way (RootConfig -> VSCode; New-VSCodeSettings never reads rootconfig.yml).
```

## comment:4

Above `$machineSetting = @{}`, written with `#`.

```text
The managed Go toolchain, when found at the pin: the Go extension and gopls otherwise run whichever go
comes first on PATH, and on Windows a machine-wide Go precedes the user-scope managed one
([ADR-AUTO-GO#6](/docs/adr/automation/go/go-test-artifacts.md#rule-adr-auto-go6)).
```

## comment:5

Above `$python = Get-Config -Config python`, written with `#`.

```text
The Python test workspace's one environment
([ADR-AUTO-PY#4](/docs/adr/automation/python/python-test-artifacts.md#rule-adr-auto-py4)), under the
resolved Python root and in this
platform's layout: the Python extension resolves the tests' imports and runs them in it.
```

## comment:6

Above `$languageFormatter = [ordered]@{}`, written with `#`.

```text
Each language's editor formatter, from the file-language registry: Format Document runs the engine
Format-Code runs ([ADR-REPO-FORMAT#8](/docs/adr/repository/uniform-formatting.md#rule-adr-repo-format8)).
```

## comment:7

Above `$engineExtension = @((Get-Config -Config languages).formatters.Values |...`, written with `#`.

```text
The VS Code extension recommendations, rendered from the vscode-extensions registry
(Catzc.Base.VSCode), completed with every formatter engine's editor extension from the file-language
registry.
```

## comment:8

Above `New-VSCodePipelineSchema`, written with `#`.

```text
The repo-controlled Azure Pipelines JSON Schema, rendered from the vscode-pipeline-schema
registry (Catzc.Base.VSCode). Fed to the extension via azure-pipelines.customSchemaFile to
replace its bundled per-task anyOf — the source of the offline "^PowerShell@2$" false positives.
```

## comment:9

Above `New-GoWorkspace -Target $Target`, written with `#`.

```text
The Go test workspace (Catzc.Base.Languages): the root go.work and one go.mod per go/tests/<folder>/,
as one record per file; the entry's target selects which.
```

## comment:10

Above `New-PythonProject -Target $Target`, written with `#`.

```text
The Python test workspace (Catzc.Base.Languages): the uv workspace root and one member per Python test
folder, as one record per file; the entry's target selects which.
```
