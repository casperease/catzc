/*
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-variants/types/VariantMember.cs.md"
  header: "generated"
---
*/

using System;

namespace Catzc.Base.Variants;

public sealed class VariantMember
{
    private static readonly char[] WildcardCharacters = { '*', '?', '[' };

    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    // The repository-relative path with '/' separators (e.g. pwsh, .github/workflows, importer.ps1).
    public string path { get; }

    // Whether a writer renders the member rather than a person authoring it.
    public bool generated { get; }

    // Whether git tracks the member, or it is gitignored.
    public bool committed { get; }

    // Whether the path is a glob that names files (e.g. pwsh/*/*.psd1) rather than one folder or file.
    public bool glob { get; }

    private readonly Catzc.Base.Objects.GlobPattern pattern;

    // A plain path is the common member: authored and committed.
    public VariantMember(string path) : this(path, false, true) { }

    public VariantMember(string path, bool generated, bool committed)
    {
        if (string.IsNullOrEmpty(path))
        {
            throw new ArgumentException("a track member needs a path", "path");
        }
        this.glob = path.IndexOfAny(WildcardCharacters) >= 0;
        // The glob dialect's own refusals name a malformed glob member.
        this.pattern = this.glob ? new Catzc.Base.Objects.GlobPattern(path) : null;
        this.path = path;
        this.generated = generated;
        this.committed = committed;
    }

    public bool Contains(string relativePath)
    {
        if (string.IsNullOrEmpty(relativePath)) { return false; }
        return glob
            ? pattern.Matches(relativePath)
            : relativePath == path || relativePath.StartsWith(path + "/", StringComparison.Ordinal);
    }
}
