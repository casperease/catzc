/*
---
catzc:
  derived:
    path: automation/Catzc.Base.ModuleSystem/types/ArtifactsConfig.cs
    kind: type
    module: Catzc.Base.ModuleSystem
    adrs:
      - ADR-AUTO-TEST#24
      - ADR-AUTO-TYPES#8
---
*/

// The targets are inert config surface: no publish code reads them yet, but the file still loads validated.
// [ADR-AUTO-TEST#24](/docs/adr/automation/test-automation.md#rule-adr-auto-test24),
// [ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)
// [comment:1](/docs/references/automation/catzc-base-modulesystem/types/ArtifactsConfig.cs.md#comment1)

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
