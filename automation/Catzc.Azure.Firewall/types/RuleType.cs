/*
---
catzc:
  derived:
    path: automation/Catzc.Azure.Firewall/types/RuleType.cs
    folder: types
    name: rule-type
    filetype: cs
    kind: type
    language: csharp
    track: automation
    module: Catzc.Azure.Firewall
    moduletype: pwsh-folder
    catzc_bundle: azure
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
