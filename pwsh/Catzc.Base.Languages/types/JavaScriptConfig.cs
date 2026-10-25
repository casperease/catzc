/*
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-languages/types/JavaScriptConfig.cs.md"
  header: "generated"
---
*/

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

    private const string Failed = "javascript config validation failed:\n";
    private static readonly string[] AllowedKeys = { "root" };
    private static readonly Regex Root = new Regex(@"^[A-Za-z0-9._-]+(/[A-Za-z0-9._-]+)*$");

    // The declared JavaScript root folder, repository-relative ('/'-separated). Null when the file declares none.
    public string root { get; }

    public JavaScriptConfig(IDictionary raw)
    {
        List<string> errors = new List<string>();
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
        }

        if (errors.Count > 0) { throw new ArgumentException(Failed + string.Join("\n", errors)); }
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
