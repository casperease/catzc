// The keys of the generated-file head, in the order they are written; a key a file has no value for is left out.

using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;

namespace Catzc.Base.Languages;

public sealed class GeneratedHeadConfig : Catzc.Base.Objects.DictionaryRecord
{
    // The one string every generated head carries, so a reader of any tracked generated file is told not to edit it.
    public const string DefaultWarning = "Do Not Edit, this file is generated";

    private const string Failed = "generated-head configuration validation failed:\n";
    private static readonly string[] Known = ["with_body_sha", "warning", "role", "track", "generator", "source"];
    private static readonly string[] TopLevel = ["keys", "warning"];

    // The head keys in writing order.
    public string[] order { get; }

    // The value of the head's `warning` key.
    public string warning { get; }

    public GeneratedHeadConfig(IDictionary raw)
    {
        List<string> errors = new List<string>();
        if (raw == null) { throw new ArgumentException(Failed + "the configuration must be a mapping"); }
        foreach (object k in raw.Keys)
        {
            string name = k == null ? null : k.ToString();
            if (Array.IndexOf(TopLevel, name) < 0) { errors.Add(string.Format("unknown top-level key '{0}' (allowed: {1})", k, string.Join(", ", TopLevel))); }
        }
        warning = OptStr(raw, "warning") ?? DefaultWarning;
        string[] listed = StrArr(raw, "keys");
        foreach (string key in listed)
        {
            if (Array.IndexOf(Known, key) < 0) { errors.Add(string.Format("unknown head key '{0}' (allowed: {1})", key, string.Join(", ", Known))); }
        }
        if (listed.Distinct().Count() != listed.Length) { errors.Add("a head key is listed once"); }
        foreach (string required in new[] { "with_body_sha", "warning", "role" })
        {
            if (Array.IndexOf(listed, required) < 0) { errors.Add(string.Format("the head key '{0}' is required", required)); }
        }
        if (errors.Count > 0) { throw new ArgumentException(Failed + string.Join("\n", errors)); }
        order = listed;
    }
}
