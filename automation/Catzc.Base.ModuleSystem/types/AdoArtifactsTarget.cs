// The Azure DevOps Artifacts publish target of configs/artifacts.yml (`ado:`): the organization, project, and feed the gold...
// [comment:1](/docs/references/automation/catzc-base-modulesystem/types/AdoArtifactsTarget.cs.md#comment1)

namespace Catzc.Base.ModuleSystem;

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
