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
