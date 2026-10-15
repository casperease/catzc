---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-templates/private/Resolve-BicepConfigName.ps1.md
    kind: comment-page
    body_sha: "49eb6a96bd31"
    adrs:
      - ADR-AZ-DATAMOD#2
    links: []
---

# automation/Catzc.Azure.Templates/private/Resolve-BicepConfigName.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The inverse of Get-BicepConfigName. A config-name is `<environment>[-<slot>]`; env names contain
no hyphen, so splitting on the FIRST `-` cleanly separates them: the part before is the
environment (must be defined in azure.yml), the remainder is the optional slot (1-3 lowercase
alphanumeric, empty for the base slot). Used at discovery to map config filenames back to envs.
See [ADR-AZ-DATAMOD#2](/docs/adr/azure/azure-data-model.md#rule-adr-az-datamod2).
```
