namespace Catzc.Base.GeneratedFiles;

public sealed class GeneratedWriterDue
{
    public string Name { get; }
    public bool Due { get; }

    public GeneratedWriterDue(string name, bool due)
    {
        Name = name;
        Due = due;
    }

    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);
}
