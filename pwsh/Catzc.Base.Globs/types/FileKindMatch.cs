namespace Catzc.Base.Globs;

// What the file-kinds registry names for one path: the role its kind gives it, its subkind when it has one, and the kind's definition ([ADR-REPO-FILEMETA-METAKIND](/docs/adr/repository/file-meta.md#rule-adr-repo-filemeta-metakind)).
public sealed class FileKindMatch
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    // The name of the kind that selects the file, which is the role the file plays.
    public string role { get; }

    // Null when the file has none.
    public string subkind { get; }

    // Null for the default kind, which no entry defines.
    public string definition { get; }

    // What a selector matches: the role alone, or role/subkind.
    public string Class => subkind == null ? role : role + "/" + subkind;

    public FileKindMatch(string role, string subkind, string definition)
    {
        this.role = role;
        this.subkind = subkind;
        this.definition = definition;
    }
}
