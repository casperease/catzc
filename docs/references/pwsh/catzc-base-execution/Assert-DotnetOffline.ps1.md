# pwsh/Base.Execution/Assert-DotnetOffline.ps1

The guard that every in-tree dotnet build, publish or format calls first. It proves, with file checks alone, that no package feed can be
reached by the run, and throws a named error when it can.

## help

### synopsis

Stops a dotnet run that a package feed could reach: the guard every in-tree dotnet build, publish or format calls first.

### description

NuGet reads its config from the project's folder up to the drive root, then the user's and the machine's. The repository's generated root
`nuget.config` (New-NuGetConfig, written by Build-RootConfig) clears every package and audit feed, so the user's feeds never reach a run.
This asserts that state with file checks only, starting no process and making no network call:

- the root `nuget.config` exists and is readable XML;
- its `packageSources` and `auditSources` each hold one `clear` and nothing else;
- no other `nuget.config` (any of the names NuGet reads) sits in a folder between `-Path` and the repository root.

A `nuget.config` off that path is left alone, since NuGet never reads it for that project. The allow-list of package managers the user may
grant later plugs in here; it is empty today.

### parameter `Path`

The project file, or the folder a dotnet command runs in, repository-relative or absolute; it must lie inside the repository.

### parameter `RepositoryRoot`

The repository root whose generated `nuget.config` keeps dotnet offline. Default: Get-RepositoryRoot.

### example 1

```powershell
Assert-DotnetOffline .claude/hooks/Record-AgentWrite/Record-AgentWrite.csproj
```

## Why it looks at every folder

NuGet reads its config from the project's folder up to the drive root, in every spelling of the file name (`nuget.config`, `NuGet.config`,
`NuGet.Config`), and then the user's and the machine's configs. The repository's generated root `nuget.config` clears every feed, which is
why one cleared root is enough to shut out what the user's and machine's configs add. A stray config between the project and the root could
add a feed back, so the guard checks each folder on that path and ignores configs off it.
