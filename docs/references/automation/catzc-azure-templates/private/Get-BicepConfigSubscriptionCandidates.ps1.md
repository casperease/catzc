---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-templates/private/Get-BicepConfigSubscriptionCandidates.ps1.md
    kind: comment-page
    body_sha: "7645727ebcd6"
    adrs: []
    links: []
---

# automation/Catzc.Azure.Templates/private/Get-BicepConfigSubscriptionCandidates.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The single implementation of the configuration-tree resolution rule
([ADR-AZ-DATAMOD](/docs/adr/azure/azure-data-model.md)): a config at the configuration/ ROOT (empty -Customer) is
served by
the NON-customer subscriptions serving its environment; a config under configuration/<customer>/ is
served by that customer's subscriptions serving it (the subscription's raw customer token — key or
shortcode — is normalized against the folder's customer key). A conforming azure.yml yields exactly
one candidate; callers assert that (Get-BicepSubscriptionConfigViolations for the violation text,
discovery for the resolved name) so the rule cannot drift between them.
```

## comment:2

Above `if ($token -ceq $Customer -or (Get-AzureCustomer $token).key -ceq $Customer) {`.

```text
Customer config: match the raw token first (the common, by-key binding), and only resolve a
non-matching token through the catalogue (the by-shortcode binding) — keeps the read lazy.
```
