---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-CONF-MDCONTRIB-GATHEREDINSIDEREADER
      - ADR-CONF-ADDRESSING-GLOBALADDRESSFORM
---

# One reader merges contributions key by key and a global address names one node

This article is one rule:
[ADR-CONF-MDCONTRIB-GATHEREDINSIDEREADER](../../drs/configuration/markdown-config-contributions.md#rule-adr-conf-mdcontrib-gatheredinsidereader)
and [ADR-CONF-ADDRESSING-GLOBALADDRESSFORM](../../drs/configuration/config-value-addressing.md#rule-adr-conf-addressing-globaladdressform)
merged into one. It holds nothing beyond what those two rules say.

Contributions are gathered inside the one reader, never beside it: `Get-Config` merges them key by key with the same merge an overlay
fragment uses, so one mechanism joins every source. A global config address, `global.<config>.<key>[.<key>…]`, names exactly one node inside
a named config, a leaf value or a subtree, and is resolved by `Get-ConfigValue`, built on `Get-Config`, so there is exactly one config
reader and one config cache.
