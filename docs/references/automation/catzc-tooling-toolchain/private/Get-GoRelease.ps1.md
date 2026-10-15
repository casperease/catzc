---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-toolchain/private/Get-GoRelease.ps1.md
    kind: comment-page
    body_sha: "2bb6d63125c5"
---

# automation/Catzc.Tooling.Toolchain/private/Get-GoRelease.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Reads the go.dev release feed (https://go.dev/dl/?mode=json&include=all), keeps the stable releases of the
locked version (`1.27` matches go1.27 and every go1.27.N), takes the newest, and returns its archive file for
this platform: the feed's own file entry, with `filename`, `version`, `os`, `arch`, `kind` and the published
`sha256` that Install-Go verifies the download against. Throws when no stable release or no archive matches.
```
