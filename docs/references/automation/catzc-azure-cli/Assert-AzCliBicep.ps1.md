---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-cli/Assert-AzCliBicep.ps1.md
    kind: comment-page
    body_sha: ce46b5163f8b
    adrs:
      - ADR-AZ-CLI#1
---

# automation/Catzc.Azure.Cli/Assert-AzCliBicep.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The throwing companion to Test-AzCliBicep. Throws a remediation-bearing error when the Bicep CLI that
`az bicep build` needs is missing or below Get-AzureBicepMinVersion (azure.yml `bicep_min_version`),
distinguishing the two cases: not installed -> `az bicep install`; too old -> `az bicep upgrade`.
Asserting it before a build turns the silent "az bicep build exits 0 but writes no main.json" failure
into a clear, early error at the source. It first asserts the az CLI itself is installed at the
locked version (Assert-Tool 'az_cli'), then checks the Bicep CLI. Both share Get-AzCliBicepState.
See [ADR-AZ-CLI#1](/docs/adr/azure/prefer-az-cli.md#rule-adr-az-cli1) and
[ADR-AUTO-ENTERP](/docs/adr/automation/effective-in-enterprises.md).
```
