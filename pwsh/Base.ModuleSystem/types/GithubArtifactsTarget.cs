/*
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-module-system/types/GithubArtifactsTarget.cs.md"
  header: "generated"
---
*/

namespace Catzc.Base.ModuleSystem;

public sealed class GithubArtifactsTarget : ArtifactsTarget
{
    private static readonly string[] CoordinateKeys = { "owner", "repository", "feed" };

    // The GitHub user or organization that owns the repository.
    public string owner { get; }

    // The repository the package is published under.
    public string repository { get; }

    // The GitHub Packages feed.
    public string feed { get; }

    public GithubArtifactsTarget(object raw) : base("github", raw, CoordinateKeys)
    {
        owner = Coordinate("owner");
        repository = Coordinate("repository");
        feed = Coordinate("feed");
    }
}
