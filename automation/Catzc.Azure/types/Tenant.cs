// An Entra ID tenant — the directory boundary that owns one or more subscriptions. The leaf of the
// resolved identity graph (Tenant ← AzureSubscription ← AzureEnvironment). Mirrors one entry of the
// `tenants` map in configs/azure.yml, so the property names are the YAML keys verbatim.

using System;

namespace Catzc.Azure;

public sealed class Tenant
{
    // Logical tenant name — the key under the azure.yml `tenants` map. Always present.
    public string name { get; }

    // The Entra directory (tenant) GUID. Always present.
    public string id   { get; }

    public Tenant(string name, string id)
    {
        if (string.IsNullOrWhiteSpace(name)) { throw new ArgumentException("Tenant.name is required"); }
        if (string.IsNullOrWhiteSpace(id))   { throw new ArgumentException("Tenant.id is required"); }
        this.name = name;
        this.id   = id;
    }
}
