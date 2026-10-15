// The kind of Azure Firewall rule collection an export covers.
// [comment:1](/docs/references/automation/catzc-azure-firewall/types/RuleType.cs.md#comment1)

namespace Catzc.Azure.Firewall;

public enum RuleType
{
    // Application rule collection (FQDN / protocol rules).
    Application,

    // Network rule collection (IP / port rules).
    Network
}
