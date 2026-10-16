---
catzc:
  derived:
    path: docs/references/automation/catzc-base-vendor/types/VendorConfig.cs.md
    kind: comment-page
    language: markdown
    filetype: md
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: e339ea80dbd6
    adrs:
      - ADR-AUTO-TYPES#8
---

# automation/Catzc.Base.Vendor/types/VendorConfig.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `using System;`, written with `//`.

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

Above `public string sourceUrl { get; }`, written with `//`.

```text
A custom repository url, registered under the `source` name on first use. Null when the source is a
built-in repository that needs no url.
```
