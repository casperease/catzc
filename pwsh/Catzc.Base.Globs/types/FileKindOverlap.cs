/*
---
catzc:
  immutable:
    with_body_sha: "42c783e67123"
  edges:
    cites:
      - ADR-REPO-FILEMETA-ROLE
---
*/

namespace Catzc.Base.Globs;

// One intended overlap of the file-kinds registry: the earlier kind takes most of the later kind's files on purpose ([ADR-REPO-FILEMETA-ROLE](/docs/drs/repository/file-meta.md#rule-adr-repo-filemeta-role)).
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
