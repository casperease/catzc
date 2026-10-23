---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-AZ-WAF-SE-SE09
      - ADR-AZ-DATAMOD-VALUEBYADDRESS
---

# The repository holds no secret and a value may be named by config address

This article is one rule: [ADR-AZ-WAF-SE-SE09](../../drs/azure/waf/security.md#rule-adr-az-waf-se-se09) and
[ADR-AZ-DATAMOD-VALUEBYADDRESS](../../drs/azure/azure-data-model.md#rule-adr-az-datamod-valuebyaddress) merged into one. It holds nothing
beyond what those two rules say.

The repository holds no secret: a secure parameter is a Key Vault reference to `foundation`'s vault, a config address never carries a
secret, and services authenticate as managed identities; automated rotation is planned. A template config parameter may name its value by
config address, `{ address: global.<config>.<key>… }`, instead of a literal `value` or a Key Vault `reference`, and the build resolves it
through `Get-ConfigValue`.
