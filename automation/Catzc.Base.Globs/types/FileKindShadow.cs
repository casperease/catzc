/*
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.Globs/types/FileKindShadow.cs
    folder: types
    name: file-kind-shadow
    filetype: cs
    kind: type
    language: csharp
    track: automation
    tracktype: modules
    module: Catzc.Base.Globs
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    cites:
      - ADR-REPO-FILEMETA#2
---
*/

namespace Catzc.Base.Globs;

// A kind mostly shadowed by an earlier one that the registry's overlaps do not list: the finding of FileKindsConfig.Shadowing.
[Catzc.Base.Objects.ConsoleDisplay(nameof(by), nameof(hidden), nameof(taken), nameof(matched))]
public sealed class FileKindShadow
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    // The class whose globs match the files.
    public string hidden { get; }

    // The earlier kind that names them instead.
    public string by { get; }

    // How many of the class's matching files the earlier kind takes, and how many its globs match in all.
    public int taken { get; }
    public int matched { get; }

    public FileKindShadow(string hidden, string by, int taken, int matched)
    {
        this.hidden = hidden;
        this.by = by;
        this.taken = taken;
        this.matched = matched;
    }
}
