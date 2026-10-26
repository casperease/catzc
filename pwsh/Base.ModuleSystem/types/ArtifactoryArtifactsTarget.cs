/*
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-module-system/types/ArtifactoryArtifactsTarget.cs.md"
  header: "generated"
---
*/

namespace Catzc.Base.ModuleSystem;

// The JFrog Artifactory target: the server URL and repository the gold module-manifest artifact is promoted to.
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
