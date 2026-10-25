/*
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-variants/types/TrackTypeEntry.cs.md"
  header: "generated"
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
