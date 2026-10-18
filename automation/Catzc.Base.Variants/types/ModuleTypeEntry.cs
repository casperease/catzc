using System.Collections.Generic;

namespace Catzc.Base.Variants;

// One module type of the module-types registry: its id, its one-sentence definition, and the places its modules are found in ([ADR-DSGN-TRACK#3](/docs/adr/design/tracks.md#rule-adr-dsgn-track3)).
public sealed class ModuleTypeEntry
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    public string id { get; }
    public string definition { get; }

    // In precedence order: the first place that names a module for a path wins.
    public IReadOnlyList<ModulePlace> places { get; }

    public ModuleTypeEntry(string id, string definition, IReadOnlyList<ModulePlace> places)
    {
        this.id = id;
        this.definition = definition;
        this.places = places;
    }
}
