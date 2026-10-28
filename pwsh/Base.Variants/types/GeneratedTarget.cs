namespace Catzc.Base.Variants;

// A generated target: the path or glob a writer writes, and the writer.
public sealed class GeneratedTarget
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    public string path { get; }

    public string generator { get; }

    public GeneratedTarget(string path, string generator)
    {
        this.path = path;
        this.generator = generator;
    }
}
