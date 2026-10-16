---
catzc:
  immutable:
    with_body_sha: d260d5b2df4e
    path: docs/references/automation/catzc-base-vendor/Install-VendorModule.ps1.md
    folder: docs/references/automation/catzc-base-vendor
    name: install-vendor-module-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    tracktype: documentation
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
  edges:
    cites:
      - ADR-PWSH-VENDOR#7
---

# automation/Catzc.Base.Vendor/Install-VendorModule.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$moduleDir = Join-Path $vendorRoot $Name`, written with `#`.

```text
Prune folders the toolset never loads: legacy .NET Framework builds (we only target PS 7+ / .NET 6+) and
PSScriptAnalyzer's ~280 MB compatibility_profiles, read only by the PSUseCompatible* rules that
PSScriptAnalyzerSettings.psd1 keeps off
([ADR-PWSH-VENDOR#7](/docs/adr/pwsh/vendor-toolset-dependencies.md#rule-adr-pwsh-vendor7)).
```
