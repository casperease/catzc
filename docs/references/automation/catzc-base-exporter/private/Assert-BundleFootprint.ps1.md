---
catzc:
  derived:
    path: docs/references/automation/catzc-base-exporter/private/Assert-BundleFootprint.ps1.md
    folder: docs/references/automation/catzc-base-exporter/private
    name: assert-bundle-footprint-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: "04bd70cf9a20"
    adrs:
      - ADR-PWSH-ENUM#3
---

# automation/Catzc.Base.Exporter/private/Assert-BundleFootprint.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `foreach ($file in Get-ChildPath $root -File -Depth 64 -Exclude @()...`, written with `#`.

```text
A named whole-tree walk ([ADR-PWSH-ENUM#3](/docs/adr/pwsh/bounded-enumeration.md#rule-adr-pwsh-enum3)): the
footprint counts every shipped byte, so nothing is pruned.
```
