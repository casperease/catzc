---
catzc:
  derived:
    path: docs/references/automation/catzc-base-vendor/private/Get-VendoredModule.ps1.md
    kind: reference
    body_sha: "89ad38c687aa"
    adrs: []
---

# automation/Catzc.Base.Vendor/private/Get-VendoredModule.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
One record per vendored module folder (automation/.vendor/<Name>/<Version>/), reading its name, the
committed version, and its folder path. The single reader behind Remove-VendorModules' target list and its
availability validation. Returns an empty array when the vendor folder is absent.
```
