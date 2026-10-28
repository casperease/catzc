namespace Catzc.Base.Variants;

// A generated target: the path or glob a writer writes, the writer, and the class of the writer row it answers from.
public sealed class GeneratedTarget
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    public string path { get; }

    public string generator { get; }

    // One of GeneratedWriterRow.Classes: what a roll-off may do with the target, and whether a change to it triggers its track.
    public string @class { get; }

    public GeneratedTarget(string path, string generator, string @class)
    {
        this.path = path;
        this.generator = generator;
        this.@class = @class;
    }
}
