/*
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-languages/types/PythonConfig.cs.md"
  warning: "Generated Header"
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

    // The pyright mode the type check runs in, in the gate and in the editor alike: pyright's own default.
    public const string DefaultTypeChecking = "standard";

    // Where pytest keeps its cache: generated output, under out/.
    public const string DefaultPytestCache = "out/pytest-cache";

    // Where Python writes compiled bytecode (PYTHONPYCACHEPREFIX), instead of __pycache__ beside the sources.
    public const string DefaultPycache = "out/pycache";

    private const string Failed = "python config validation failed:\n";
    private static readonly string[] AllowedKeys = { "root", "dependencies", "type_checking", "pytest_cache", "pycache" };
    private static readonly string[] RequiredDependencies = { "pyright", "pytest", "ruff" };
    private static readonly string[] TypeCheckingModes = { "off", "basic", "standard", "strict" };
    private static readonly Regex Root = new Regex(@"^[A-Za-z0-9._-]+(/[A-Za-z0-9._-]+)*$");
    private static readonly Regex DistributionName = new Regex(@"^[a-z0-9]([a-z0-9._-]*[a-z0-9])?$");
    private static readonly Regex ExactVersion = new Regex(@"^[0-9]+(\.[0-9]+)*$");

    public string root { get; }

    // The test dependencies every workspace member requires, distribution name -> exact version, in ordinal name order.
    public IReadOnlyDictionary<string, string> dependencies { get; }

    // The pyright typeCheckingMode of the gate (Test-PythonTypes) and of Pylance in the editor.
    public string type_checking { get; } = DefaultTypeChecking;

    // The repository-relative folder of pytest's cache, of the test bridge and the editor's test explorer alike.
    public string pytest_cache { get; } = DefaultPytestCache;

    // The repository-relative folder of Python's bytecode cache, of the test bridge and the editor's terminals alike.
    public string pycache { get; } = DefaultPycache;

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

            if (raw.Contains("type_checking") && raw["type_checking"] != null)
            {
                string value = Convert.ToString(raw["type_checking"], CultureInfo.InvariantCulture);
                if (raw["type_checking"] is string && Array.IndexOf(TypeCheckingModes, value) >= 0) { type_checking = value; }
                else
                {
                    errors.Add(string.Format(CultureInfo.InvariantCulture,
                        "invalid type_checking '{0}' (a pyright typeCheckingMode: {1})", value, string.Join(", ", TypeCheckingModes)));
                }
            }

            pytest_cache = Folder(raw, "pytest_cache", DefaultPytestCache, errors);
            pycache = Folder(raw, "pycache", DefaultPycache, errors);

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
                    "dependencies must pin '{0}' (the Python checks and the test bridge run it)", required));
            }
        }

        if (errors.Count > 0) { throw new ArgumentException(Failed + string.Join("\n", errors)); }
        dependencies = requires;
    }

    // A repository-relative folder key, or its default when the file states none.
    private static string Folder(IDictionary raw, string key, string fallback, List<string> errors)
    {
        if (!raw.Contains(key) || raw[key] == null) { return fallback; }
        string value = Convert.ToString(raw[key], CultureInfo.InvariantCulture);
        bool dotSegment = Array.Exists(value.Split('/'), s => s == "." || s == "..");
        if (raw[key] is string && Root.IsMatch(value) && !dotSegment) { return value; }
        errors.Add(string.Format(CultureInfo.InvariantCulture,
            "invalid {0} '{1}' (a repository-relative folder: '/'-separated segments, no leading or trailing slash, no '.' or '..' segment)", key, value));
        return fallback;
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
