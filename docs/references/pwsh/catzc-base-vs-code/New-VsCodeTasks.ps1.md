# pwsh/Base.VSCode/New-VsCodeTasks.ps1

The renderer of `.vscode/tasks.json`, the tasks the editor offers, from the `vscode-tasks` registry.

## help

### synopsis

Renders .vscode/tasks.json content from the vscode-tasks registry — the tasks the editor offers, such as the fast push.

### description

Reads the authored task registry (configs/vscode-tasks.yml, via Get-Config -Config vscode-tasks, which maps and validates it as a
VscodeTasksConfig) and renders it to the tasks.json content: the version, tasks, and inputs as JSON, in registry order, without a head
(Build-RootConfig writes the generated-file head as a JSONC comment head, which VS Code reads in tasks.json). The explanations live as
comments in the yml, not in the rendering.

This is a pure renderer: it returns the content and writes nothing — it is the `generator` the root-config registry names for the
.vscode/tasks.json target, and Build-RootConfig owns the write. See [ADR-REPO-ROOTCFG](../../../drs/repository/generated-root-configs.md).

### outputs

`[string]` The rendered tasks.json content (LF-joined; the writer canonicalises).

### example 1

```powershell
New-VsCodeTasks
```
