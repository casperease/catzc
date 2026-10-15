---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-cli/Assert-AzCliSubscriptionAccessible.ps1.md
    kind: comment-page
    body_sha: "03b4d9c7df18"
    adrs:
      - ADR-AZ-CLI#1
    links: []
---

# automation/Catzc.Azure.Cli/Assert-AzCliSubscriptionAccessible.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The throwing companion to Test-AzCliSubscriptionAccessible. Throws a remediation-bearing error when
az is not logged in, or is logged in but cannot reach the subscription passed by argument. Drop it
at the top of any function that is about to call az against a subscription — whether that
subscription is the active one or supplied via `--subscription <id>` — to fail fast with a clear
message instead of deep inside the later call.

The check is a real, read-only ARM call (see Get-AzCliSubscriptionAccessState), so a pass proves
the later call will actually reach ARM, not merely that the subscription is in the local profile.
The generic, azure.yml-free primitive. Both Assert/Test share Get-AzCliSubscriptionAccessState.
See [ADR-AZ-CLI#1](/docs/adr/azure/prefer-az-cli.md#rule-adr-az-cli1) and
[ADR-AUTO-FAILFAST](/docs/adr/automation/fail-fast-with-asserts.md).
```
