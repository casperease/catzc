// The Azure DevOps coupling (configs/ado.yml): the data that binds this repo to one ADO organization and the
// Entra (Azure AD) tenant behind it — the single source of truth for which org/tenant is the *correct* thing to
// be connected to. Registered in Catzc.Base.Config/configs/configs.yml (type: Catzc.Azure.DevOps.AdoConfig), so
// Get-Config -Config ado returns this typed record. Mirrors the YAML mapping (snake_case keys,
// [ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)).
//
// Constructing an instance validates the file, collecting every violation into one ArgumentException:
//   organization  required; the org REST URL (https://dev.azure.com/<org> or https://<org>.visualstudio.com)
//   project       required, non-empty; the default project (may be URL-encoded)
//   tenant        required; the Entra tenant GUID backing the org — the directory every auth path must be
//                 proven to target before Get-AdoAuthorizationHeader returns a header
// and no other key (a non-snake_case or misspelled key fails fast at load).

using System;
using System.Collections;
using System.Collections.Generic;
using System.Text.RegularExpressions;

namespace Catzc.Azure.DevOps;

public sealed class AdoConfig : Catzc.Base.Objects.DictionaryRecord
{
    private static readonly string[] AllowedKeys = { "organization", "project", "tenant" };

    // The Azure DevOps organization URL (the REST API host).
    public string organization { get; }

    // The default project.
    public string project { get; }

    // The Entra tenant GUID backing the organization.
    public string tenant { get; }

    public AdoConfig(IDictionary d)
    {
        List<string> errors = new List<string>();
        if (d != null)
        {
            foreach (object k in d.Keys)
            {
                string key = k == null ? null : k.ToString();
                if (Array.IndexOf(AllowedKeys, key) < 0)
                {
                    errors.Add(string.Format("unknown key '{0}' (allowed snake_case keys: {1})", key, string.Join(", ", AllowedKeys)));
                }
            }
        }

        foreach (string key in AllowedKeys)
        {
            if (d == null || !d.Contains(key)) { errors.Add(string.Format("Missing required key: '{0}'", key)); }
        }

        string org = Text(d, "organization");
        if (d != null && d.Contains("organization"))
        {
            if (Regex.IsMatch(org, "^https://\\S+$")) { organization = org; }
            else
            {
                errors.Add(string.Format("organization '{0}' is invalid (must be an https:// Azure DevOps org URL, e.g. https://dev.azure.com/<org>)", org));
            }
        }

        if (d != null && d.Contains("project"))
        {
            project = OptStr(d, "project");
            if (project == null) { errors.Add("project is empty"); }
        }

        string tid = Text(d, "tenant");
        if (d != null && d.Contains("tenant"))
        {
            Guid parsed;
            if (Guid.TryParse(tid, out parsed)) { tenant = tid; }
            else { errors.Add(string.Format("tenant '{0}' is invalid (must be a GUID — the Entra tenant backing the org)", tid)); }
        }

        if (errors.Count > 0) { throw new ArgumentException("ado configuration validation failed:\n" + string.Join("\n", errors)); }
    }

    private static string Text(IDictionary d, string key)
    {
        return (d != null && d.Contains(key) && d[key] != null) ? d[key].ToString() : "";
    }
}
