/*
---
catzc:
  immutable:
    with_body_sha: "395a4a1fabb8"
  edges:
    docs: "[AdoArtifactsTarget.cs.md](docs/references/pwsh/catzc-base-modulesystem/types/AdoArtifactsTarget.cs.md)"
---
*/

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
