/*
---
catzc:
  immutable:
    with_body_sha: c473fc835541
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
