---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-toolchain/Install-Go.ps1.md
    kind: comment-page
    body_sha: d1e44c9bb3cd
---

# automation/Catzc.Tooling.Toolchain/Install-Go.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Resolves the newest stable release of the locked version from the go.dev release feed (Get-GoRelease),
downloads its archive for this platform and verifies it against the SHA-256 the feed publishes
(Save-VerifiedDownload), and extracts it into the script-install home (Get-ScriptInstallDir: Windows
%LOCALAPPDATA%\go, Unix ~/.go). No package manager and no admin on any platform, so Windows, Linux and macOS
take the same path. The home's bin folder is put on the session and persistent PATH.

Idempotent — converges to the desired state on every run: when the home already holds the locked version the
download is skipped, but PATH is still converged, so a lost PATH entry is repaired by re-running. A Go at the
locked version found elsewhere (a pipeline's hosted tool cache, activated by the native Go task) satisfies the
contract and is left untouched.
```

## comment:2

Above `$probe = Test-Tool 'go' -PassThru`.

```text
Nothing in the managed home: a Go at the right version elsewhere satisfies the contract and is not ours to
manage. A wrong version elsewhere does not block the install — the managed home goes first on PATH.
```

## comment:3

Above `$staging = "$installDir.staging"`.

```text
Download and extract beside the home (same volume), then swap the extracted go/ folder in, so a failed
download or extraction never leaves a half-written home.
```

## comment:4

Above `if ($isZip) {`.

```text
The Windows archive is a .zip, extracted in-process: the tar first on PATH there is often Git's GNU tar,
which reads no zip and takes a drive letter's colon for a remote host. The Unix .tar.gz goes to tar, run
inside the staging folder with a relative name so no path carries a colon.
```

## comment:5

Above `$probe = Test-Tool 'go' -PassThru`.

```text
Nothing in the managed home: a Go at the right version elsewhere satisfies the contract and is not ours to
manage. A wrong version elsewhere does not block the install — the managed home goes first on PATH.
```

## comment:6

Above `$staging = "$installDir.staging"`.

```text
Download and extract beside the home (same volume), then swap the extracted go/ folder in, so a failed
download or extraction never leaves a half-written home.
```

## comment:7

Above `if ($isZip) {`.

```text
The Windows archive is a .zip, extracted in-process: the tar first on PATH there is often Git's GNU tar,
which reads no zip and takes a drive letter's colon for a remote host. The Unix .tar.gz goes to tar, run
inside the staging folder with a relative name so no path carries a colon.
```
