/*
---
catzc:
  immutable:
    with_body_sha: "38c8d550ab7e"
  edges:
    test: pwsh/Catzc.Base.Languages/tests/types/DotnetConfig.Tests.ps1
    docs: "[DotnetConfig.cs.md](docs/references/pwsh/catzc-base-languages/types/DotnetConfig.cs.md)"
    cites:
      - ADR-AUTO-TYPES-DEBUGANYCPU
---
*/

using System;
using System.Collections;
using System.Collections.Generic;
using System.Globalization;
using System.Text.RegularExpressions;

namespace Catzc.Base.Languages;

public sealed class DotnetConfig : Catzc.Base.Objects.DictionaryRecord
{
    public const string DefaultConfiguration = "Debug";

    public const string DefaultPlatform = "Any CPU";

    private const string Failed = "dotnet config validation failed:\n";
    private static readonly string[] AllowedKeys = { "configuration", "platform" };
    private static readonly Regex Name = new Regex(@"^[A-Za-z][A-Za-z0-9]*( [A-Za-z0-9]+)*$");

    public string configuration { get; }

    public string platform { get; }

    public DotnetConfig(IDictionary raw)
    {
        List<string> errors = new List<string>();
        configuration = DefaultConfiguration;
        platform = DefaultPlatform;

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

            foreach (string key in AllowedKeys)
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
        }

        if (errors.Count > 0) { throw new ArgumentException(Failed + string.Join("\n", errors)); }
    }

    // The platform as a .csproj spells it: MSBuild writes 'Any CPU' as 'AnyCPU' in a project, with the space in a solution.
    public string ProjectPlatform() => platform.Replace(" ", "");

    // The one '<configuration>|<platform>' pair a solution declares and maps every project to.
    public string SolutionPair() => configuration + "|" + platform;
}
