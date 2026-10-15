// An environment not listed is read-only, so synthetic mutation by an L4 test must be granted per environment.
// [ADR-AUTO-TEST#41](/docs/adr/automation/test-automation.md#rule-adr-auto-test41),
// [ADR-AUTO-DEFAULT#6](/docs/adr/automation/sensible-defaults.md#rule-adr-auto-default6),
// [ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)
// [comment:1](/docs/references/automation/catzc-base-qualitygates/types/TestPolicyConfig.cs.md#comment1)

using System;
using System.Collections;
using System.Collections.Generic;
using System.Globalization;

namespace Catzc.Base.QualityGates;

public sealed class TestPolicyConfig
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    // The mutation modes, least to most: an environment that allows one allows every mode before it.
    public static readonly string[] MutationModes = { "read-only", "synthetic" };

    // The mode of an environment the config does not list.
    public const string DefaultMutation = "read-only";

    // How many greedy files run side by side: 1 runs them one after another, 2 in pairs, 3 in triplets. The groups themselves run serially.
    public const int DefaultGreedyGroupSize = 2;
    public const int MaxGreedyGroupSize = 64;

    public IReadOnlyDictionary<string, string> l4_mutation { get; }

    public int greedy_group_size { get; }

    public TestPolicyConfig(IDictionary raw)
    {
        var mutation = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase);
        int groupSize = DefaultGreedyGroupSize;
        if (raw != null)
        {
            foreach (object key in raw.Keys)
            {
                string name = Convert.ToString(key, CultureInfo.InvariantCulture);
                if (name != "l4_mutation" && name != "greedy_group_size")
                {
                    throw new ArgumentException(string.Format(CultureInfo.InvariantCulture,
                        "test-policy config: unknown key '{0}' (allowed: l4_mutation, greedy_group_size)", name));
                }
            }

            if (raw.Contains("greedy_group_size") && raw["greedy_group_size"] != null)
            {
                if (!int.TryParse(Convert.ToString(raw["greedy_group_size"], CultureInfo.InvariantCulture), NumberStyles.Integer,
                        CultureInfo.InvariantCulture, out groupSize) || groupSize < 1 || groupSize > MaxGreedyGroupSize)
                {
                    throw new ArgumentException(string.Format(CultureInfo.InvariantCulture,
                        "test-policy config: greedy_group_size must be a whole number from 1 to {0}", MaxGreedyGroupSize));
                }
            }

            if (raw.Contains("l4_mutation") && raw["l4_mutation"] != null)
            {
                if (!(raw["l4_mutation"] is IDictionary map))
                {
                    throw new ArgumentException("test-policy config: l4_mutation must be a map of environment to mode");
                }
                foreach (DictionaryEntry entry in map)
                {
                    string environment = Convert.ToString(entry.Key, CultureInfo.InvariantCulture);
                    string mode = Convert.ToString(entry.Value, CultureInfo.InvariantCulture);
                    if (Array.IndexOf(MutationModes, mode) < 0)
                    {
                        throw new ArgumentException(string.Format(CultureInfo.InvariantCulture,
                            "test-policy config: l4_mutation.{0} '{1}' is not one of: {2}", environment, mode, string.Join(", ", MutationModes)));
                    }
                    mutation[environment] = mode;
                }
            }
        }
        l4_mutation = mutation;
        greedy_group_size = groupSize;
    }

    // The mode an environment allows L4 tests: its entry, or read-only.
    public string MutationFor(string environment)
    {
        return environment != null && l4_mutation.TryGetValue(environment, out string mode) ? mode : DefaultMutation;
    }

    // Whether an L4 test that needs a mode may run against an environment.
    public bool Allows(string environment, string mode)
    {
        int needed = Array.IndexOf(MutationModes, mode);
        if (needed < 0)
        {
            throw new ArgumentException(string.Format(CultureInfo.InvariantCulture,
                "'{0}' is not a mutation mode (one of: {1})", mode, string.Join(", ", MutationModes)), nameof(mode));
        }
        return needed <= Array.IndexOf(MutationModes, MutationFor(environment));
    }
}
