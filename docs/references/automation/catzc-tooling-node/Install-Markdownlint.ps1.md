---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-node/Install-Markdownlint.ps1.md
    kind: comment-page
    body_sha: "1a2e0f11169f"
    adrs: []
---

# automation/Catzc.Tooling.Node/Install-Markdownlint.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
markdownlint-cli2 is the linter behind Test-Markdownlint. It is installed globally with npm at the
version locked in tools.yml. Requires Node.js (npm). Idempotent — skips if already installed at the
locked version; -Force replaces a wrong version.
```
