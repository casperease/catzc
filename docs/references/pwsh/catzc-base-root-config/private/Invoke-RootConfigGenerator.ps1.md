# pwsh/Base.RootConfig/private/Invoke-RootConfigGenerator.ps1

The generator dispatch of the root-config registry: the one place a generator name is bound to its invocation.

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

## The generators

- **`New-Importer`** renders the `importer.ps1` shim from the `Invoke-Importer` overlay's param block (`-DryRun` returns the content without
  writing).
- **The root `.gitignore`** is rendered from the gitignore section registry (`Catzc.Base.Git`). The managed-copies section is injected here,
  from this module's own registry (the `committed: false` targets, root-anchored), so the ignored-copies list lives once in `rootconfig.yml`
  and the dependency edge stays one-way (RootConfig to Git; `New-GitIgnore` never reads `rootconfig.yml`).
- **The VS Code workspace settings** are rendered from the vscode-settings registry (`Catzc.Base.VSCode`). Every opted-in managed target is
  injected into `search.exclude` here, from this module's own registry, so find-all lands on sources of truth, never generated copies, and
  the dependency edge stays one-way (RootConfig to VSCode; `New-VsCodeSettings` never reads `rootconfig.yml`).
- **The VS Code extension recommendations** are rendered from the vscode-extensions registry (`Catzc.Base.VSCode`), completed with every
  formatter engine's editor extension from the file-language registry.
- **`New-GoWorkspace`** renders the Go test workspace (`Catzc.Base.Languages`): the root `go.work` and one `go.mod` per
  `go/tests/<folder>/`, as one record per file; the entry's target selects which.
- **`New-PythonProject`** renders the Python test workspace (`Catzc.Base.Languages`): the uv workspace root and one member per Python test
  folder, as one record per file; the entry's target selects which.

## Editor settings

- The managed Go toolchain, when found at the pin: the Go extension and gopls otherwise run whichever `go` comes first on PATH, and on
  Windows a machine-wide Go precedes the user-scope managed one
  ([ADR-AUTO-GO-MANAGEDTOOLCHAIN](../../../../drs/automation/go/go-test-artifacts.md#rule-adr-auto-go-managedtoolchain)).
- The Python test workspace's one environment
  ([ADR-AUTO-PY-GENERATEDWORKSPACE](../../../../drs/automation/python/python-test-artifacts.md#rule-adr-auto-py-generatedworkspace)), under
  the resolved Python root and in this platform's layout: the Python extension resolves the tests' imports and runs them in it. Pylance runs
  pyright in the mode `Test-PythonTypes` runs it in
  ([ADR-AUTO-PY-EVERYFILETYPECHECKED](../../../../drs/automation/python/python-test-artifacts.md#rule-adr-auto-py-everyfiletypechecked)).
- Each language's editor formatter comes from the file-language registry: Format Document runs the engine `Format-Code` runs
  ([ADR-REPO-FORMAT-CONFIGUREDFORMATTERS](../../../../drs/repository/uniform-formatting.md#rule-adr-repo-format-configuredformatters)).
