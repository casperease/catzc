// The outcome of formatting one file language (Format-Code -PassThru): the language, the engine languages.yml names for
// it, every file the engine checked, and the files it changed — or, under -DryRun, would change. Paths are absolute,
// since Format-Code -Path also formats files outside the repository (a built module manifest); Test-Formatting turns
// each changed file into one issue naming its repository-relative path.

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
