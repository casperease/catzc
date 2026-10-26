# pwsh/Tooling.Toolchain/private/Get-DotnetInstallHolder.ps1

A private helper of the .NET removal: the lookup of the processes that hold a .NET install open, which `Stop-DotnetInstallHolder` then
stops.

## help

### synopsis

Lists the processes that hold a .NET install open.

### description

Every running .NET host — the dotnet muxer, an apphost such as VBCSCompiler.exe, an MSBuild node, an editor's language server — loads the
install's host resolver, `host/fxr/<version>/hostfxr`. The holders of those files are therefore the processes that would make a delete of
the install fail part-way. Each holder is listed once. Locking is advisory off Windows, so there it lists nothing (Get-FileLockingProcess).

### parameter `InstallDir`

The .NET install directory.

### outputs

`[Catzc.Base.Files.FileLockingProcess]` per holding process.
