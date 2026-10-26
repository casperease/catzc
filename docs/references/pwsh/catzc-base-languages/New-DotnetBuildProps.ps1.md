# pwsh/Base.Languages/New-DotnetBuildProps.ps1

`New-DotnetBuildProps` renders the repository-root `Directory.Build.props`, which gives every project one target framework and turns NuGet
audit off. `Build-RootConfig` writes the result.

## help

### synopsis

Renders the repository-root Directory.Build.props: the one target framework, from the SDK the tooling installs, and NuGet audit off.

### description

Reads `dotnet.version` of tools.yml (the SDK Install-Dotnet installs, major.minor) and renders `net<version>` as the `TargetFramework` every
project in the repository inherits, so no project names a framework whose reference pack would have to be downloaded, and a framework change
is one edit of tools.yml. `NuGetAudit` is off, since audit reads package feeds and the repository's are cleared (New-NuGetConfig). A version
that is not major.minor throws, naming the value.

This is a pure renderer: it returns the content and writes nothing. It is the `generator` the root-config registry names for
`Directory.Build.props` (committed, read by every dotnet build before any import), and Build-RootConfig writes it under the generated-file
head in the `msbuild-project` carrier. See [ADR-REPO-ROOTCFG](../../../drs/repository/generated-root-configs.md).

### outputs

`[string]` The rendered Directory.Build.props content.

### example 1

```powershell
New-DotnetBuildProps
```

## Why one framework

The one target framework is the SDK the tooling installs, so a project never names a framework whose reference pack must be downloaded.
