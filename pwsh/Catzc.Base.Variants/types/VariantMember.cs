using System;

namespace Catzc.Base.Variants;

// One member of a track: a folder or a file, with its two facts (DDR-TRACK-TRACKISPLACEDCLUSTER).
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

    // A plain path is the common member: authored and committed.
    public VariantMember(string path) : this(path, false, true) { }

    public VariantMember(string path, bool generated, bool committed)
    {
        if (string.IsNullOrEmpty(path))
        {
            throw new ArgumentException("a track member needs a path", "path");
        }
        if (path.IndexOfAny(WildcardCharacters) >= 0)
        {
            throw new ArgumentException(string.Format("track member '{0}' is a glob; glob members wait on the step that first needs one", path), "path");
        }
        this.path = path;
        this.generated = generated;
        this.committed = committed;
    }
}
