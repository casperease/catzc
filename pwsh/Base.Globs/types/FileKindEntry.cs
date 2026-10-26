using System.Collections.Generic;
using System.Linq;
using Catzc.Base.Objects;

namespace Catzc.Base.Globs;

// One entry of the file-kinds registry: a kind, or one of its subkinds, with its definition and the globs that select it ([ADR-REPO-FILEMETA-METAKIND](/docs/drs/repository/file-meta.md#rule-adr-repo-filemeta-metakind)).
public sealed class FileKindEntry
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    // The kind's name, which is the role its files play; a head writes it as role.
    public string role { get; }

    // Null for the kind's own entry.
    public string subkind { get; }

    public string definition { get; }
    public IReadOnlyList<string> files { get; }

    // The kind's subkinds in precedence order; empty for a subkind.
    public IReadOnlyList<FileKindEntry> subkinds { get; }

    // The git attributes the entry's own files get in the generated .gitattributes, and why; empty and null when it gives none.
    public IReadOnlyList<string> gitAttributes { get; }
    public string gitWhy { get; }

    readonly List<GlobPattern> patterns;

    public FileKindEntry(string role, string subkind, string definition, IReadOnlyList<string> files, IReadOnlyList<FileKindEntry> subkinds,
        IReadOnlyList<string> gitAttributes, string gitWhy)
    {
        this.role = role;
        this.subkind = subkind;
        this.definition = definition;
        this.files = files;
        this.subkinds = subkinds;
        this.gitAttributes = gitAttributes;
        this.gitWhy = gitWhy;
        patterns = files.Select(glob => new GlobPattern(glob)).ToList();
    }

    public bool Matches(string path) => patterns.Any(pattern => pattern.Matches(path));
}
