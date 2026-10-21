/*
---
catzc:
  immutable:
    with_body_sha: "1ddb43ed239b"
  edges:
    cites:
      - ADR-AUTO-IDIOM-LANGUAGEIDIOM
---
*/

using System;

namespace Catzc.Base.Languages;

// One misnamed folder or file and the idiomatic name its language gives it (ADR-AUTO-IDIOM-LANGUAGEIDIOM).
[Catzc.Base.Objects.ConsoleDisplay("path", "target")]
public sealed class PathRename
{
    // The repository path as tracked: a folder path for a folder, the file path for a file.
    public string path { get; }

    // folder or file.
    public string kind { get; }

    // The language whose naming judges it.
    public string language { get; }

    // The cases its language allows, for the finding.
    public string cases { get; }

    // The path with its last segment renamed to the idiom; null when the case has no rendering for the name, so a person renames it.
    public string target { get; }

    public PathRename(string path, string kind, string language, string cases, string target)
    {
        if (string.IsNullOrEmpty(path)) { throw new ArgumentException("PathRename.path is required"); }
        if (kind != "folder" && kind != "file") { throw new ArgumentException("PathRename.kind is folder or file, not '" + kind + "'"); }
        this.path = path;
        this.kind = kind;
        this.language = language;
        this.cases = cases;
        this.target = target;
    }

    // The finding the naming gate reports for it.
    public string Finding() => kind == "folder"
        ? path + "/: the folder is not " + cases + " (" + language + ")"
        : path + ": the file name is not " + cases + " (" + language + ")";

    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);
}
