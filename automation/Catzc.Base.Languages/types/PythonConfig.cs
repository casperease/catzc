/*
---
catzc:
  derived:
    path: automation/Catzc.Base.Languages/types/PythonConfig.cs
    kind: csharp-type
    language: csharp
    track: automation
    module: Catzc.Base.Languages
    relatives:
      page: docs/references/automation/catzc-base-languages/types/PythonConfig.cs.md
      test: automation/Catzc.Base.Languages/tests/types/PythonConfig.Tests.ps1
    adrs:
      - ADR-AUTO-TYPES#8
      - ADR-REPO-FOLDERS#7
---
*/

using System;
using System.Collections;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.Text.RegularExpressions;

namespace Catzc.Base.Languages;

public sealed class PythonConfig : Catzc.Base.Objects.DictionaryRecord
{
    // The Python root when the repository has this folder: a Python root track.
    public const string DefaultRoot = "python";

    // The Python root otherwise: the dot-prefixed tooling folder.
    public const string FallbackRoot = ".python";

    // A test named test_integrity* reads the shipped artifacts and is `integrity`.
    public const string IntegrityPrefix = "test_integrity";

    private const string Failed = "python config validation failed:\n";
    private static readonly string[] AllowedKeys = { "root", "dependencies" };
    private static readonly string[] RequiredDependencies = { "pytest", "ruff" };
    private static readonly Regex Root = new Regex(@"^[A-Za-z0-9._-]+(/[A-Za-z0-9._-]+)*$");
    private static readonly Regex DistributionName = new Regex(@"^[a-z0-9]([a-z0-9._-]*[a-z0-9])?$");
    private static readonly Regex ExactVersion = new Regex(@"^[0-9]+(\.[0-9]+)*$");

    public string root { get; }

    // The test dependencies every workspace member requires, distribution name -> exact version, in ordinal name order.
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

            if (raw.Contains("root") && raw["root"] != null)
            {
                string value = Convert.ToString(raw["root"], CultureInfo.InvariantCulture);
                bool dotSegment = Array.Exists(value.Split('/'), s => s == "." || s == "..");
                if (raw["root"] is string && Root.IsMatch(value) && !dotSegment) { root = value; }
                else
                {
                    errors.Add(string.Format(CultureInfo.InvariantCulture,
                        "invalid root '{0}' (a repository-relative folder: '/'-separated segments, no leading or trailing slash, no '.' or '..' segment, e.g. 'python')", value));
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

    public string ResolveRoot(string repositoryRoot)
    {
        if (root != null) { return root; }
        if (string.IsNullOrWhiteSpace(repositoryRoot))
        {
            throw new ArgumentException("PythonConfig.ResolveRoot requires the repository root");
        }
        return Directory.Exists(Path.Combine(repositoryRoot, DefaultRoot)) ? DefaultRoot : FallbackRoot;
    }
}
