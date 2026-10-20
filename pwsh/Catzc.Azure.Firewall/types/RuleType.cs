/*
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Azure.Firewall/types/RuleType.cs
    folder: types
    name: rule-type
    filetype: cs
    role: type
    language: csharp
    track: pwsh
    tracktype: modules
    module: Catzc.Azure.Firewall
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    docs: "[RuleType.cs.md](docs/references/pwsh/catzc-azure-firewall/types/RuleType.cs.md)"
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
