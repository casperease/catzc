---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-templates/Get-AzureResourceName.ps1.md
    kind: comment-page
    body_sha: "38b78b34a9bc"
    adrs:
      - ADR-AZ-NAMING#4
      - ADR-AZ-NAMING#6
---

# automation/Catzc.Azure.Templates/Get-AzureResourceName.ps1

<!-- cspell:ignore weuzctsmplst -->

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:8

Above `$omit = if ($specification.Contains('omit')) {`.

```text
A type may omit components from its render — e.g. the Windows `vm` (15-char cap) drops
org/customer/role, which the resource group already encodes (see
[ADR-AZ-NAMING](/docs/adr/azure/azure-naming-standard.md)). The `type`
segment is never omitted.
```

## comment:9

Above `$envValue = if ($specification.pattern -eq 'long') {`.

```text
The env-segment is the readable name for the generous `long` pattern, the 2-char shortcode for
the restricted patterns (kv/storage/vm) — see
[ADR-AZ-NAMING#4](/docs/adr/azure/azure-naming-standard.md#rule-adr-az-naming4).
```

## comment:10

Above `$customerValue = ''`.

```text
Customer follows the same pattern-chosen split as env: the readable key (-Customer) for the
generous `long` pattern, the 2-char shortcode (-CustomerShortcode) for the restricted patterns.
Only applies when a customer is given (the segment is optional).
```

## comment:11

Above `$checks = [ordered]@{`.

```text
Component format checks (case-sensitive, lowercase) — see
[ADR-AZ-NAMING#6](/docs/adr/azure/azure-naming-standard.md#rule-adr-az-naming6).
```
