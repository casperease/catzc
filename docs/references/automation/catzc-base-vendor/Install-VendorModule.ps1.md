---
catzc:
  derived:
    path: docs/references/automation/catzc-base-vendor/Install-VendorModule.ps1.md
    kind: comment-page
    body_sha: f3201ea9cdee
    adrs:
      - ADR-PWSH-VENDOR#7
    links: []
---

# automation/Catzc.Base.Vendor/Install-VendorModule.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Downloads with Save-PSResource from the vendor source (configs/vendor.yml — PSGallery by default, or a
custom feed) into automation/.vendor/<Name>/<Version>/, then removes folders the toolset never loads
(legacy .NET Framework builds, PSScriptAnalyzer's compatibility_profiles). The only supported way to add a vendor module
([ADR-PWSH-VENDOR](/docs/adr/pwsh/vendor-toolset-dependencies.md)); commit the result.
Must be run in a fresh session — a loaded module may lock its files. Writes into the source tree's
.vendor, so it stops with a named error in build mode (Assert-SourceTree,
[ADR-DSGN-RUNMODE](/docs/adr/design/run-modes.md)).
```

## comment:2

Above `$moduleDir = Join-Path $vendorRoot $Name`.

```text
Prune folders the toolset never loads: legacy .NET Framework builds (we only target PS 7+ / .NET 6+) and
PSScriptAnalyzer's ~280 MB compatibility_profiles, read only by the PSUseCompatible* rules that
PSScriptAnalyzerSettings.psd1 keeps off
([ADR-PWSH-VENDOR#7](/docs/adr/pwsh/vendor-toolset-dependencies.md#rule-adr-pwsh-vendor7)).
```
