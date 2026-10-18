/*
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.Variants/types/PathModule.cs
    folder: types
    name: path-module
    filetype: cs
    kind: type
    language: csharp
    track: automation
    tracktype: modules
    module: Catzc.Base.Variants
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    cites:
      - ADR-DSGN-TRACK#3
---
*/

namespace Catzc.Base.Variants;

// The module a path is placed in, and the module type that says what sort of module it is ([ADR-DSGN-TRACK#3](/docs/adr/design/tracks.md#rule-adr-dsgn-track3)).
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
