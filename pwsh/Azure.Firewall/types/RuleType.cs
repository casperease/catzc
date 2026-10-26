namespace Catzc.Azure.Firewall;

// Parsed case-insensitively and written back lowercase, so it matches the firewall's own spelling of a rule kind both ways.
public enum RuleType
{
    // Application rule collection (FQDN / protocol rules).
    Application,

    // Network rule collection (IP / port rules).
    Network
}
