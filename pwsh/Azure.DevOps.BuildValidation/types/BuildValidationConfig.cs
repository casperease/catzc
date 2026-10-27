using System;
using System.Collections;
using System.Collections.Generic;

namespace Catzc.Azure.DevOps.BuildValidation;

// Every violation is reported at once; a globset name lives in a value, because kebab case cannot be a key.
public sealed class BuildValidationConfig : Catzc.Base.Objects.DictionaryRecord
{
    private static readonly string[] RequiredKeys = { "branch", "validations" };

    private static readonly string[] AllowedKeys = { "branch", "validations", "policies" };

    // The branch the policies guard.
    public string branch { get; }

    public BranchPolicies policies { get; }

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
                    errors.Add(string.Format("Unknown top-level key: '{0}' (allowed: {1})", key, string.Join(", ", AllowedKeys)));
                }
            }
        }
        foreach (string key in RequiredKeys)
        {
            if (d == null || !d.Contains(key)) { errors.Add(string.Format("Missing required key: '{0}'", key)); }
        }

        IDictionary rawPolicies = d != null && d.Contains("policies") ? d["policies"] as IDictionary : null;
        if (d != null && d.Contains("policies") && d["policies"] != null && rawPolicies == null)
        {
            errors.Add("policies must be a mapping");
        }
        try
        {
            policies = new BranchPolicies(rawPolicies);
        }
        catch (ArgumentException ex)
        {
            errors.AddRange(ex.Message.Split('\n'));
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
