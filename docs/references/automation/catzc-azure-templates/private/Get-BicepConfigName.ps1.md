---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-templates/private/Get-BicepConfigName.ps1.md
    kind: reference
    body_sha: "9cf3ab93d712"
    adrs:
      - ADR-AZ-DATAMOD#2
---

# automation/Catzc.Azure.Templates/private/Get-BicepConfigName.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The config-name is `<environment>` for the base / index-0 slot, or `<environment>-<slot>` for a
special slot. It names the config file (`<config>.yml`), the build artifact
(`parameters.<config>.json`), and is 1:1 with the resource group. The inverse (parse) is
Resolve-BicepConfigName. See [ADR-AZ-DATAMOD#2](/docs/adr/azure/azure-data-model.md#rule-adr-az-datamod2).
```
