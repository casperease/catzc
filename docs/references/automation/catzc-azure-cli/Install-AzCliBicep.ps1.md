---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-cli/Install-AzCliBicep.ps1.md
    kind: comment-page
    body_sha: "77a0c7e70157"
    adrs:
      - ADR-AZ-CLI#1
    links: []
---

# automation/Catzc.Azure.Cli/Install-AzCliBicep.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The install companion to Test-AzCliBicep (query) and Assert-AzCliBicep (throw). `az bicep build` needs the
Bicep CLI; this provisions it deterministically instead of relying on az's silent first-use auto-install,
which can fail quietly behind an enterprise proxy or leave a stale version. Idempotent — skips when the
Bicep CLI already meets Get-AzureBicepMinVersion (azure.yml `bicep_min_version`); installs it when absent,
upgrades it when too old. Asserts the az CLI itself first (Assert-Tool 'az_cli'), and confirms the result
meets the minimum before returning. See
[ADR-AZ-CLI#1](/docs/adr/azure/prefer-az-cli.md#rule-adr-az-cli1).
```
