---
catzc:
  derived:
    path: docs/references/automation/catzc-base-vendor/Test-VendorModuleAvailable.ps1.md
    kind: comment-page
    body_sha: "7aeb232c0c5f"
    adrs: []
---

# automation/Catzc.Base.Vendor/Test-VendorModuleAvailable.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Queries the vendor source (configs/vendor.yml — PSGallery by default) with Find-PSResource. The querying
half of the "committed binaries are restorable from the network" check; Remove-VendorModules uses it before
deleting a vendored module, and it stands alone to validate a vendored set is reproducible.
```
