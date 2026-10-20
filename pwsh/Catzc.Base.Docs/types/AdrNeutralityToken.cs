/*
---
catzc:
  immutable:
    repo_status: clean
    path: pwsh/Catzc.Base.Docs/types/AdrNeutralityToken.cs
    folder: types
    name: adr-neutrality-token
    filetype: cs
    role: type
    language: csharp
    track: pwsh
    tracktype: modules
    module: Catzc.Base.Docs
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    docs: "[AdrNeutralityToken.cs.md](docs/references/pwsh/catzc-base-docs/types/AdrNeutralityToken.cs.md)"
    cites:
      - ADR-AUTO-TYPES-SNAKECASEMIRRORSYAML
---
*/

using System.Collections.Generic;
using System.Text.RegularExpressions;

namespace Catzc.Base.Docs;

public sealed class AdrNeutralityToken
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    private readonly Regex compiled;

    public string name { get; }
    public string pattern { get; }

    internal AdrNeutralityToken(string name, string pattern, Regex compiled)
    {
        this.name = name;
        this.pattern = pattern;
        this.compiled = compiled;
    }

    // Every distinct text the pattern matches in one line, in order of first appearance.
    public IReadOnlyList<string> Find(string line)
    {
        List<string> found = new List<string>();
        if (string.IsNullOrEmpty(line)) { return found; }
        foreach (Match match in compiled.Matches(line))
        {
            if (!found.Contains(match.Value)) { found.Add(match.Value); }
        }
        return found;
    }
}
