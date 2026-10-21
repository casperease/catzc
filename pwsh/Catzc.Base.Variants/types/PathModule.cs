/*
---
catzc:
  immutable:
    with_body_sha: "75589a37bf27"
  edges:
    cites:
      - ADR-DSGN-TRACK-ONETECHSTACK
---
*/

namespace Catzc.Base.Variants;

// The module a path is placed in, and the module type that says what sort of module it is ([ADR-DSGN-TRACK-ONETECHSTACK](/docs/adr/design/tracks.md#rule-adr-dsgn-track-onetechstack)).
public sealed class PathModule
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    // The module's name.
    public string name { get; }

    // The id of the module type of the module-types registry.
    public string type { get; }

    // The path of the file under the module, '/'-separated: the file's own name for a module that is one file.
    public string tail { get; }

    public PathModule(string name, string type, string tail)
    {
        this.name = name;
        this.type = type;
        this.tail = tail;
    }
}
