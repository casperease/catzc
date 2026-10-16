---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-provisioning/Install-Zsh.ps1.md
    folder: docs/references/automation/catzc-tooling-provisioning
    name: install-zsh-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "66bfe3570d10"
---

# automation/Catzc.Tooling.Provisioning/Install-Zsh.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `Install-Tool -Tool zsh -Force:$Force`, written with `#`.

```text
The shared apt installer: it installs the package the entry's apt_package names, and checks presence before
asking for root, so a box that has zsh at the pinned version installs nothing.
```

## comment:2

Above `if ($installed) {`, written with `#`.

```text
Past the early return, a manifest is either a -Force replacement or an install that was cut short: either way its
files go first, so the new manifest lists every file this package owns.
```

## comment:3

Above `foreach ($metadata in [System.IO.Directory]::GetFiles($staging)) {`, written with `#`.

```text
An MSYS2 package keeps its metadata files (.PKGINFO and its siblings) at the archive root and its payload under
etc/ and usr/: only the payload belongs in Git's tree.
```
