---
catzc:
  derived:
    path: docs/references/automation/catzc-base-exporter/private/New-CatzcNuGetPackage.ps1.md
    kind: comment-page
    body_sha: c39be089655a
    adrs:
      - ADR-AUTO-BUNDLE#6
---

# automation/Catzc.Base.Exporter/private/New-CatzcNuGetPackage.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The package delivery shape ([ADR-AUTO-BUNDLE#6](/docs/adr/automation/platform-bundle.md#rule-adr-auto-bundle6)). The
build folder is already an installable module — its
Catzc.psd1 carries the version, GUID and package metadata, its Catzc.psm1 loads the platform, and the
vendored dependencies ride inside its .vendor/ — so the build folder itself is compressed, as is, with
Compress-PSResource into <DestinationPath>/Catzc.<version>.nupkg (pack only, no publish). A client registers
the destination folder as a PSResource repository and runs Install-PSResource Catzc. Publishing beyond the
local disk is the release workflow's act ([ADR-GH-RELEASE](/docs/adr/github/github-release.md)).
```
