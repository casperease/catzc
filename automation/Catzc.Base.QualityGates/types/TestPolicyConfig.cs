// What a test may do to the environment it reaches (configs/test-policy.yml,
// [ADR-AUTO-TEST#41](/docs/adr/automation/test-automation.md#rule-adr-auto-test41)), and the single declaration of its sensible
// defaults ([ADR-AUTO-DEFAULT#6](/docs/adr/automation/sensible-defaults.md#rule-adr-auto-default6)):
//   l4_mutation — per target environment, how far an L4 test (the released system, after final approval) may change it:
//                 read-only (probes and observations only) or synthetic (transactions the system is built to accept and
//                 clean up). An environment not listed is read-only.
// Property names mirror the YAML keys (snake_case,
// [ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)).

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

    public IReadOnlyDictionary<string, string> l4_mutation { get; }

    public TestPolicyConfig(IDictionary raw)
    {
        var mutation = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase);
        if (raw != null)
        {
            foreach (object key in raw.Keys)
            {
                string name = Convert.ToString(key, CultureInfo.InvariantCulture);
                if (name != "l4_mutation")
                {
                    throw new ArgumentException(string.Format(CultureInfo.InvariantCulture,
                        "test-policy config: unknown key '{0}' (allowed: l4_mutation)", name));
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
