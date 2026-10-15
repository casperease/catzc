/*
---
catzc:
  derived:
    path: automation/Catzc.Azure.Firewall/types/RuleType.cs
    kind: csharp-type
    module: Catzc.Azure.Firewall
    adrs: []
---
*/

// Parsed case-insensitively from the lowercase words the firewall tooling uses, application and network.
// [comment:1](/docs/references/automation/catzc-azure-firewall/types/RuleType.cs.md#comment1)

namespace Catzc.Azure.Firewall;

public enum RuleType
{
    // Application rule collection (FQDN / protocol rules).
    Application,

    // Network rule collection (IP / port rules).
    Network
}
