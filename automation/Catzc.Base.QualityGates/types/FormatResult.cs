// Paths are absolute because Format-Code -Path also formats files outside the repository, such as a built module manifest.
// [comment:1](/docs/references/automation/catzc-base-qualitygates/types/FormatResult.cs.md#comment1)

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

    public FormatResult(string language, string engine, string[] checkedFiles, string[] changedFiles, bool dryRun)
    {
        Language = language;
        Engine = engine;
        CheckedFiles = checkedFiles ?? Array.Empty<string>();
        ChangedFiles = changedFiles ?? Array.Empty<string>();
        DryRun = dryRun;
    }
}
