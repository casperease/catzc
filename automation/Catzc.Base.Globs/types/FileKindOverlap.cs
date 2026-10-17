/*
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.Globs/types/FileKindOverlap.cs
    folder: types
    name: file-kind-overlap
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

// One intended overlap of the file-kinds registry: the earlier kind takes most of the later kind's files on purpose.
public sealed class FileKindOverlap
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    public string earlier { get; }
    public string later { get; }

    public FileKindOverlap(string earlier, string later)
    {
        this.earlier = earlier;
        this.later = later;
    }
}
