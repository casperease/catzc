---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-cli/Test-AzCliExtension.ps1.md
    kind: comment-page
    body_sha: "1b406574cfcb"
    adrs: []
    links: []
---

# automation/Catzc.Azure.Cli/Test-AzCliExtension.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Returns $true if the named extension is installed, $false otherwise. Uses `az extension show` (a core
command) and inspects the exit code, so it never throws on a missing extension and never triggers a
dynamic install. Companion to Assert-AzCliExtension, mirroring the Test-/Assert-AzCliConnected pair.
```
