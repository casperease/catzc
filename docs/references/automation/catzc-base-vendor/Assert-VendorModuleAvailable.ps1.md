---
catzc:
  derived:
    path: docs/references/automation/catzc-base-vendor/Assert-VendorModuleAvailable.ps1.md
    kind: comment-page
    body_sha: "5f4859ecba5c"
    adrs: []
    links: []
---

# automation/Catzc.Base.Vendor/Assert-VendorModuleAvailable.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The throwing half of the restorability check (Test-VendorModuleAvailable is the query). Throws an
actionable error when the source cannot offer the module, so a caller — chiefly Remove-VendorModules — never
deletes a committed binary that the network cannot restore.
```
