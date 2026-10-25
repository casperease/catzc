using System;
using System.Globalization;

namespace Catzc.Base.QualityGates;

// One relation the link walk recognised: where it is written, how, the repository path it names, and the rule code a citation carries.
public sealed class LinkEdge
{
    public string File { get; }
    public int Line { get; }
    public int Column { get; }
    public LinkRelation Relation { get; }
    public string Target { get; }
    public string Code { get; }

    public LinkEdge(string file, int line, int column, LinkRelation relation, string target, string code)
    {
        if (string.IsNullOrEmpty(file))
        {
            throw new ArgumentException("An edge is written in a file.", nameof(file));
        }
        if (string.IsNullOrEmpty(target))
        {
            throw new ArgumentException("An edge names a target.", nameof(target));
        }
        File = file;
        Line = line;
        Column = column;
        Relation = relation;
        Target = target;
        Code = code ?? string.Empty;
    }

    public override string ToString() =>
        string.Format(CultureInfo.InvariantCulture, "{0}:{1}:{2} [{3}] {4}", File, Line, Column, Relation, Target);
}
