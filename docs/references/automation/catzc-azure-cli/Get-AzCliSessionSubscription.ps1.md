---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-cli/Get-AzCliSessionSubscription.ps1.md
    kind: reference
    body_sha: "082de7a37152"
    adrs: []
---

# automation/Catzc.Azure.Cli/Get-AzCliSessionSubscription.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The reverse lookup that makes the session the deploy-target selector: reads the active subscription
(Get-CurrentAzSubscription — in a pipeline, exactly what the service connection logged into), finds
the azure.yml subscription with that GUID, and returns the declared identity. Read-only — it never
logs in or switches context (verify is not connect,
[ADR-AZ-SESSION](/docs/adr/azure/az-session-verification.md));
config defines correct, so a session pointed at a subscription azure.yml does not declare is an
error, not a fallback.
```
