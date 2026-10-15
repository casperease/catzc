---
catzc:
  derived:
    path: docs/references/automation/catzc-base-exporter/private/Assert-BundleFootprint.ps1.md
    kind: comment-page
    body_sha: f8d85110c582
    adrs:
      - ADR-PWSH-ENUM#3
---

# automation/Catzc.Base.Exporter/private/Assert-BundleFootprint.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
A bundle is a small engine carried to other environments, so how big it is is a checked property, not a hope
([ADR-AUTO-BUNDLE](/docs/adr/automation/platform-bundle.md)). The limits are the bundle's own max_files and
max_bytes in exporter.yml (ExporterBundle); a limit the bundle does not state is not checked. Every exceeded
limit is reported in one throw, with the build's top-level folders by size, so the message says where the
weight is.
```

## comment:2

Above `foreach ($file in Get-ChildPath $root -File -Depth 64 -Exclude @()...`.

```text
A named whole-tree walk ([ADR-PWSH-ENUM#3](/docs/adr/pwsh/bounded-enumeration.md#rule-adr-pwsh-enum3)): the
footprint counts every shipped byte, so nothing is pruned.
```
