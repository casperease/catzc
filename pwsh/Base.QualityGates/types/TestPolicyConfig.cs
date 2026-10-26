using System;
using System.Collections;
using System.Collections.Generic;
using System.Globalization;

namespace Catzc.Base.QualityGates;

// What a test may do to the environment it reaches, with its defaults declared once.
public sealed class TestPolicyConfig
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    // The mutation modes, least to most: an environment that allows one allows every mode before it.
    public static readonly string[] MutationModes = { "read-only", "synthetic" };

    // The mode of an environment the config does not list.
    public const string DefaultMutation = "read-only";

    // How many greedy files run at once in the pool: 1 runs them one after another, 2 two at a time, 3 three at a time.
    public const int DefaultGreedyGroupSize = 2;
    public const int MaxGreedyGroupSize = 64;

    // The greedy files that each run real builds, named by their test file without '.Tests.ps1': at most one of them runs at a time.
    public static readonly string[] DefaultGreedyApart =
    {
        "Import-Catzc", "Test-CatzcBuild.Parity", "Test-CatzcBuild.ScopeIsolation", "Build-Bicep.L2", "Get-BicepParameterModel.Shipped"
    };

    public IReadOnlyList<string> greedy_apart { get; }

    public IReadOnlyDictionary<string, string> l4_mutation { get; }

    // The share of a file's stored duration a faster run keeps, so a cold-cache spike fades over about twenty runs; 0 trusts the last run.
    public const double DefaultDurationDecay = 0.9;

    public int greedy_group_size { get; }

    public double duration_decay { get; }

    public TestPolicyConfig(IDictionary raw)
    {
        var mutation = new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase);
        int groupSize = DefaultGreedyGroupSize;
        double decay = DefaultDurationDecay;
        var apart = new List<string>(DefaultGreedyApart);
        if (raw != null)
        {
            foreach (object key in raw.Keys)
            {
                string name = Convert.ToString(key, CultureInfo.InvariantCulture);
                if (name != "l4_mutation" && name != "greedy_group_size" && name != "greedy_apart" && name != "duration_decay")
                {
                    throw new ArgumentException(string.Format(CultureInfo.InvariantCulture,
                        "test-policy config: unknown key '{0}' (allowed: l4_mutation, greedy_group_size, greedy_apart, duration_decay)", name));
                }
            }

            if (raw.Contains("greedy_apart") && raw["greedy_apart"] != null)
            {
                if (!(raw["greedy_apart"] is IEnumerable list) || raw["greedy_apart"] is string)
                {
                    throw new ArgumentException("test-policy config: greedy_apart must be a list of test file names without '.Tests.ps1'");
                }
                apart.Clear();
                foreach (object item in list)
                {
                    string file = Convert.ToString(item, CultureInfo.InvariantCulture);
                    if (string.IsNullOrWhiteSpace(file) || file.EndsWith(".ps1", StringComparison.OrdinalIgnoreCase))
                    {
                        throw new ArgumentException(string.Format(CultureInfo.InvariantCulture,
                            "test-policy config: greedy_apart entry '{0}' must name a test file without '.Tests.ps1'", file));
                    }
                    apart.Add(file);
                }
            }

            if (raw.Contains("duration_decay") && raw["duration_decay"] != null)
            {
                if (!double.TryParse(Convert.ToString(raw["duration_decay"], CultureInfo.InvariantCulture), NumberStyles.Float,
                        CultureInfo.InvariantCulture, out decay) || double.IsNaN(decay) || decay < 0 || decay >= 1)
                {
                    throw new ArgumentException("test-policy config: duration_decay must be a number from 0 up to, not including, 1");
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
        greedy_apart = apart.AsReadOnly();
        duration_decay = decay;
    }

    // Whether a greedy test file is one of the build files that run one at a time.
    public bool IsApart(string testFilePath)
    {
        string name = System.IO.Path.GetFileName(testFilePath ?? string.Empty);
        const string suffix = ".Tests.ps1";
        if (name.EndsWith(suffix, StringComparison.OrdinalIgnoreCase))
        {
            name = name.Substring(0, name.Length - suffix.Length);
        }
        foreach (string entry in greedy_apart)
        {
            if (string.Equals(entry, name, StringComparison.OrdinalIgnoreCase))
            {
                return true;
            }
        }
        return false;
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
