/*
---
catzc:
  derived:
    path: automation/Catzc.Base.ModuleSystem/types/ArtifactoryArtifactsTarget.cs
    folder: types
    name: artifactory-artifacts-target
    filetype: cs
    kind: type
    language: csharp
    track: automation
    module: Catzc.Base.ModuleSystem
    moduletype: pwsh-folder
    catzc_bundle: azure
    relatives:
      page: docs/references/automation/catzc-base-modulesystem/types/ArtifactoryArtifactsTarget.cs.md
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
