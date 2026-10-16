/*
---
catzc:
  derived:
    path: automation/Catzc.Base.ModuleSystem/types/AdoArtifactsTarget.cs
    kind: type
    language: csharp
    filetype: cs
    track: automation
    module: Catzc.Base.ModuleSystem
    moduletype: pwsh-folder-module
    bundle: azure
    relatives:
      page: docs/references/automation/catzc-base-modulesystem/types/AdoArtifactsTarget.cs.md
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
