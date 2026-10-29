# pwsh/Azure/types/NetworkFirewallEgress.cs

The comments of the file that outgrew one line, one section per comment, verbatim. A section names the code line its comment sat above
(Export-Comments), and Build-CommentView puts every comment back there for reading. Prose written above the first section survives every
later export.

## comment:1

Above `public sealed class NetworkFirewallEgress : Catzc.Base.Objects.DictionaryRecord`, written with `//`.

```text
The egress every hub firewall allows from the spoke workload subnets, one rule set for both tiers: service tags in network rules and
FQDN tags in application rules, so no rule leans on the DNS proxy that only Standard runs. Everything else is denied.
```

## comment:2

Above `public IReadOnlyDictionary<string, string> service_tag_regions { get; }`, written with `//`.

```text
The tag name of each Azure region, as the service-tag list spells it (westeurope is WestEurope), so a regional tag is emitted in the
documented casing rather than the location's.
```
