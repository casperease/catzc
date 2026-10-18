/*
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.Variants/types/TrackTypeEntry.cs
    folder: types
    name: track-type-entry
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

using System.Collections.Generic;

namespace Catzc.Base.Variants;

// One track type of the track-types registry: its id, its one-sentence definition, its role, and the module types it admits.
public sealed class TrackTypeEntry
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    public string id { get; }
    public string definition { get; }

    // 'deployable' (owns deployable-units) or 'holder' (is a module, ships nothing of its own).
    public string role { get; }

    // The module types a module of a track of this type may have.
    public IReadOnlyList<string> admits { get; }

    // The git attributes every file under a place of a track of this type gets in the generated .gitattributes, and why;
    // empty and null when the type gives none.
    public IReadOnlyList<string> gitAttributes { get; }
    public string gitWhy { get; }

    public TrackTypeEntry(string id, string definition, string role, IReadOnlyList<string> admits, IReadOnlyList<string> gitAttributes, string gitWhy)
    {
        this.id = id;
        this.definition = definition;
        this.role = role;
        this.admits = admits;
        this.gitAttributes = gitAttributes;
        this.gitWhy = gitWhy;
    }
}
