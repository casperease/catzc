/*
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.QualityGates/types/FormatResult.cs
    folder: types
    name: format-result
    filetype: cs
    kind: type
    language: csharp
    track: automation
    tracktype: modules
    module: Catzc.Base.QualityGates
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    page: docs/references/automation/catzc-base-qualitygates/types/FormatResult.cs.md
    test: automation/Catzc.Base.QualityGates/tests/types/FormatResult.Tests.ps1
---
*/

using System;
using System.Collections.Generic;

namespace Catzc.Base.QualityGates;

public sealed class FormatResult
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    public string Language { get; }
    public string Engine { get; }
    public IReadOnlyList<string> CheckedFiles { get; }
    public IReadOnlyList<string> ChangedFiles { get; }
    public bool DryRun { get; }

    // Files an imprint step found wrong but cannot repair, each with the problem, so a check fails on them and a rerun cannot hide them.
    public IReadOnlyDictionary<string, string> Unfixable { get; }

    public FormatResult(string language, string engine, string[] checkedFiles, string[] changedFiles, bool dryRun,
        System.Collections.IDictionary unfixable = null)
    {
        var problems = new Dictionary<string, string>();
        if (unfixable != null)
        {
            foreach (System.Collections.DictionaryEntry entry in unfixable)
            {
                problems[Convert.ToString(entry.Key, System.Globalization.CultureInfo.InvariantCulture)] =
                    Convert.ToString(entry.Value, System.Globalization.CultureInfo.InvariantCulture);
            }
        }
        Unfixable = problems;
        Language = language;
        Engine = engine;
        CheckedFiles = checkedFiles ?? Array.Empty<string>();
        ChangedFiles = changedFiles ?? Array.Empty<string>();
        DryRun = dryRun;
    }
}
