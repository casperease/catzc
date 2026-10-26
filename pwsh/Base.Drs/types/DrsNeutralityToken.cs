using System.Collections.Generic;
using System.Text.RegularExpressions;

namespace Catzc.Base.Drs;

// One forbidden token of the neutrality check: a kebab-case name and a case-sensitive regular expression for engine-specific syntax.
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
