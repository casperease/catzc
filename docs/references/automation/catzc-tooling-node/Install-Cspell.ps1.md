---
catzc:
  derived:
    path: docs/references/automation/catzc-tooling-node/Install-Cspell.ps1.md
    kind: comment-page
    body_sha: ad53066f731c
    adrs: []
---

# automation/Catzc.Tooling.Node/Install-Cspell.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
cspell is the spell-checker behind Test-Spelling. It is installed globally with npm at the version
locked in tools.yml. Requires Node.js (npm). Idempotent — skips if already installed at the locked
version; -Force replaces a wrong version.
```
