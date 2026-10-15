/*
---
catzc:
  derived:
    path: automation/Catzc.Base.Languages/types/GeneratedHeadConfig.cs
    kind: csharp-type
    module: Catzc.Base.Languages
    relatives:
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
    private static readonly string[] Known = { "path", "source", "kind", "generator" };

    // The head keys in writing order.
    public string[] order { get; }

    // The kind of a generated file that git does not track. Default: generated-from-source.
    public string kind { get; }

    // The kind of a generated file that git tracks, because a fresh clone or a reader needs it before any import. Default: tracked-generated-from-source.
    public string tracked_kind { get; }

    public GeneratedHeadConfig(IDictionary raw)
    {
        List<string> errors = new List<string>();
        if (raw == null) { throw new ArgumentException(Failed + "the configuration must be a mapping"); }
        foreach (object k in raw.Keys)
        {
            string name = k == null ? null : k.ToString();
            if (name != "keys" && name != "kind" && name != "tracked_kind") { errors.Add(string.Format("unknown top-level key '{0}' (allowed: keys, kind, tracked_kind)", k)); }
        }
        kind = OptStr(raw, "kind") ?? "generated-from-source";
        tracked_kind = OptStr(raw, "tracked_kind") ?? "tracked-generated-from-source";
        if (kind == tracked_kind) { errors.Add("kind and tracked_kind differ, so a reader tells a tracked file from an ignored one"); }
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
