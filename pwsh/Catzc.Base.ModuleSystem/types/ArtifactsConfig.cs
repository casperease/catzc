/*
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.ModuleSystem/types/ArtifactsConfig.cs
    folder: types
    name: artifacts-config
    filetype: cs
    role: type
    language: csharp
    track: pwsh
    tracktype: modules
    module: Catzc.Base.ModuleSystem
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    test: pwsh/Catzc.Base.ModuleSystem/tests/types/ArtifactsConfig.Tests.ps1
    docs: "[ArtifactsConfig.cs.md](docs/references/pwsh/catzc-base-modulesystem/types/ArtifactsConfig.cs.md)"
    cites:
      - ADR-AUTO-TEST-BUILDVERIFICATIONTEST
      - ADR-BCL-TYPES-SNAKECASEMIRRORSYAML
---
*/

using System;
using System.Collections;
using System.Collections.Generic;

namespace Catzc.Base.ModuleSystem;

public sealed class ArtifactsConfig : Catzc.Base.Objects.DictionaryRecord
{
    private const string Failed = "artifacts configuration validation failed:\n";
    private static readonly string[] AllowedKeys = { "ado", "github", "artifactory" };

    // The Azure DevOps Artifacts target.
    public AdoArtifactsTarget ado { get; }

    // The GitHub Packages target.
    public GithubArtifactsTarget github { get; }

    // The JFrog Artifactory target.
    public ArtifactoryArtifactsTarget artifactory { get; }

    public ArtifactsConfig(IDictionary raw)
    {
        List<string> errors = new List<string>();
        if (raw == null) { throw new ArgumentException(Failed + "the configuration must be a mapping"); }

        foreach (object k in raw.Keys)
        {
            string key = k == null ? null : k.ToString();
            if (Array.IndexOf(AllowedKeys, key) < 0)
            {
                errors.Add(string.Format("unknown top-level key '{0}' (allowed: {1})", key, string.Join(", ", AllowedKeys)));
            }
        }
        foreach (string key in AllowedKeys)
        {
            if (!raw.Contains(key)) { errors.Add(string.Format("Missing required top-level key: '{0}'", key)); }
        }

        if (raw.Contains("ado"))
        {
            try { ado = new AdoArtifactsTarget(raw["ado"]); }
            catch (ArgumentException ex) { errors.Add(ex.Message); }
        }
        if (raw.Contains("github"))
        {
            try { github = new GithubArtifactsTarget(raw["github"]); }
            catch (ArgumentException ex) { errors.Add(ex.Message); }
        }
        if (raw.Contains("artifactory"))
        {
            try { artifactory = new ArtifactoryArtifactsTarget(raw["artifactory"]); }
            catch (ArgumentException ex) { errors.Add(ex.Message); }
        }

        if (errors.Count > 0) { throw new ArgumentException(Failed + string.Join("\n", errors)); }
    }
}
