namespace Catzc.Base.QualityGates;

public sealed class GeneratedWriterDue
{
    public string Name { get; }
    public bool Due { get; }
    public bool HasLists { get; }

    public GeneratedWriterDue(string name, bool due, bool hasLists)
    {
        Name = name;
        Due = due;
        HasLists = hasLists;
    }

    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);
}
