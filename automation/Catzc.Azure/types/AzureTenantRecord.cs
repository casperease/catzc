/*
---
catzc:
  immutable:
    path: automation/Catzc.Azure/types/AzureTenantRecord.cs
    folder: types
    name: azure-tenant-record
    filetype: cs
    kind: type
    language: csharp
    track: automation
    module: Catzc.Azure
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    page: docs/references/automation/catzc-azure/types/AzureTenantRecord.cs.md
    cites:
      - ADR-AUTO-TYPES#8
      - ADR-AZ-DATAMOD
---
*/

using System;
using System.Collections;
using System.Collections.Generic;
using System.Text.RegularExpressions;

namespace Catzc.Azure;

public sealed class AzureTenantRecord : Catzc.Base.Objects.DictionaryRecord
{
    private static readonly string[] AllowedKeys = { "id" };

    // The tenant's logical name (the map key).
    public string name { get; }

    // The Entra directory (tenant) GUID. Null when missing or invalid (a violation is recorded).
    public string id { get; }

    // Builds the record and throws one ArgumentException listing every violation.
    public AzureTenantRecord(string name, IDictionary d) : this(name, d, null) { }

    // Builds the record best-effort, appending every violation to `errors` (throws only when `errors` is null).
    internal AzureTenantRecord(string name, IDictionary d, List<string> errors)
    {
        List<string> own = errors ?? new List<string>();
        int before = own.Count;
        this.name = name;

        if (name == null || !Regex.IsMatch(name, AzureConfig.IdentifierPattern))
        {
            own.Add(string.Format("tenant name '{0}' is not a valid identifier (must match {1})", name, AzureConfig.IdentifierPattern));
        }
        if (d == null)
        {
            own.Add(string.Format("tenant '{0}' must be a mapping with an 'id'", name));
        }
        else
        {
            AzureConfig.UnknownKeys(d, AllowedKeys, string.Format("tenant '{0}'", name), own);
            if (!d.Contains("id")) { own.Add(string.Format("tenant '{0}' missing 'id'", name)); }
            else
            {
                string value = AzureConfig.Text(d["id"]);
                if (AzureConfig.IsGuid(value)) { id = value; }
                else { own.Add(string.Format("tenant '{0}' has invalid id '{1}' (must be a GUID)", name, value)); }
            }
        }

        if (errors == null && own.Count > before) { throw new ArgumentException(string.Join("\n", own)); }
    }
}
