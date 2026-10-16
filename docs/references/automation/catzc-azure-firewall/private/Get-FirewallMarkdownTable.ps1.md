---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-firewall/private/Get-FirewallMarkdownTable.ps1.md
    kind: comment-page
    generator: automation/Catzc.Base.QualityGates/Export-Comments.ps1
    body_sha: fc9d82aa260d
---

# automation/Catzc.Azure.Firewall/private/Get-FirewallMarkdownTable.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## comment:1

Above `$protocols = @()`, written with `#`.

```text
Pair protocols with ports as "protocols:ports" (e.g. TCP/UDP:53, 8053). App rules
carry the port inside Protocols already and have no port field, so they pass through.
```

## comment:2

Above `$values = foreach ($candidate in $column.Candidates) {`, written with `#`.

```text
Gather values per candidate, preserving candidate (group) order. A rule can populate
more than one candidate (e.g. IP groups and addresses); the firewall unions them.
For sorted composites this gives two-level ordering: by group, then sorted within group.
```

## comment:3

Above `if ($cell -match...`, written with `#`.

```text
Wrap a cell in backticks when Markdown would mangle it:
 - * or _ at a whitespace boundary (cell start/end count, since "| value |" pads with spaces)
   -> emphasis. Intra-word _ (Allow_Web) is safe and stays clean.
 - a URL scheme or a domain.tld shape -> markdownlint MD034 (bare URL) and auto-linking.
   Covers FQDNs/wildcards/www; IPs, CIDRs, ports, tags, and categories don't match.
A code span is exactly MD034's recommended fix for a bare URL.
```
