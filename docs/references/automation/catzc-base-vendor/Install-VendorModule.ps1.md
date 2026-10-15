---
catzc:
  derived:
    path: docs/references/automation/catzc-base-vendor/Install-VendorModule.ps1.md
    kind: comment-page
    body_sha: "8d4f35d6878d"
    adrs:
      - ADR-PWSH-VENDOR#7
---

# automation/Catzc.Base.Vendor/Install-VendorModule.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:3

Above `$moduleDir = Join-Path $vendorRoot $Name`.

```text
Prune folders the toolset never loads: legacy .NET Framework builds (we only target PS 7+ / .NET 6+) and
PSScriptAnalyzer's ~280 MB compatibility_profiles, read only by the PSUseCompatible* rules that
PSScriptAnalyzerSettings.psd1 keeps off
([ADR-PWSH-VENDOR#7](/docs/adr/pwsh/vendor-toolset-dependencies.md#rule-adr-pwsh-vendor7)).
```
