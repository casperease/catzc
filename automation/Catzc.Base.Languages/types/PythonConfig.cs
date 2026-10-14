// The Python test-project settings (configs/python.yml). New-PythonProject renders the one generated uv project,
// python/pyproject.toml, from it, and Invoke-PythonTest runs the tests in python/tests/<folder>/ inside that project's
// environment. Registered in Catzc.Base.Config/configs/configs.yml (type: Catzc.Base.Languages.PythonConfig), so
// Get-Config -Config python returns this typed record. Property names mirror the YAML keys (snake_case,
// [ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)). The Python version is not
// a setting here: it is the python tool's pin in tools.yml, the one Python version.
//
// The Python root is not a setting either: python/ is a conventional root folder, hardcoded
// ([ADR-REPO-FOLDERS#7](/docs/adr/repository/conventional-folders.md#rule-adr-repo-folders7)) as Root, because Python
// has no competing layout idiom for where test code lives.
//
// Constructing an instance validates the file, collecting every violation into one ArgumentException:
//   - only the known key 'dependencies' — an unknown key (a typo) fails at load;
//   - 'dependencies' maps a normalised distribution name (lowercase letters, digits, '-', '_', '.') to an exact
//     version (digits and dots), kept in ordinal name order so a rendering never depends on the file's key order;
//   - the tools the bridge runs are required: 'pytest' (the test runner) and 'ruff' (the formatter and linter).

using System;
using System.Collections;
using System.Collections.Generic;
using System.Globalization;
using System.Text.RegularExpressions;

namespace Catzc.Base.Languages;

public sealed class PythonConfig : Catzc.Base.Objects.DictionaryRecord
{
    // The Python root folder, repository-relative: the test folders live in python/tests/<module>/, and the generated
    // project, its environment and its lock live in python/.
    public const string Root = "python";

    // A test named test_integrity* reads the shipped artifacts and is `integrity`.
    public const string IntegrityPrefix = "test_integrity";

    private const string Failed = "python config validation failed:\n";
    private static readonly string[] AllowedKeys = { "dependencies" };
    private static readonly string[] RequiredDependencies = { "pytest", "ruff" };
    private static readonly Regex DistributionName = new Regex(@"^[a-z0-9]([a-z0-9._-]*[a-z0-9])?$");
    private static readonly Regex ExactVersion = new Regex(@"^[0-9]+(\.[0-9]+)*$");

    // The test project's dependencies, distribution name -> exact version, in ordinal name order.
    public IReadOnlyDictionary<string, string> dependencies { get; }

    public PythonConfig(IDictionary raw)
    {
        List<string> errors = new List<string>();
        SortedDictionary<string, string> requires = new SortedDictionary<string, string>(StringComparer.Ordinal);

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

            if (raw.Contains("dependencies") && raw["dependencies"] != null)
            {
                IDictionary map = raw["dependencies"] as IDictionary;
                if (map == null)
                {
                    errors.Add("invalid dependencies (must be a map of distribution name to exact version, e.g. { pytest: 9.1.1 })");
                }
                else
                {
                    foreach (DictionaryEntry entry in map)
                    {
                        string name = Convert.ToString(entry.Key, CultureInfo.InvariantCulture) ?? "";
                        string version = Convert.ToString(entry.Value, CultureInfo.InvariantCulture) ?? "";
                        bool valid = true;
                        if (!DistributionName.IsMatch(name))
                        {
                            errors.Add(string.Format(CultureInfo.InvariantCulture,
                                "invalid dependencies key '{0}' (a normalised distribution name: lowercase letters, digits, '-', '_', '.')", name));
                            valid = false;
                        }
                        if (!ExactVersion.IsMatch(version))
                        {
                            errors.Add(string.Format(CultureInfo.InvariantCulture,
                                "invalid dependencies.{0} '{1}' (an exact version, digits and dots, e.g. 9.1.1)", name, version));
                            valid = false;
                        }
                        if (valid) { requires[name] = version; }
                    }
                }
            }
        }

        foreach (string required in RequiredDependencies)
        {
            if (!requires.ContainsKey(required))
            {
                errors.Add(string.Format(CultureInfo.InvariantCulture,
                    "dependencies must pin '{0}' (the Python test bridge runs it)", required));
            }
        }

        if (errors.Count > 0) { throw new ArgumentException(Failed + string.Join("\n", errors)); }
        dependencies = requires;
    }
}
