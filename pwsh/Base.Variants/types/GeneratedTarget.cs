namespace Catzc.Base.Variants;

// A generated target: the path or glob a writer writes, the writer, the class of the writer row it answers from, and whether git tracks it.
public sealed class GeneratedTarget
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    public string path { get; }

    public string generator { get; }

    // One of GeneratedWriterRow.Classes: what a roll-off may do with the target, and whether a change to it triggers its track.
    public string @class { get; }

    // True when the target is committed to the repository: a writer row's output of any class but untracked, a root config entry's own flag.
    public bool committed { get; }

    public GeneratedTarget(string path, string generator, string @class, bool committed = false)
    {
        this.path = path;
        this.generator = generator;
        this.@class = @class;
        this.committed = committed;
    }
}
