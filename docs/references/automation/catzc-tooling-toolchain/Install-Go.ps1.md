---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-toolchain/Install-Go.ps1.md
    kind: comment-page
    body_sha: "1e3cac59d0e9"
---

# automation/Catzc.Tooling.Toolchain/Install-Go.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

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
