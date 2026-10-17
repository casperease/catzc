/*
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.Slides/types/SlidesConfig.cs
    folder: types
    name: slides-config
    filetype: cs
    kind: type
    language: csharp
    track: automation
    tracktype: modules
    module: Catzc.Base.Slides
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    test: automation/Catzc.Base.Slides/tests/types/SlidesConfig.Tests.ps1
---
*/

using System;
using System.Collections;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.Linq;

namespace Catzc.Base.Slides;

public sealed class SlidesConfig
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    public const string DefaultKit = ".claude/slides";
    public const string KitDefaultsFile = "slides.yml";
    public const string PatternsFolder = "patterns";
    public const string SlideSuffix = ".slide.md";
    public const string DeckFile = "deck.md";

    private static readonly string[] AllowedKeys = { "kit" };

    public string kit { get; }

    public SlidesConfig(IDictionary raw)
    {
        List<string> errors = new List<string>();
        string kitValue = DefaultKit;

        if (raw != null)
        {
            foreach (object key in raw.Keys)
            {
                string name = Convert.ToString(key, CultureInfo.InvariantCulture);
                if (Array.IndexOf(AllowedKeys, name) < 0)
                {
                    errors.Add(string.Format(CultureInfo.InvariantCulture, "unknown key '{0}' (allowed: {1})", name, string.Join(", ", AllowedKeys)));
                }
            }

            if (raw.Contains("kit") && raw["kit"] != null)
            {
                string value = raw["kit"] as string;
                bool communicationForm = !string.IsNullOrWhiteSpace(value)
                    && !Path.IsPathRooted(value)
                    && !value.StartsWith("/", StringComparison.Ordinal)
                    && value.IndexOf('\\') < 0
                    && !value.Split('/').Any(segment => segment == "." || segment == "..");
                if (!communicationForm)
                {
                    errors.Add(string.Format(CultureInfo.InvariantCulture, "kit '{0}' must be a repository-relative folder in communication form: '/'-separated, no '.' or '..' segment, not absolute", value));
                }
                else
                {
                    kitValue = value.TrimEnd('/');
                }
            }
        }

        if (errors.Count > 0)
        {
            throw new ArgumentException("slides.yml: " + string.Join("; ", errors));
        }

        kit = kitValue;
    }
}
