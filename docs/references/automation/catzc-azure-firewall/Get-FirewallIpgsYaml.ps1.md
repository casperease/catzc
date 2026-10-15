---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-firewall/Get-FirewallIpgsYaml.ps1.md
    kind: comment-page
    body_sha: "4f09565b83f2"
---

# automation/Catzc.Azure.Firewall/Get-FirewallIpgsYaml.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:8

Above `Assert-AzCliExtension 'ip-group'`.

```text
Assert once that the ip-group extension is present (fail fast with remediation instead of an
exit-2 / hang). No connection assert: each target is hit explicitly with --subscription, so
there's no single active subscription to assert; a missing session surfaces on the first call.
```

## comment:9

Above `$addressSortKey = {`.

```text
Numeric sort key from an address's first IP (handles CIDR a.b.c.d/p, range a-b, or a single IP);
pad each byte to 3 digits so a string sort orders numerically. Unparseable -> lexical fallback.
```

## comment:10

Above `if ($allSources.Contains($ResourceGroupName)) {`.

```text
Register this target's source once (keyed by RG name). Two targets sharing an RG name but pointing
at different subscriptions would collide on the source key — surface that rather than overwrite.
```

## comment:11

Above `if ($allIpgs.Contains($g.name)) {`.

```text
IP Group names are unique within a source but not necessarily across sources — guard the
shared 'ipgs' map so one source's group can't silently overwrite another's.
```
