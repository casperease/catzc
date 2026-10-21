/*
---
catzc:
  immutable:
    with_body_sha: e755342a284b
  edges:
    docs: "[ArtifactoryArtifactsTarget.cs.md](docs/references/pwsh/catzc-base-module-system/types/ArtifactoryArtifactsTarget.cs.md)"
---
*/

namespace Catzc.Base.ModuleSystem;

public sealed class ArtifactoryArtifactsTarget : ArtifactsTarget
{
    private static readonly string[] CoordinateKeys = { "url", "repository" };

    // The Artifactory server URL.
    public string url { get; }

    // The Artifactory repository the package is published to.
    public string repository { get; }

    public ArtifactoryArtifactsTarget(object raw) : base("artifactory", raw, CoordinateKeys)
    {
        url = Coordinate("url");
        repository = Coordinate("repository");
    }
}
