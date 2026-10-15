/*
---
catzc:
  derived:
    path: automation/Catzc.Base.ModuleSystem/types/AdoArtifactsTarget.cs
    kind: type
    module: Catzc.Base.ModuleSystem
    adrs: []
---
*/

// Validation is the shared target shape, so this type only declares the organization, project and feed coordinates.
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
