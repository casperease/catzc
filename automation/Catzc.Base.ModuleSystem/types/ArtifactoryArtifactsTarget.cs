// The JFrog Artifactory publish target of configs/artifacts.yml (`artifactory:`): the server URL and repository the
// gold module-manifest artifact is promoted to. Validation is the shared target shape (ArtifactsTarget).

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
