/*
---
catzc:
  derived:
    path: automation/Catzc.Azure/types/Tenant.cs
    kind: csharp-type
    language: csharp
    track: automation
    module: Catzc.Azure
    relatives:
      page: docs/references/automation/catzc-azure/types/Tenant.cs.md
---
*/

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
