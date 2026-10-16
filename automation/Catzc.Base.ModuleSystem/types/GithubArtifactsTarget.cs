/*
---
catzc:
  derived:
    path: automation/Catzc.Base.ModuleSystem/types/GithubArtifactsTarget.cs
    kind: type
    language: csharp
    filetype: cs
    track: automation
    module: Catzc.Base.ModuleSystem
    moduletype: pwsh-folder-module
    bundle: azure
    relatives:
      page: docs/references/automation/catzc-base-modulesystem/types/GithubArtifactsTarget.cs.md
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
