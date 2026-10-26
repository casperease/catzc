using System;
using System.Collections;
using System.Collections.Generic;
using System.Globalization;
using System.Text.RegularExpressions;

namespace Catzc.Base.Languages;

// The one build configuration and platform every non-vendored .sln and .csproj declares.
public sealed class BclConfig : Catzc.Base.Objects.DictionaryRecord
{
    public const string DefaultConfiguration = "Debug";

    public const string DefaultPlatform = "Any CPU";

    private const string Failed = "bcl config validation failed:\n";
    private static readonly string[] AllowedKeys = { "configuration", "platform", "host_bindings" };
    private static readonly Regex Name = new Regex(@"^[A-Za-z][A-Za-z0-9]*( [A-Za-z0-9]+)*$");

    public string configuration { get; }

    public string platform { get; }

    // The type sources that bind to a host, in ordinal file order; every other type source stays in the BCL reference set.
    public IReadOnlyList<BclHostBinding> host_bindings { get; }

    public BclConfig(IDictionary raw)
    {
        List<string> errors = new List<string>();
        configuration = DefaultConfiguration;
        platform = DefaultPlatform;
        List<BclHostBinding> bindings = new List<BclHostBinding>();

        if (raw != null)
        {
            foreach (object k in raw.Keys)
            {
                string key = Convert.ToString(k, CultureInfo.InvariantCulture);
                if (Array.IndexOf(AllowedKeys, key) < 0)
                {
                    errors.Add(string.Format(CultureInfo.InvariantCulture, "unknown key '{0}' (allowed: {1})", key, string.Join(", ", AllowedKeys)));
                }
            }

            foreach (string key in new[] { "configuration", "platform" })
            {
                if (!raw.Contains(key) || raw[key] == null) { continue; }
                string value = Convert.ToString(raw[key], CultureInfo.InvariantCulture);
                if (!(raw[key] is string) || !Name.IsMatch(value))
                {
                    errors.Add(string.Format(CultureInfo.InvariantCulture,
                        "invalid {0} '{1}' (a name of letters and digits, words separated by one space, e.g. 'Debug' or 'Any CPU')", key, value));
                }
                else if (key == "configuration") { configuration = value; }
                else { platform = value; }
            }

            if (raw.Contains("host_bindings") && raw["host_bindings"] != null)
            {
                IList rows = raw["host_bindings"] as IList;
                if (rows == null || raw["host_bindings"] is string)
                {
                    errors.Add("invalid host_bindings (must be a list of { file, host, reason } rows)");
                }
                else
                {
                    HashSet<string> seen = new HashSet<string>(StringComparer.OrdinalIgnoreCase);
                    for (int i = 0; i < rows.Count; i++)
                    {
                        string place = string.Format(CultureInfo.InvariantCulture, "host_bindings[{0}]", i);
                        BclHostBinding binding = BclHostBinding.FromRow(rows[i], place, errors);
                        if (binding == null) { continue; }
                        if (!seen.Add(binding.file))
                        {
                            errors.Add(string.Format(CultureInfo.InvariantCulture, "{0}: '{1}' is bound twice", place, binding.file));
                            continue;
                        }
                        bindings.Add(binding);
                    }
                }
            }
        }

        if (errors.Count > 0) { throw new ArgumentException(Failed + string.Join("\n", errors)); }
        bindings.Sort((a, b) => string.CompareOrdinal(a.file, b.file));
        host_bindings = bindings;
    }

    // The host binding of a type source ('<module>/types/<Type>.cs'), or null when the source stays in the BCL reference set.
    public BclHostBinding HostBindingOf(string file)
    {
        foreach (BclHostBinding binding in host_bindings)
        {
            if (string.Equals(binding.file, file, StringComparison.OrdinalIgnoreCase)) { return binding; }
        }
        return null;
    }

    // The platform as a .csproj spells it: MSBuild writes 'Any CPU' as 'AnyCPU' in a project, with the space in a solution.
    public string ProjectPlatform() => platform.Replace(" ", "");

    // The one '<configuration>|<platform>' pair a solution declares and maps every project to.
    public string SolutionPair() => configuration + "|" + platform;
}
