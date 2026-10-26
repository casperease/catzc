# pwsh/Base.Languages/New-NuGetConfig.ps1

`New-NuGetConfig` renders the repository-root `nuget.config`, which clears every package and audit feed. `Build-RootConfig` writes the
result.

## help

### synopsis

Renders the repository-root nuget.config that clears every package and audit feed, so no dotnet run reaches a package manager.

### description

The C# language's NuGet config, beside the Go and Python project files this module renders. It clears `packageSources` and `auditSources`,
which drops the sources the user's and the machine's configs add, so a restore finds nothing to contact. The repository's dependencies are
the BCL or vendored, so nothing needs a source.

This is a pure renderer: it returns the content and writes nothing. It is the `generator` the root-config registry names for `nuget.config`
(committed, since the C# Dev Kit restores as the folder opens, before any import), and Build-RootConfig writes it under the generated-file
head in the `nuget-config` carrier. Assert-DotnetOffline checks the written file before every dotnet run. See
[ADR-REPO-ROOTCFG](../../../drs/repository/generated-root-configs.md).

### outputs

`[string]` The rendered nuget.config content.

### example 1

```powershell
New-NuGetConfig
```

## Why the sources are empty

Package and audit feeds are cleared, so no dotnet run in the repository reaches a package manager. The allowed set is empty today.
