# pwsh/Tooling.Toolchain/Install-Go.ps1

The installer of the Go toolchain: the official go.dev archive for the locked version, unpacked into a managed user-space home that goes
first on PATH.

## help

### synopsis

Installs the Go toolchain from the official go.dev archive into a user-space home.

### description

Resolves the newest stable release of the locked version from the go.dev release feed (Get-GoRelease), downloads its archive for this
platform and verifies it against the SHA-256 the feed publishes (Save-VerifiedDownload), and extracts it into the script-install home
(Get-ScriptInstallDir: Windows %LOCALAPPDATA%\go, Unix ~/.go). No package manager and no admin on any platform, so Windows, Linux and macOS
take the same path. The home's bin folder is put on the session and persistent PATH.

Idempotent — converges to the desired state on every run: when the home already holds the locked version the download is skipped, but PATH
is still converged, so a lost PATH entry is repaired by re-running. A Go at the locked version found elsewhere (a pipeline's hosted tool
cache, activated by the native Go task) satisfies the contract and is left untouched.

### parameter `Version`

Go version to install. Defaults to the locked version in Get-ToolConfig.

### parameter `Force`

Replace an installation in the managed home at the wrong version.

### example 1

```powershell
Install-Go
```

### example 2

```powershell
Install-Go -Version '1.27' -Force
```

## Another Go on the machine

With nothing in the managed home, a Go at the right version elsewhere satisfies the contract and is not this command's to manage. A wrong
version elsewhere does not block the install, because the managed home goes first on PATH.

## Staging

The archive is downloaded and extracted beside the home, on the same volume, and only then is the extracted `go/` folder swapped in, so a
failed download or extraction never leaves a half-written home.

## Extracting

The Windows archive is a `.zip`, extracted in process: the tar first on PATH there is often Git's GNU tar, which reads no zip and takes a
drive letter's colon for a remote host. The Unix `.tar.gz` goes to tar, run inside the staging folder with a relative name so that no path
carries a colon.
