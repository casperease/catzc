/*
---
catzc:
  derived:
    path: automation/Catzc.Azure.Firewall/types/RuleType.cs
    kind: type
    language: csharp
    filekind: cs
    track: automation
    module: Catzc.Azure.Firewall
    relatives:
      page: docs/references/automation/catzc-azure-firewall/types/RuleType.cs.md
---
*/

namespace Catzc.Azure.Firewall;

public enum RuleType
{
    // Application rule collection (FQDN / protocol rules).
    Application,

    // Network rule collection (IP / port rules).
    Network
}
