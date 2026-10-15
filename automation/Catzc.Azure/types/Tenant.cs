// catzc:
//   path: automation/Catzc.Azure/types/Tenant.cs
//   module: Catzc.Azure

// The leaf of the identity graph, so its property names are the YAML keys verbatim.
// [comment:1](/docs/references/automation/catzc-azure/types/Tenant.cs.md#comment1)

using System;

namespace Catzc.Azure;

public sealed class Tenant
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    // Logical tenant name — the key under the azure.yml `tenants` map. Always present.
    public string name { get; }

    // The Entra directory (tenant) GUID. Always present.
    public string id { get; }

    public Tenant(string name, string id)
    {
        if (string.IsNullOrWhiteSpace(name)) { throw new ArgumentException("Tenant.name is required"); }
        if (string.IsNullOrWhiteSpace(id)) { throw new ArgumentException("Tenant.id is required"); }
        this.name = name;
        this.id = id;
    }
}
