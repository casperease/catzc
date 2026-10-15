---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-node/Install-NodeJs.ps1.md
    kind: comment-page
    body_sha: c43d424e8970
---

# automation/Catzc.Tooling.Node/Install-NodeJs.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Installs Node.js (which includes npm) at the locked major version. Windows: winget
(OpenJS.NodeJS.LTS). macOS: Homebrew (node@<major>). Linux: the NodeSource apt
repository for the locked major (configured inline if not already present), because
the distro `nodejs` package lags the pin badly (Ubuntu jammy ships Node 12).
Idempotent — skips if already installed at the correct version.

NOT for CI pipelines. In Azure DevOps, use the native UseNode task
which activates pre-cached versions instantly:

    - task: UseNode@1
      inputs:
        version: '22.x'
```

## comment:2

Above `$sourcePath = '/etc/apt/sources.list.d/nodesource.list'`.

```text
The distro `nodejs` package trails the pinned major badly (Ubuntu jammy ships Node 12), so install
from the NodeSource apt repository for the locked major — mirroring the HashiCorp repo setup in
Install-Terraform. The repo URL embeds the major, so re-write the source when the pin changes.
```

## comment:3

Above `$sourcePath = '/etc/apt/sources.list.d/nodesource.list'`.

```text
The distro `nodejs` package trails the pinned major badly (Ubuntu jammy ships Node 12), so install
from the NodeSource apt repository for the locked major — mirroring the HashiCorp repo setup in
Install-Terraform. The repo URL embeds the major, so re-write the source when the pin changes.
```
