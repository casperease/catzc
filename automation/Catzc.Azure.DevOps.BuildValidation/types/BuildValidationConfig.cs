// Globset names sit in values, not keys, because they are kebab-case; every violation is collected into one exception.
// [ADR-FLOW-CD-TYPE#4](/docs/adr/flow/pipeline-types.md#rule-adr-flow-cd-type4),
// [ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)
// [comment:1](/docs/references/automation/catzc-azure-devops-buildvalidation/types/BuildValidationConfig.cs.md#comment1)

using System;
using System.Collections;
using System.Collections.Generic;

namespace Catzc.Azure.DevOps.BuildValidation;

public sealed class BuildValidationConfig : Catzc.Base.Objects.DictionaryRecord
{
    private static readonly string[] AllowedKeys = { "branch", "validations" };

    // The branch the policies guard.
    public string branch { get; }

    // The policies, in file order — one per globset.
    public IReadOnlyList<BuildValidationEntry> validations { get; }

    public BuildValidationConfig(IDictionary d)
    {
        List<string> errors = new List<string>();
        List<BuildValidationEntry> entries = new List<BuildValidationEntry>();
        validations = entries;

        if (d != null)
        {
            foreach (object k in d.Keys)
            {
                string key = k == null ? null : k.ToString();
                if (Array.IndexOf(AllowedKeys, key) < 0)
                {
                    errors.Add(string.Format("Unknown top-level key: '{0}' (allowed: branch, validations)", key));
                }
            }
        }
        foreach (string key in AllowedKeys)
        {
            if (d == null || !d.Contains(key)) { errors.Add(string.Format("Missing required key: '{0}'", key)); }
        }

        if (d != null && d.Contains("branch"))
        {
            branch = OptStr(d, "branch");
            if (branch == null) { errors.Add("branch is empty"); }
        }

        if (d != null && d.Contains("validations"))
        {
            IList list = d["validations"] as IList;
            if (list == null || list.Count == 0)
            {
                errors.Add("validations must be a non-empty list of entries");
            }
            else
            {
                HashSet<string> seen = new HashSet<string>(StringComparer.Ordinal);
                for (int i = 0; i < list.Count; i++)
                {
                    IDictionary raw = list[i] as IDictionary;
                    if (raw == null)
                    {
                        errors.Add(string.Format("validations[{0}] must be a mapping with a 'globset' key", i));
                        continue;
                    }
                    try
                    {
                        BuildValidationEntry entry = new BuildValidationEntry(raw);
                        if (!seen.Add(entry.globset))
                        {
                            errors.Add(string.Format("validations[{0}]: duplicate entry for globset '{1}'", i, entry.globset));
                        }
                        entries.Add(entry);
                    }
                    catch (ArgumentException ex)
                    {
                        foreach (string line in ex.Message.Split('\n'))
                        {
                            errors.Add(string.Format("validations[{0}]: {1}", i, line));
                        }
                    }
                }
            }
        }

        if (errors.Count > 0)
        {
            throw new ArgumentException("build-validation configuration validation failed:\n" + string.Join("\n", errors));
        }
    }
}
