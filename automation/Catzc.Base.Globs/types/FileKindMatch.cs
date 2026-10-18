namespace Catzc.Base.Globs;

// What the file-kinds registry names for one path: its kind, its subkind when it has one, and the kind's definition ([ADR-REPO-FILEMETA#2](/docs/adr/repository/file-meta.md#rule-adr-repo-filemeta2)).
public sealed class FileKindMatch
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    public string kind { get; }

    // Null when the file has none.
    public string subkind { get; }

    // Null for the default kind, which no entry defines.
    public string definition { get; }

    // What a selector matches: the kind alone, or kind/subkind.
    public string Class => subkind == null ? kind : kind + "/" + subkind;

    public FileKindMatch(string kind, string subkind, string definition)
    {
        this.kind = kind;
        this.subkind = subkind;
        this.definition = definition;
    }
}
