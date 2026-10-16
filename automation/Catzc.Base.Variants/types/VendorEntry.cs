/*
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.Variants/types/VendorEntry.cs
    folder: types
    name: vendor-entry
    filetype: cs
    kind: type
    language: csharp
    track: automation
    tracktype: modules
    module: Catzc.Base.Variants
    moduletype: pwsh-folder
    catzc_bundle: azure
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
