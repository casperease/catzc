/*
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.Git/types/GitIgnorePattern.cs
    folder: types
    name: git-ignore-pattern
    filetype: cs
    role: type
    language: csharp
    track: pwsh
    tracktype: modules
    module: Catzc.Base.Git
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    test: pwsh/Catzc.Base.Git/tests/types/GitIgnorePattern.Tests.ps1
    docs: "[GitIgnorePattern.cs.md](docs/references/pwsh/catzc-base-git/types/GitIgnorePattern.cs.md)"
---
*/

using System;
using System.Collections;

namespace Catzc.Base.Git;

public sealed class GitIgnorePattern : Catzc.Base.Objects.DictionaryRecord
{
    // The git wildmatch pattern, verbatim (including any leading '!' un-ignore or '/' anchor). Required.
    public string pattern { get; }

    // Optional short note rendered as an aligned trailing comment on the pattern's line.
    public string note { get; }

    public GitIgnorePattern(string bare)
    {
        if (string.IsNullOrWhiteSpace(bare)) { throw new ArgumentException("a gitignore pattern must be a non-empty string"); }
        pattern = bare;
        note = null;
    }

    public GitIgnorePattern(IDictionary d)
    {
        if (d == null) { throw new ArgumentException("GitIgnorePattern requires a string or a { pattern, note } mapping"); }
        pattern = Req(d, "pattern");
        note = OptStr(d, "note");
    }
}
