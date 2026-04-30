// A resolved environment identity: a named deployment environment paired with the subscription that
// serves it. The root of the identity graph (AzureEnvironment → AzureSubscription → Tenant). The name and
// short codes compose Azure resource names per the naming standard. Mirrors an `environments` entry in
// configs/azure.yml (joined to its serving subscription), so the property names are the YAML keys.

using System;

namespace Catzc.Azure;

public sealed class AzureEnvironment
{
    // Logical environment name — the azure.yml `environments` map key. Always present.
    public string           name         { get; }

    // Short environment code that composes into resource names (e.g. azure.yml shortcode `al`). Always present.
    public string           shortcode    { get; }

    // Azure region the environment deploys to (e.g. `westeurope`). Always present.
    public string           region       { get; }

    // Short region code that composes into resource names (e.g. `weu`). Always present.
    public string           region_code  { get; }

    // The subscription that serves this environment; its `customer` renders into resource names. Always present.
    public AzureSubscription subscription { get; }

    public AzureEnvironment(string name, string shortcode, string region, string region_code, AzureSubscription subscription)
    {
        if (string.IsNullOrWhiteSpace(name))        { throw new ArgumentException("AzureEnvironment.name is required"); }
        if (string.IsNullOrWhiteSpace(shortcode))   { throw new ArgumentException("AzureEnvironment.shortcode is required"); }
        if (string.IsNullOrWhiteSpace(region))      { throw new ArgumentException("AzureEnvironment.region is required"); }
        if (string.IsNullOrWhiteSpace(region_code)) { throw new ArgumentException("AzureEnvironment.region_code is required"); }

        this.name         = name;
        this.shortcode    = shortcode;
        this.region       = region;
        this.region_code  = region_code;
        this.subscription = subscription ?? throw new ArgumentException("AzureEnvironment.subscription is required");
    }
}
