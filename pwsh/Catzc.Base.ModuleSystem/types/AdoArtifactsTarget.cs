/*
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.ModuleSystem/types/AdoArtifactsTarget.cs
    folder: types
    name: ado-artifacts-target
    filetype: cs
    role: type
    language: csharp
    track: pwsh
    tracktype: modules
    module: Catzc.Base.ModuleSystem
    moduletype: pwsh-folder
    catzc_bundle: azure
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
