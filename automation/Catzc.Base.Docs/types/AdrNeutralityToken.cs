// AdrNeutralityCheck rejects a name that is not kebab-case and a pattern that does not compile; matching is case-sensitive.
// [ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)
// [comment:1](/docs/references/automation/catzc-base-docs/types/AdrNeutralityToken.cs.md#comment1)

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
