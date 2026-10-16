/*
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.Globs/types/FileKindMatch.cs
    folder: types
    name: file-kind-match
    filetype: cs
    kind: type
    language: csharp
    track: automation
    tracktype: modules
    module: Catzc.Base.Globs
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    cites:
      - ADR-REPO-FILEMETA#2
---
*/

namespace Catzc.Base.Globs;

// What the file-kinds registry names for one path: its kind, its subkind when it has one, and the kind's definition.
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
