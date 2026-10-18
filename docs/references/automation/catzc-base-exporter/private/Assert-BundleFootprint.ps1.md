---
catzc:
  immutable:
    with_body_sha: "04bd70cf9a20"
    repo_status: locked
    path: docs/references/automation/catzc-base-exporter/private/Assert-BundleFootprint.ps1.md
    folder: docs/references/automation/catzc-base-exporter/private
    name: assert-bundle-footprint-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
  edges:
    cites:
      - ADR-PWSH-ENUM#3
---

# automation/Catzc.Base.Exporter/private/Assert-BundleFootprint.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Throws when a build holds more files or bytes than its bundle's footprint limits allow.

### description

A bundle is a small engine carried to other environments, so how big it is is a checked property, not a hope
([ADR-AUTO-BUNDLE](../../../../adr/automation/platform-bundle.md)). The limits are the bundle's own max_files and max_bytes in exporter.yml
(ExporterBundle); a limit the bundle does not state is not checked. Every exceeded limit is reported in one throw, with the build's
top-level folders by size, so the message says where the weight is.

### parameter Path

The build root (the `Catzc/<version>/` folder).

### parameter Bundle

The bundle's exporter.yml entry (an ExporterBundle).

### outputs

`[pscustomobject]` Files, Bytes — the measured footprint, also when no limit is stated.

## comment:1

Above `foreach ($file in Get-ChildPath $root -File -Depth 64 -Exclude @()...`, written with `#`.

```text
A named whole-tree walk ([ADR-PWSH-ENUM#3](/docs/adr/pwsh/bounded-enumeration.md#rule-adr-pwsh-enum3)): the
footprint counts every shipped byte, so nothing is pruned.
```
