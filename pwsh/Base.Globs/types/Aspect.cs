using System;
using System.Collections.Generic;
using System.Text.RegularExpressions;

namespace Catzc.Base.Globs;

// A unit's files partition into ordered, first-match aspects; the last is the non-live catch-all, so nothing ships by accident.
public sealed class Aspect
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    private static readonly Regex KebabCase = new Regex("^[a-z][a-z0-9]*(-[a-z0-9]+)*$");

    public string Name { get; }
    public IReadOnlyList<string> Patterns { get; }   // relative to the unit root

    public Aspect(string name, string[] patterns)
    {
        if (string.IsNullOrWhiteSpace(name) || !KebabCase.IsMatch(name))
        {
            throw new ArgumentException(string.Format("aspect name '{0}' must be kebab-case", name));
        }
        if (patterns == null || patterns.Length == 0)
        {
            throw new ArgumentException(string.Format("aspect '{0}' needs at least one pattern", name));
        }
        Name = name;
        Patterns = (string[])patterns.Clone();
    }
}

// One aspect on a unit root: its name and the include and exclude rules that encode its first-match slice.
public sealed class CompiledAspect
{
    public string Name { get; }
    public string[] Include { get; }
    public string[] Exclude { get; }

    public CompiledAspect(string name, string[] include, string[] exclude)
    {
        Name = name;
        Include = include;
        Exclude = exclude;
    }
}
