---
catzc:
  warning: "Experimental: this article merges two rules into one and holds nothing beyond what they say"
  edges:
    cites:
      - ADR-AZ-CAF-NETCON-USEVIRTUALNETWORKFLOWLOGS
      - ADR-AZ-CAF-NETTOP-NETWORKWATCHERNETWORKINSIGHTS
---

# No flow log is recorded yet and network monitoring waits for the flow logs

This article is one rule:
[ADR-AZ-CAF-NETCON-USEVIRTUALNETWORKFLOWLOGS](../../drs/azure/caf/network-connectivity.md#rule-adr-az-caf-netcon-usevirtualnetworkflowlogs)
and
[ADR-AZ-CAF-NETTOP-NETWORKWATCHERNETWORKINSIGHTS](../../drs/azure/caf/network-topology.md#rule-adr-az-caf-nettop-networkwatchernetworkinsights)
merged into one. It holds nothing beyond what those two rules say.

Virtual network flow logs are planned, not realised: the network security groups and the virtual networks send their diagnostics to
`foundation`'s workspace, but no flow log is recorded. Network monitoring through Network Watcher arrives with those flow logs, so both wait
on the same follow-up.
