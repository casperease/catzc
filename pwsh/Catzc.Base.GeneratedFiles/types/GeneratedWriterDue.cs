/*
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-quality-gates/types/GeneratedWriterDue.cs.md"
  warning: "Generated Header"
---
*/

namespace Catzc.Base.GeneratedFiles;

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
