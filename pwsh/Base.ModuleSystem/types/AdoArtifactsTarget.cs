namespace Catzc.Base.ModuleSystem;

// The Azure DevOps Artifacts target: the organization, project and feed the gold module-manifest artifact is promoted to.
public sealed class AdoArtifactsTarget : ArtifactsTarget
{
    private static readonly string[] CoordinateKeys = { "organization", "project", "feed" };

    // The Azure DevOps organization.
    public string organization { get; }

    // The project that owns the feed.
    public string project { get; }

    // The Azure Artifacts feed name.
    public string feed { get; }

    public AdoArtifactsTarget(object raw) : base("ado", raw, CoordinateKeys)
    {
        organization = Coordinate("organization");
        project = Coordinate("project");
        feed = Coordinate("feed");
    }
}
