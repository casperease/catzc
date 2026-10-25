/*
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-azure-dev-ops-build-validation/types/BuildValidationEntry.cs.md"
  header: "generated"
---
*/

using System;
using System.Collections;
using System.Collections.Generic;

namespace Catzc.Azure.DevOps.BuildValidation;

// Shape only: a globset's existence is checked at run time, so loading the config never reads the globs registry.
public sealed class BuildValidationEntry : Catzc.Base.Objects.DictionaryRecord
{
    private static readonly string[] AllowedKeys = { "globset", "pipeline", "blocking", "display_name" };

    // The declared globset the policy is tied to (its native path projection is the policy's path filter).
    public string globset { get; }

    // Null when absent, so the globset's own pipeline annotation applies.
    public string pipeline { get; }

    // Whether the policy blocks the merge. Defaults to true.
    public bool blocking { get; }

    // The policy display name. Null when absent: the consumer defaults it to 'Build validation - <globset>'.
    public string display_name { get; }

    public BuildValidationEntry(IDictionary d)
    {
        if (d == null) { throw new ArgumentException("must be a mapping with a 'globset' key"); }
        List<string> errors = new List<string>();

        foreach (object k in d.Keys)
        {
            string key = k == null ? null : k.ToString();
            if (Array.IndexOf(AllowedKeys, key) < 0)
            {
                errors.Add(string.Format("unknown key '{0}' (allowed: {1})", key, string.Join(", ", AllowedKeys)));
            }
        }

        globset = OptStr(d, "globset");
        if (globset == null) { errors.Add("'globset' is required and must be non-empty"); }

        pipeline = OptStr(d, "pipeline");
        if (d.Contains("pipeline") && pipeline == null) { errors.Add("'pipeline' must be non-empty when present"); }

        blocking = true;
        if (d.Contains("blocking"))
        {
            if (d["blocking"] is bool) { blocking = (bool)d["blocking"]; }
            else { errors.Add("'blocking' must be a boolean"); }
        }

        display_name = OptStr(d, "display_name");
        if (d.Contains("display_name") && display_name == null) { errors.Add("'display_name' must be non-empty when present"); }

        if (errors.Count > 0) { throw new ArgumentException(string.Join("\n", errors)); }
    }
}
