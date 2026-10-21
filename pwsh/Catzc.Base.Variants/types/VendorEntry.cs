/*
---
catzc:
  immutable:
    with_body_sha: "9d4da4604c2c"
---
*/

namespace Catzc.Base.Variants;

// One vendor of the track-types registry: the platform or tool that reads a track's files, with its one-sentence definition.
public sealed class VendorEntry
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    public string id { get; }
    public string definition { get; }

    public VendorEntry(string id, string definition)
    {
        this.id = id;
        this.definition = definition;
    }
}
