---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-templates/Get-AzureResourceName.ps1.md
    folder: docs/references/automation/catzc-azure-templates
    name: get-azure-resource-name-ps1
    filetype: md
    kind: comment-page
    language: markdown
    track: docs
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: d42f84b1340a
    adrs:
      - ADR-AZ-NAMING#{4,6}
---

# automation/Catzc.Azure.Templates/Get-AzureResourceName.ps1

<!-- cspell:ignore weuzctsmplst -->

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$omit = if ($specification.Contains('omit')) {`, written with `#`.

```text
A type may omit components from its render — e.g. the Windows `vm` (15-char cap) drops
org/customer/role, which the resource group already encodes (see
[ADR-AZ-NAMING](/docs/adr/azure/azure-naming-standard.md)). The `type`
segment is never omitted.
```

## comment:2

Above `$envValue = if ($specification.pattern -eq 'long') {`, written with `#`.

```text
The env-segment is the readable name for the generous `long` pattern, the 2-char shortcode for
the restricted patterns (kv/storage/vm) — see
[ADR-AZ-NAMING#4](/docs/adr/azure/azure-naming-standard.md#rule-adr-az-naming4).
```

## comment:3

Above `$customerValue = ''`, written with `#`.

```text
Customer follows the same pattern-chosen split as env: the readable key (-Customer) for the
generous `long` pattern, the 2-char shortcode (-CustomerShortcode) for the restricted patterns.
Only applies when a customer is given (the segment is optional).
```

## comment:4

Above `$checks = [ordered]@{`, written with `#`.

```text
Component format checks (case-sensitive, lowercase) — see
[ADR-AZ-NAMING#6](/docs/adr/azure/azure-naming-standard.md#rule-adr-az-naming6).
```
