---
catzc:
  derived:
    path: docs/references/automation/catzc-base-config/private/Resolve-ConfigKeyPath.ps1.md
    kind: comment-page
    body_sha: "63b3200a242a"
    adrs:
      - ADR-CONF-ADDRESSING#2
      - ADR-CONF-ADDRESSING#4
      - ADR-CONF-ADDRESSING#5
    links: []
---

# automation/Catzc.Base.Config/private/Resolve-ConfigKeyPath.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
The traversal seam behind Get-ConfigValue (see ADR config-value-addressing). Given a config node — a raw
ordered dictionary or a typed/validated object returned by Get-Config — and an ordered list of key
segments, it walks one segment at a time and returns the node reached (a leaf value or a subtree).

Each segment resolves as a dictionary key when the current node is an IDictionary, otherwise as a property
on the node (so a typed C# config object and a raw dictionary traverse the same way,
[ADR-CONF-ADDRESSING#2](/docs/adr/configuration/config-value-addressing.md#rule-adr-conf-addressing2)). Any segment
that resolves at neither throws, naming the full address and the failing segment
([ADR-CONF-ADDRESSING#4](/docs/adr/configuration/config-value-addressing.md#rule-adr-conf-addressing4)) — there is
no
silent $null. An empty segment list returns the node unchanged (addressing the whole config).

The returned node may be a live reference into the config cache and must be treated as read-only
([ADR-CONF-ADDRESSING#5](/docs/adr/configuration/config-value-addressing.md#rule-adr-conf-addressing5)).
```
