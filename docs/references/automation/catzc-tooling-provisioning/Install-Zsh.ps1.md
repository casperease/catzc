---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-provisioning/Install-Zsh.ps1.md
    kind: comment-page
    body_sha: "242c51223373"
---

# automation/Catzc.Tooling.Provisioning/Install-Zsh.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:6

Above `Install-Tool -Tool zsh -Force:$Force`.

```text
The shared apt installer: it installs the package the entry's apt_package names, and checks presence before
asking for root, so a box that has zsh at the pinned version installs nothing.
```

## comment:7

Above `if ($installed) {`.

```text
Past the early return, a manifest is either a -Force replacement or an install that was cut short: either way its
files go first, so the new manifest lists every file this package owns.
```

## comment:8

Above `foreach ($metadata in [System.IO.Directory]::GetFiles($staging)) {`.

```text
An MSYS2 package keeps its metadata files (.PKGINFO and its siblings) at the archive root and its payload under
etc/ and usr/: only the payload belongs in Git's tree.
```
