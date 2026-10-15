---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-cli/Test-AzCliBicep.ps1.md
    kind: comment-page
    body_sha: "2c136c24e64d"
    adrs:
      - ADR-AZ-CLI#1
    links: []
---

# automation/Catzc.Azure.Cli/Test-AzCliBicep.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Returns $true when `az bicep version` exits zero and reports a version at or above
Get-AzureBicepMinVersion (azure.yml `bicep_min_version`); $false otherwise (not installed, unparseable,
or too old). A pure query: it never throws. Use Assert-AzCliBicep for the throwing companion (with a
remediation message that distinguishes not-installed from too-old). Both share Get-AzCliBicepState.

Why this exists: `az bicep build` auto-installs the Bicep CLI on first use, and on a machine where
that install is missing, blocked (enterprise proxy/firewall), or stale, the first build can exit zero
while writing no main.json. Probing `az bicep version` first surfaces — and warms — the Bicep CLI, and
enforces a known-good minimum, before a build depends on it.
See [ADR-AZ-CLI#1](/docs/adr/azure/prefer-az-cli.md#rule-adr-az-cli1) and
[ADR-AUTO-ENTERP](/docs/adr/automation/effective-in-enterprises.md).
```
