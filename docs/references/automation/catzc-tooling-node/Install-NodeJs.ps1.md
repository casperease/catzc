---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-node/Install-NodeJs.ps1.md
    kind: comment-page
    body_sha: e46d2f670bbe
---

# automation/Catzc.Tooling.Node/Install-NodeJs.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$sourcePath = '/etc/apt/sources.list.d/nodesource.list'`, written with `#`.

```text
The distro `nodejs` package trails the pinned major badly (Ubuntu jammy ships Node 12), so install
from the NodeSource apt repository for the locked major — mirroring the HashiCorp repo setup in
Install-Terraform. The repo URL embeds the major, so re-write the source when the pin changes.
```
