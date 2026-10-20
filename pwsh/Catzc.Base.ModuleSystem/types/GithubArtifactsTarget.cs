/*
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.ModuleSystem/types/GithubArtifactsTarget.cs
    folder: types
    name: github-artifacts-target
    filetype: cs
    role: type
    language: csharp
    track: pwsh
    tracktype: modules
    module: Catzc.Base.ModuleSystem
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    docs: "[GithubArtifactsTarget.cs.md](docs/references/pwsh/catzc-base-modulesystem/types/GithubArtifactsTarget.cs.md)"
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
