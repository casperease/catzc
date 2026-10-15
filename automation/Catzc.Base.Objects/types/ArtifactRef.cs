// An immutable, dual-form descriptor for a published-artifact file — one build stage produces it and writes it into an artifact folder;...
// [ADR-AUTO-PATH#10](/docs/adr/automation/path-representation.md#rule-adr-auto-path10)
// [comment:1](/docs/references/automation/catzc-base-objects/types/ArtifactRef.cs.md#comment1)

using System;
using System.IO;

namespace Catzc.Base.Objects;

public sealed class ArtifactRef
{
    public string relative { get; }   // artifact-internal, forward slashes — the portable identity
    public string absolute { get; }   // resolved in the producing context — audit/reference only

    public ArtifactRef(string relative, string absolute)
    {
        if (string.IsNullOrWhiteSpace(relative)) { throw new ArgumentException("ArtifactRef.relative is required"); }
        if (string.IsNullOrWhiteSpace(absolute)) { throw new ArgumentException("ArtifactRef.absolute is required"); }
        string slashed = relative.Replace('\\', '/').Trim();
        if (slashed.StartsWith("/") || (slashed.Length >= 2 && slashed[1] == ':'))
        {
            throw new ArgumentException("ArtifactRef.relative must be artifact-relative (not rooted): " + relative);
        }
        if (slashed.StartsWith("../") || slashed == "..")
        {
            throw new ArgumentException("ArtifactRef.relative must stay within the artifact root: " + relative);
        }
        this.relative = slashed;
        this.absolute = absolute;
    }

    // The controlled factory: take a raw path (absolute, or relative to the artifact root) and the artifact root, and materialize both...
    // [comment:2](/docs/references/automation/catzc-base-objects/types/ArtifactRef.cs.md#comment2)
    public static ArtifactRef Materialize(string rawPath, string artifactRoot)
    {
        if (string.IsNullOrWhiteSpace(rawPath)) { throw new ArgumentException("rawPath is required"); }
        if (string.IsNullOrWhiteSpace(artifactRoot)) { throw new ArgumentException("artifactRoot is required"); }

        string root = Path.GetFullPath(artifactRoot);
        string full = Path.IsPathRooted(rawPath) ? Path.GetFullPath(rawPath) : Path.GetFullPath(Path.Combine(root, rawPath));
        string fromRoot = Path.GetRelativePath(root, full).Replace('\\', '/');
        if (fromRoot.StartsWith("..") || Path.IsPathRooted(fromRoot))
        {
            throw new ArgumentException("ArtifactRef must live under the artifact root, but is not: " + rawPath);
        }

        return new ArtifactRef(fromRoot, full);
    }

    // Re-resolve to an absolute path under the GIVEN (consumer's) artifact root.
    // [comment:3](/docs/references/automation/catzc-base-objects/types/ArtifactRef.cs.md#comment3)
    public string ResolveAt(string artifactRoot)
    {
        if (string.IsNullOrWhiteSpace(artifactRoot)) { throw new ArgumentException("artifactRoot is required"); }
        return Path.GetFullPath(Path.Combine(artifactRoot, relative));
    }

    // The consumer-side check: does the artifact exist under the given artifact root (file or folder)?
    public bool ExistsAt(string artifactRoot)
    {
        string resolved = ResolveAt(artifactRoot);
        return File.Exists(resolved) || Directory.Exists(resolved);
    }

    public override string ToString()
    {
        return relative;
    }
}
