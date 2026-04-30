// The kind of Azure Firewall rule collection an export covers. Parsed case-insensitively from, and
// compared back against, the lowercase forms `application` / `network` that the firewall tooling uses.

namespace Catzc.Azure.Firewall;

public enum RuleType
{
    // Application rule collection (FQDN / protocol rules).
    Application,

    // Network rule collection (IP / port rules).
    Network
}
