/*
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.VSCode/types/VscodeLaunchProfile.cs
    folder: types
    name: vscode-launch-profile
    filetype: cs
    role: type
    language: csharp
    track: pwsh
    tracktype: modules
    module: Catzc.Base.VSCode
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    docs: "[VscodeLaunchProfile.cs.md](docs/references/pwsh/catzc-base-vscode/types/VscodeLaunchProfile.cs.md)"
---
*/

using System;
using System.Collections;
using System.Collections.Generic;
using System.Collections.Specialized;

namespace Catzc.Base.VSCode;

public sealed class VscodeLaunchProfile : Catzc.Base.Objects.DictionaryRecord
{
    // The profile's display name in the Run and Debug view (unique within the registry).
    public string name { get; }

    // The debugger type (e.g. 'PowerShell').
    public string type { get; }

    // 'launch' or 'attach'.
    public string request { get; }

    // Every key of the profile (name/type/request included), in authored order — what launch.json receives; read-only.
    public OrderedDictionary fields { get; }

    public VscodeLaunchProfile(object raw)
    {
        IDictionary entry = raw as IDictionary;
        if (entry == null) { throw new ArgumentException("each configurations entry must be a mapping"); }

        List<string> errors = new List<string>();
        name = Required(entry, "name", errors);
        type = Required(entry, "type", errors);
        request = Required(entry, "request", errors);

        OrderedDictionary map = new OrderedDictionary(StringComparer.OrdinalIgnoreCase);
        foreach (object k in entry.Keys) { map[k == null ? "" : k.ToString()] = entry[k]; }
        fields = map.AsReadOnly();

        if (errors.Count > 0) { throw new ArgumentException(string.Join("\n", errors)); }
    }

    private static string Required(IDictionary entry, string key, List<string> errors)
    {
        string value = entry.Contains(key) ? entry[key] as string : null;
        if (string.IsNullOrWhiteSpace(value))
        {
            errors.Add(string.Format("a configurations entry is missing a non-empty '{0}'", key));
            return null;
        }
        return value;
    }
}
