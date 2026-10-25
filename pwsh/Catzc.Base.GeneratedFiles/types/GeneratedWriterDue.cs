/*
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-generated-files/types/GeneratedWriterDue.cs.md"
  header: "generated"
---
*/

namespace Catzc.Base.GeneratedFiles;

// HasLists keeps a writer that declares nothing apart, so a caller can tell "nothing changed" from "this writer cannot say".
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
