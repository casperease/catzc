namespace Catzc.Base.Globs;

// A kind mostly shadowed by an earlier one that the registry's overlaps do not list: the finding of FileKindsConfig.Shadowing ([ADR-REPO-FILEMETA#11](/docs/adr/repository/file-meta.md#rule-adr-repo-filemeta11)).
[Catzc.Base.Objects.ConsoleDisplay(nameof(By), nameof(Hidden), nameof(Taken), nameof(Matched))]
public sealed class FileKindShadow
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    // The class whose globs match the files.
    public string Hidden { get; }

    // The earlier kind that names them instead.
    public string By { get; }

    // How many of the class's matching files the earlier kind takes, and how many its globs match in all.
    public int Taken { get; }
    public int Matched { get; }

    public FileKindShadow(string hidden, string by, int taken, int matched)
    {
        Hidden = hidden;
        By = by;
        Taken = taken;
        Matched = matched;
    }
}
