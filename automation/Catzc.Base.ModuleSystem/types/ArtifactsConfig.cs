// The publish targets of configs/artifacts.yml: the feeds a CI build promotes the versioned, immutable gold
// module-manifest artifact to (the BVT's gold output,
// [ADR-AUTO-TEST#24](/docs/adr/automation/test-automation.md#rule-adr-auto-test24)). No publish code reads the
// targets yet — they are inert config surface — but the file still loads validated. Constructing an instance MAPS
// and VALIDATES the parsed YAML, collecting every violation into one throw. Registered in
// Catzc.Base.Config/configs/configs.yml (type: Catzc.Base.ModuleSystem.ArtifactsConfig), so
// Get-Config -Config artifacts returns this typed model. Mirrors the YAML mapping (snake_case keys,
// [ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)).
//
// Load-time rules:
//   - exactly the top-level keys 'ado', 'github', and 'artifactory', each required;
//   - each is a well-formed publish target (ArtifactsTarget: 'enabled' plus that target's coordinates).

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
