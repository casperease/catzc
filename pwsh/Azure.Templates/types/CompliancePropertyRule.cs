namespace Catzc.Azure.Templates;

// One declared property rule of the compliance gate: the value at path, on every deployed resource of type, resolves to equals or is absent.
public sealed class CompliancePropertyRule
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    public string type { get; }
    public string path { get; }
    public object equals { get; }
    public bool absent { get; }
    public string reason { get; }

    public CompliancePropertyRule(string type, string path, object equals, bool absent, string reason)
    {
        this.type = type;
        this.path = path;
        this.equals = equals;
        this.absent = absent;
        this.reason = reason;
    }
}
