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
      - ADR-REPO-FILEMETA#11
---
*/

namespace Catzc.Base.Globs;

// One intended overlap of the file-kinds registry: the earlier kind takes most of the later kind's files on purpose ([ADR-REPO-FILEMETA#11](/docs/adr/repository/file-meta.md#rule-adr-repo-filemeta11)).
public sealed class FileKindOverlap
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    public string Earlier { get; }
    public string Later { get; }

    public FileKindOverlap(string earlier, string later)
    {
        Earlier = earlier;
        Later = later;
    }
}
