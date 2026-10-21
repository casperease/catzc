/*
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.QualityGates/types/FileHeadPolicy.cs
    folder: types
    name: file-head-policy
    filetype: cs
    role: type
    language: csharp
    track: pwsh
    tracktype: modules
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    test: pwsh/Catzc.Base.QualityGates/tests/types/FileHeadPolicy.Tests.ps1
    docs: "[FileHeadPolicy.cs.md](docs/references/pwsh/catzc-base-qualitygates/types/FileHeadPolicy.cs.md)"
    cites:
      - ADR-REPO-FILEMETA-HEADPOLICY
---
*/

using System;
using System.Collections;
using System.Collections.Generic;
using System.Globalization;

namespace Catzc.Base.QualityGates;

public sealed class FileHeadPolicy
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    public const HeadPolicy DefaultPolicy = HeadPolicy.Forbidden;

    static readonly string[] Allowed = { "default", "classes" };

    public HeadPolicy @default { get; }

    // Class patterns in registry order, each with its policy; the first pattern that matches a file's class decides.
    public IReadOnlyList<KeyValuePair<string, HeadPolicy>> classes { get; }

    public FileHeadPolicy(IDictionary raw)
    {
        @default = DefaultPolicy;
        var list = new List<KeyValuePair<string, HeadPolicy>>();
        if (raw != null)
        {
            foreach (object key in raw.Keys)
            {
                string name = Convert.ToString(key, CultureInfo.InvariantCulture);
                if (Array.IndexOf(Allowed, name) < 0)
                {
                    throw new ArgumentException(string.Format(CultureInfo.InvariantCulture,
                        "file-meta config: head_policy has unknown key '{0}' (allowed: {1})", name, string.Join(", ", Allowed)));
                }
            }
            if (raw.Contains("default") && raw["default"] != null)
            {
                @default = Parse("head_policy.default", raw["default"]);
            }
            if (raw.Contains("classes") && raw["classes"] != null)
            {
                if (!(raw["classes"] is IDictionary map))
                {
                    throw new ArgumentException("file-meta config: head_policy.classes must be a map of class to policy");
                }
                foreach (DictionaryEntry entry in map)
                {
                    string pattern = Convert.ToString(entry.Key, CultureInfo.InvariantCulture);
                    list.Add(new KeyValuePair<string, HeadPolicy>(pattern, Parse("head_policy.classes." + pattern, entry.Value)));
                }
            }
        }
        classes = list;
    }

    // A class entry decides first; an authored file in a code carrier takes the file-heads variant (ADR-REPO-VARIANT-FILEHEADS), else the default.
    public HeadPolicy For(string fileClass, bool codeCarrier = false, bool codeHeads = false)
    {
        foreach (KeyValuePair<string, HeadPolicy> entry in classes)
        {
            if (FileSelector.ClassMatches(entry.Key, fileClass)) { return entry.Value; }
        }
        if (codeCarrier) { return codeHeads ? HeadPolicy.Required : HeadPolicy.Forbidden; }
        return @default;
    }

    static HeadPolicy Parse(string where, object value)
    {
        string text = Convert.ToString(value, CultureInfo.InvariantCulture);
        switch (text)
        {
            case "required": return HeadPolicy.Required;
            case "optional": return HeadPolicy.Optional;
            case "forbidden": return HeadPolicy.Forbidden;
            case "config": return HeadPolicy.Config;
            default:
                throw new ArgumentException(string.Format(CultureInfo.InvariantCulture,
                    "file-meta config: {0} is '{1}' (allowed: required, optional, forbidden, config)", where, text));
        }
    }
}
