---
catzc:
  derived:
    path: docs/references/automation/catzc-base-vendor/configs/vendor.yml.md
    kind: comment-page
    body_sha: a94697cc3926
---

# automation/Catzc.Base.Vendor/configs/vendor.yml

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `source: PSGallery`.

```text
Vendor module source — where Install-VendorModule downloads from and Remove-VendorModules validates against
(see [ADR-PWSH-VENDOR](/docs/adr/pwsh/vendor-toolset-dependencies.md)). Loaded by Get-Config -Config vendor and
validated by the VendorConfig type. Read only through the module's functions.
```

## comment:2

Above `source: PSGallery`.

```text
The registered PSResourceRepository to download from and validate against. PSGallery is the built-in default
and needs no url.
```

## comment:3

At the end of the file.

```text
Optional custom repository url (an Artifactory / proxy feed). Undefined by default — set it to point the
vendor source at a private feed; the repository is registered under the `source` name on first use.
sourceUrl: https://your-feed/v3/index.json
```
