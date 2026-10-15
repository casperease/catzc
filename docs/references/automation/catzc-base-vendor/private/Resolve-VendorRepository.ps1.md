---
catzc:
  derived:
    path: docs/references/automation/catzc-base-vendor/private/Resolve-VendorRepository.ps1.md
    kind: comment-page
    body_sha: "7de676490634"
---

# automation/Catzc.Base.Vendor/private/Resolve-VendorRepository.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Reads configs/vendor.yml (Get-Config -Config vendor). Returns its 'source' name — PSGallery by default.
When a custom 'sourceUrl' is set (an Artifactory / proxy feed), registers a trusted repository under the
'source' name on first use, so Save-PSResource/Find-PSResource can target it by name. Also asserts the
bundled PSResourceGet cmdlets are present (they ship with PowerShell 7.4+) so a stripped install fails with
a clear message rather than a missing-cmdlet error.
```
