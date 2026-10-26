using System;
using System.Collections;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.Text.RegularExpressions;

namespace Catzc.Base.Languages;

public sealed class JavaScriptConfig : Catzc.Base.Objects.DictionaryRecord
{
    // The JavaScript root when the repository has this folder: the js track.
    public const string DefaultRoot = "js";

    // The JavaScript root otherwise: the dot-prefixed tooling folder.
    public const string FallbackRoot = ".js";

    // The repository-relative, gitignored folder the tooling installs the type declarations into (npm --prefix), so the generated
    // jsconfig.json names the same relative type root on every machine.
    public const string DefaultTypesFolder = ".typescript";

    private const string Failed = "javascript config validation failed:\n";
    private static readonly string[] AllowedKeys = { "root", "strict", "types_folder" };
    private static readonly Regex Module = new Regex(@"^[a-z0-9]+(-[a-z0-9]+)*$");
    private static readonly Regex Root = new Regex(@"^[A-Za-z0-9._-]+(/[A-Za-z0-9._-]+)*$");

    // The declared JavaScript root folder, repository-relative ('/'-separated). Null when the file declares none.
    public string root { get; }

    // The folder the type declarations are installed into, repository-relative; DefaultTypesFolder unless declared.
    public string types_folder { get; } = DefaultTypesFolder;

    // The modules the types gate checks strictly, each a kebab module folder under the root; none by default, so every module starts lenient.
    public IReadOnlyList<string> strict { get; }

    public JavaScriptConfig(IDictionary raw)
    {
        List<string> errors = new List<string>();
        List<string> strictModules = new List<string>();
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
                        "invalid root '{0}' (a repository-relative folder: '/'-separated segments, no leading or trailing slash, no '.' or '..' segment, e.g. 'js')", value));
                }
            }

            if (raw.Contains("types_folder") && raw["types_folder"] != null)
            {
                string value = Convert.ToString(raw["types_folder"], CultureInfo.InvariantCulture);
                bool dotSegment = Array.Exists(value.Split('/'), s => s == "." || s == "..");
                if (raw["types_folder"] is string && Root.IsMatch(value) && !dotSegment) { types_folder = value; }
                else
                {
                    errors.Add(string.Format(CultureInfo.InvariantCulture,
                        "invalid types_folder '{0}' (a repository-relative folder: '/'-separated segments, no '.' or '..' segment, e.g. '.typescript')", value));
                }
            }

            if (raw.Contains("strict") && raw["strict"] != null)
            {
                IList listed = raw["strict"] as IList;
                if (listed == null || raw["strict"] is string) { errors.Add("strict must be a list of module folder names"); }
                else
                {
                    foreach (object item in listed)
                    {
                        string name = item as string;
                        if (name == null || !Module.IsMatch(name)) { errors.Add(string.Format(CultureInfo.InvariantCulture, "strict entry '{0}' is not a kebab module folder name", item)); }
                        else if (strictModules.Contains(name)) { errors.Add(string.Format(CultureInfo.InvariantCulture, "strict lists '{0}' twice", name)); }
                        else { strictModules.Add(name); }
                    }
                }
            }
        }

        if (errors.Count > 0) { throw new ArgumentException(Failed + string.Join("\n", errors)); }
        strict = strictModules;
    }

    public string ResolveRoot(string repositoryRoot)
    {
        if (root != null) { return root; }
        if (string.IsNullOrWhiteSpace(repositoryRoot))
        {
            throw new ArgumentException("JavaScriptConfig.ResolveRoot requires the repository root");
        }
        return Directory.Exists(Path.Combine(repositoryRoot, DefaultRoot)) ? DefaultRoot : FallbackRoot;
    }
}
