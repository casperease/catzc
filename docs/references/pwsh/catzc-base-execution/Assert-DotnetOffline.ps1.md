# pwsh/Catzc.Base.Execution/Assert-DotnetOffline.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Stops a dotnet run that a package source could reach: the guard every in-tree dotnet build, publish or format calls first.

### description

NuGet reads its config from the project's folder up to the drive root, then the user's and the machine's. The repository's generated root
`nuget.config` (New-NuGetConfig, written by Build-RootConfig) clears every package and audit source, so the user's feeds never reach a run.
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
