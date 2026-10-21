/*
---
catzc:
  immutable:
    with_body_sha: "21af09922fac"
  edges:
    docs: "[DrsNeutralityToken.cs.md](docs/references/pwsh/catzc-base-docs/types/DrsNeutralityToken.cs.md)"
    cites:
      - ADR-BCL-TYPES-SNAKECASEMIRRORSYAML
---
*/

using System.Collections.Generic;
using System.Text.RegularExpressions;

namespace Catzc.Base.Drs;

public sealed class DrsNeutralityToken
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    private readonly Regex compiled;

    public string name { get; }
    public string pattern { get; }

    internal DrsNeutralityToken(string name, string pattern, Regex compiled)
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
