---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-templates/Get-AzureResourceName.ps1.md
    kind: comment-page
    body_sha: "5c7a2ac5b8e3"
    adrs:
      - ADR-AZ-NAMING#4
      - ADR-AZ-NAMING#6
---

# automation/Catzc.Azure.Templates/Get-AzureResourceName.ps1

<!-- cspell:ignore weuzctsmplst -->

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Resolves the component VALUES (env, slot, region, org, short_name, [customer], [role], type) and
arranges them per the selected order from Get-AzureNameOrderSet:

  standard — <env>-<slot>-<region>-<org>-<short_name>[-<customer>][-<role>]-<type>
  classic  — <type>-<org>-<short_name>[-<customer>]-<env>-<region>[-<slot>][-<role>]

The env-segment value is chosen by the type's pattern: generous (`long`) types render the readable
env NAME (-Env); restricted (`kv`/`storage`/`vm`) types render the 2-char SHORTCODE (-Shortcode),
so a long name never costs a tight name a byte. `env` and `slot` are separate segments; segments
are joined by the pattern's render separator (a hyphen for `long`/`kv`, nothing for `storage`/`vm`
— Get-AzureNamePatternSet). Every component is format-validated (case-sensitive, lowercase). The
assembled name is asserted against the type's limit; on overflow it throws, naming the components
to shorten. Names are deterministic — no random suffixes.
```

## comment:2

Section `.PARAMETER Shortcode` of the comment-based help.

```text
2-letter environment shortcode (azure.yml env `shortcode`, e.g. `de`). The env-segment of the
restricted patterns; required when Type is restricted.
```

## comment:3

Section `.PARAMETER CustomerShortcode` of the comment-based help.

```text
2-letter customer shortcode (azure.yml customer `shortcode`). The customer-segment of the restricted
patterns; required when both -Customer is set and Type is restricted.
```

## comment:4

Above `$omit = if ($specification.Contains('omit')) {`.

```text
A type may omit components from its render — e.g. the Windows `vm` (15-char cap) drops
org/customer/role, which the resource group already encodes (see
[ADR-AZ-NAMING](/docs/adr/azure/azure-naming-standard.md)). The `type`
segment is never omitted.
```

## comment:5

Above `$envValue = if ($specification.pattern -eq 'long') {`.

```text
The env-segment is the readable name for the generous `long` pattern, the 2-char shortcode for
the restricted patterns (kv/storage/vm) — see
[ADR-AZ-NAMING#4](/docs/adr/azure/azure-naming-standard.md#rule-adr-az-naming4).
```

## comment:6

Above `$customerValue = ''`.

```text
Customer follows the same pattern-chosen split as env: the readable key (-Customer) for the
generous `long` pattern, the 2-char shortcode (-CustomerShortcode) for the restricted patterns.
Only applies when a customer is given (the segment is optional).
```

## comment:7

Above `$checks = [ordered]@{`.

```text
Component format checks (case-sensitive, lowercase) — see
[ADR-AZ-NAMING#6](/docs/adr/azure/azure-naming-standard.md#rule-adr-az-naming6).
```

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
