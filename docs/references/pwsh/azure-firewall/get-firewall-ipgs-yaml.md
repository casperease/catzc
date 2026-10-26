# pwsh/Azure.Firewall/Get-FirewallIpgsYaml.ps1

The command that enumerates the IP Groups across one or more subscription and resource group targets and writes them as one combined YAML
document, sorted by name so the output is stable whatever order the targets arrive in.

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

## What is asserted

The function asserts the `ip-group` extension once, failing fast with a remediation instead of an exit-2 or a hang. It asserts no
connection: each target is hit explicitly with `--subscription`, so there is no single active subscription to assert, and a missing session
fails the first call.

## Address order

Addresses sort by a numeric key taken from an address's first IP, which may be a CIDR (`a.b.c.d/p`), a range (`a-b`) or a single IP. Each
byte is padded to three digits, so a string sort of the keys is a numeric one. An unparseable address sorts as text.

## Collisions

A target's source is registered once, keyed by resource group name. Two targets that share a resource group name across subscriptions would
collide on that key, so the function surfaces the clash instead of overwriting.

IP Group names are unique within one source but not necessarily across sources. The shared `ipgs` map is guarded, so one source's group
never silently overwrites another's.
