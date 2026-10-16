/*
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.Languages/types/GeneratedHeadConfig.cs
    folder: types
    name: generated-head-config
    filetype: cs
    kind: type
    language: csharp
    track: automation
    tracktype: modules
    module: Catzc.Base.Languages
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    test: automation/Catzc.Base.Languages/tests/types/GeneratedHeadConfig.Tests.ps1
---
*/

// The keys of the generated-file head, in the order they are written; a key a file has no value for is left out.

using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;

namespace Catzc.Base.Languages;

public sealed class GeneratedHeadConfig : Catzc.Base.Objects.DictionaryRecord
{
    private const string Failed = "generated-head configuration validation failed:\n";
    private static readonly string[] Known = ["with_body_sha", "with_inputs_sha", "repo_status", "path", "source", "kind", "subkind", "language", "filetype", "track", "tracktype", "vendor", "module", "moduletype", "generator"];

    // The head keys in writing order.
    public string[] order { get; }

    public GeneratedHeadConfig(IDictionary raw)
    {
        List<string> errors = new List<string>();
        if (raw == null) { throw new ArgumentException(Failed + "the configuration must be a mapping"); }
        foreach (object k in raw.Keys)
        {
            string name = k == null ? null : k.ToString();
            if (name != "keys") { errors.Add(string.Format("unknown top-level key '{0}' (allowed: keys)", k)); }
        }
        string[] listed = StrArr(raw, "keys");
        foreach (string key in listed)
        {
            if (Array.IndexOf(Known, key) < 0) { errors.Add(string.Format("unknown head key '{0}' (allowed: {1})", key, string.Join(", ", Known))); }
        }
        if (listed.Distinct().Count() != listed.Length) { errors.Add("a head key is listed once"); }
        foreach (string required in new[] { "path", "kind" })
        {
            if (Array.IndexOf(listed, required) < 0) { errors.Add(string.Format("the head key '{0}' is required", required)); }
        }
        if (errors.Count > 0) { throw new ArgumentException(Failed + string.Join("\n", errors)); }
        order = listed;
    }
}
