---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-toolchain/Install-Terraform.ps1.md
    kind: comment-page
    body_sha: effde059a3f7
    adrs: []
    links: []
---

# automation/Catzc.Tooling.Toolchain/Install-Terraform.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Windows: winget. macOS: Homebrew (hashicorp/tap). Linux: HashiCorp
apt repository (configured inline if not already present).
Idempotent — skips if already installed at the correct version.
```
