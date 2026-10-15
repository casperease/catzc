---
catzc:
  derived:
    path: docs/references/automation/catzc-azure-firewall/Get-FirewallIpgsYaml.ps1.md
    kind: comment-page
    body_sha: f6eeeed5ac18
---

# automation/Catzc.Azure.Firewall/Get-FirewallIpgsYaml.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. The file keeps one line and a link per section
(Export-Comments), and Build-CommentView puts them back for reading.

## comment:1

Section `.DESCRIPTION` of the comment-based help.

```text
Takes (subscription, resource group) targets from the pipeline and aggregates them into one YAML
document with two root nodes: 'sources', declaring each source once (keyed by resource group name,
holding its subscription), and 'ipgs', mapping each IP Group name to its source (the resource group
name) and its sorted address prefixes (CIDRs, single IPs, or ranges). Declaring each source once keeps
the shared subscription/RG off every entry, and a single document can hold many sources.

Targets are taken from the pipeline by property name, so a set spanning multiple subscriptions can be
piped in at once and collected into one file:

    @(
        [pscustomobject]@{ SubscriptionId = $subA; ResourceGroupName = 'rg-fw-a' }
        [pscustomobject]@{ SubscriptionId = $subB; ResourceGroupName = 'rg-fw-b' }
    ) | Get-FirewallIpgsYaml

Each subscription is targeted explicitly with --subscription; the active CLI subscription is never
switched, so this composes across subscriptions without Invoke-InSubscription. The begin block asserts
once that the ip-group extension is installed (Assert-AzCliExtension); per-target failures (including a
missing session) and empty resource groups throw with remediation. This is a management-plane read, so
the identity needs Reader on each resource group.

Source names are resource group names, so they must be unique across the targets piped in one run; two
targets sharing a resource group name (in different subscriptions) collide and throw, as do two IP
Groups sharing a name across sources. Groups and sources are emitted sorted by name; addresses are
sorted numerically by their first IP, falling back to a lexical sort for anything that doesn't parse.

The file opens with a comment header (counts, retrieval time in UTC); being YAML comments they're
ignored by parsers. The single combined file's path is emitted.
```

## comment:2

Section `.PARAMETER SubscriptionId` of the comment-based help.

```text
A target subscription GUID. Passed explicitly to az, never switched. Bound from the pipeline by
property name.
```

## comment:3

Section `.PARAMETER ResourceGroupName` of the comment-based help.

```text
A target resource group whose IP Groups are enumerated; also used as the source name. Bound from the
pipeline by property name.
```

## comment:4

Above `Assert-AzCliExtension 'ip-group'`.

```text
Assert once that the ip-group extension is present (fail fast with remediation instead of an
exit-2 / hang). No connection assert: each target is hit explicitly with --subscription, so
there's no single active subscription to assert; a missing session surfaces on the first call.
```

## comment:5

Above `$addressSortKey = {`.

```text
Numeric sort key from an address's first IP (handles CIDR a.b.c.d/p, range a-b, or a single IP);
pad each byte to 3 digits so a string sort orders numerically. Unparseable -> lexical fallback.
```

## comment:6

Above `if ($allSources.Contains($ResourceGroupName)) {`.

```text
Register this target's source once (keyed by RG name). Two targets sharing an RG name but pointing
at different subscriptions would collide on the source key — surface that rather than overwrite.
```

## comment:7

Above `if ($allIpgs.Contains($g.name)) {`.

```text
IP Group names are unique within a source but not necessarily across sources — guard the
shared 'ipgs' map so one source's group can't silently overwrite another's.
```

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
