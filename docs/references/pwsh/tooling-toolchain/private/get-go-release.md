# pwsh/Tooling.Toolchain/private/Get-GoRelease.ps1

A private helper of `Install-Go`: it reads the go.dev release feed and resolves the official archive, with its published SHA-256, for the
locked version.

## help

### synopsis

Resolves the official Go archive for a locked version from the go.dev release feed.

### description

Reads the go.dev release feed (<https://go.dev/dl/?mode=json&include=all>), keeps the stable releases of the locked version (`1.27` matches
go1.27 and every go1.27.N), takes the newest, and returns its archive file for this platform: the feed's own file entry, with `filename`,
`version`, `os`, `arch`, `kind` and the published `sha256` that Install-Go verifies the download against. Throws when no stable release or
no archive matches.

### parameter `Version`

The locked Go version (major.minor, or an exact major.minor.patch).

### parameter `Os`

The feed's os name: windows, linux, or darwin. Defaults to the running platform.

### parameter `Arch`

The feed's architecture name: amd64 or arm64. Defaults to the running process's OS architecture.

### example 1

```powershell
Get-GoRelease -Version '1.27'
```
