namespace Catzc.Base.Variants;

// One member of one track with its two facts, flat so a filter, a gate or a report reads it without the track object.
public sealed class TrackMember
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    // The name of the track that holds the member.
    public string track { get; }

    public string path { get; }

    public bool generated { get; }

    public bool committed { get; }

    public TrackMember(string track, VariantMember member)
    {
        this.track = track;
        path = member.path;
        generated = member.generated;
        committed = member.committed;
    }
}
