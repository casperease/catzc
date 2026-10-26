# pwsh/Catzc.Azure.Firewall/Get-FirewallIpgsYaml.ps1

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading.

## help

### synopsis

Enumerates the IP Groups across one or more (subscription, resource group) targets into a single YAML.

### description

Takes (subscription, resource group) targets from the pipeline and aggregates them into one YAML document with two root nodes: 'sources',
declaring each source once (keyed by resource group name, holding its subscription), and 'ipgs', mapping each IP Group name to its source
(the resource group name) and its sorted address prefixes (CIDRs, single IPs, or ranges). Declaring each source once keeps the shared
subscription/RG off every entry, and a single document can hold many sources.

Targets are taken from the pipeline by property name, so a set spanning multiple subscriptions can be piped in at once and collected into
one file:

```text
@(
    [pscustomobject]@{ SubscriptionId = $subA; ResourceGroupName = 'rg-fw-a' }
    [pscustomobject]@{ SubscriptionId = $subB; ResourceGroupName = 'rg-fw-b' }
) | Get-FirewallIpgsYaml
```

Each subscription is targeted explicitly with --subscription; the active CLI subscription is never switched, so this composes across
subscriptions without Invoke-InSubscription. The begin block asserts once that the ip-group extension is installed (Assert-AzCliExtension);
per-target failures (including a missing session) and empty resource groups throw with remediation. This is a management-plane read, so the
identity needs Reader on each resource group.

Source names are resource group names, so they must be unique across the targets piped in one run; two targets sharing a resource group name
(in different subscriptions) collide and throw, as do two IP Groups sharing a name across sources. Groups and sources are emitted sorted by
name; addresses are sorted numerically by their first IP, falling back to a lexical sort for anything that doesn't parse.

The file opens with a comment header (counts, retrieval time in UTC); being YAML comments they're ignored by parsers. The single combined
file's path is emitted.

### parameter `SubscriptionId`

A target subscription GUID. Passed explicitly to az, never switched. Bound from the pipeline by property name.

### parameter `ResourceGroupName`

A target resource group whose IP Groups are enumerated; also used as the source name. Bound from the pipeline by property name.

### parameter `YamlPath`

Output YAML path for the combined document. Defaults to `<repo-root>/out/yaml/ipgs.yaml`.

### example 1

```powershell
Get-FirewallIpgsYaml -SubscriptionId 50a0ed00-de00-50b0-0000-000000000000 -ResourceGroupName rg-firewall
```

### example 2

```powershell
@(
    [pscustomobject]@{ SubscriptionId = $subA; ResourceGroupName = 'rg-fw-a' }
    [pscustomobject]@{ SubscriptionId = $subB; ResourceGroupName = 'rg-fw-b' }
) | Get-FirewallIpgsYaml -YamlPath .\docs\ipgs.yaml
```

## comment:1

Above `Assert-AzCliExtension 'ip-group'`, written with `#`.

```text
Assert once that the ip-group extension is present (fail fast with remediation instead of an
exit-2 / hang). No connection assert: each target is hit explicitly with --subscription, so
there's no single active subscription to assert; a missing session surfaces on the first call.
```

## comment:2

Above `$addressSortKey = {`, written with `#`.

```text
Numeric sort key from an address's first IP (handles CIDR a.b.c.d/p, range a-b, or a single IP);
pad each byte to 3 digits so a string sort orders numerically. Unparseable -> lexical fallback.
```

## comment:3

Above `if ($allSources.Contains($ResourceGroupName)) {`, written with `#`.

```text
Register this target's source once (keyed by RG name). Two targets sharing an RG name but pointing
at different subscriptions would collide on the source key — surface that rather than overwrite.
```

## comment:4

Above `if ($allIpgs.Contains($g.name)) {`, written with `#`.

```text
IP Group names are unique within a source but not necessarily across sources — guard the
shared 'ipgs' map so one source's group can't silently overwrite another's.
```

## comment:5

Above `Assert-AzCliExtension 'ip-group'`, written with `#`.

```text
The extension is asserted once, but no connection: each target names its own subscription, so a missing
session fails its call.
```

## comment:6

Above `$addressSortKey = {`, written with `#`.

```text
Each byte padded to three digits, so a string sort of addresses is a numeric one; an unparseable address sorts
as text.
```

## comment:7

Above `if ($allSources.Contains($ResourceGroupName)) {`, written with `#`.

```text
Sources are keyed by resource group, so two targets that share one across subscriptions collide loudly instead
of overwriting.
```

## comment:8

Above `if ($allIpgs.Contains($g.name)) {`, written with `#`.

```text
Group names are unique within one source only, so a clash across sources is surfaced and never silently
replaced.
```
