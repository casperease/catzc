---
catzc:
  derived:
    path: docs/references/automation/catzc-base-vendor/types/VendorConfig.cs.md
    kind: comment-page
    body_sha: "47c10e006b1d"
    adrs:
      - ADR-AUTO-TYPES#8
    links: []
---

# automation/Catzc.Base.Vendor/types/VendorConfig.cs

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Above `using System;`.

```text
The vendor module source (configs/vendor.yml) — where Install-VendorModule downloads vendored modules from and
Remove-VendorModules validates them against ([ADR-PWSH-VENDOR](/docs/adr/pwsh/vendor-toolset-dependencies.md)).
Registered in Catzc.Base.Config/configs/configs.yml (type: Catzc.Base.Vendor.VendorConfig), so
Get-Config -Config vendor returns this typed record. Mirrors the YAML keys verbatim (the file's own `sourceUrl`
spelling, [ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)).

Constructing an instance validates the file, collecting every violation into one ArgumentException:
  - only the known keys ('source', 'sourceUrl') — an unknown key (a typo) fails fast at load;
  - 'source' is required and non-empty (the registered PSResourceRepository name, e.g. PSGallery);
  - 'sourceUrl', when present, is an absolute URI (a custom Artifactory / proxy feed).
```

## comment:2

Above `public string sourceUrl { get; }`.

```text
A custom repository url, registered under the `source` name on first use. Null when the source is a
built-in repository that needs no url.
```
