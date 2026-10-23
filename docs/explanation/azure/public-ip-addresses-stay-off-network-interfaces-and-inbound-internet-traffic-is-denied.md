---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-AZ-WAF-SE-SE06
      - ADR-AZ-CAF-NETCON-EXPOSENOVIRTUALMACHINEMANAGEMENTPORTINTERNET
---

# Public ip addresses stay off network interfaces and inbound internet traffic is denied

This article is one rule: [ADR-AZ-WAF-SE-SE06](../../drs/azure/waf/security.md#rule-adr-az-waf-se-se06) and
[ADR-AZ-CAF-NETCON-EXPOSENOVIRTUALMACHINEMANAGEMENTPORTINTERNET](../../drs/azure/caf/network-connectivity.md#rule-adr-az-caf-netcon-exposenovirtualmachinemanagementportinternet)
merged into one. It holds nothing beyond what those two rules say.

Data services have public network access off and are reached only through private endpoints, inbound internet traffic is denied at every
workload subnet and no network interface takes a public IP address. Exposing no virtual machine management port to the internet is partly
realised on those same terms: every workload subnet denies inbound internet traffic and the landing zone's policy keeps public IP addresses
off network interfaces, but the unused `vm.bicep` creates one and is planned to lose it.
