---
catzc:
  derived:
    path: docs/references/automation/catzc-azure/Get-AzureSubscriptionEnvironment.ps1.md
    kind: comment-page
    body_sha: ef912ccf0ff4
    adrs: []
---

# automation/Catzc.Azure/Get-AzureSubscriptionEnvironment.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Each subscription carries exactly one per-subscription env (nsub or psub — see
[ADR-AZ-DATAMOD](/docs/adr/azure/azure-data-model.md)), the identity env that environment_kind:subscription
templates deploy
once-per-subscription. This returns it for a named subscription, so an environment_kind:standard
template can locate the once-per-subscription foundation (and its Key Vault) that lives in the same
subscription.
```
