/*
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-quality-gates/types/LinkDirectionFinding.cs.md"
  warning: "Generated Header"
---
*/

using System.Globalization;

namespace Catzc.Base.QualityGates;

public sealed class LinkDirectionFinding
{
    public string File { get; }
    public int Line { get; }
    public LinkRelation Relation { get; }
    public string FromClass { get; }
    public string ToClass { get; }
    public int Row { get; }
    public string Because { get; }
    public string Message { get; }

    public LinkDirectionFinding(LinkEdge edge, string fromClass, string toClass, int row, string because, string message)
    {
        File = edge.File;
        Line = edge.Line;
        Relation = edge.Relation;
        FromClass = fromClass ?? string.Empty;
        ToClass = toClass ?? string.Empty;
        Row = row;
        Because = because ?? string.Empty;
        Message = message;
    }

    public override string ToString()
    {
        string what = Message ?? (Row > 0
            ? string.Format(CultureInfo.InvariantCulture, "denied by row {0}: {1}", Row, Because)
            : "no row allows it");
        return string.Format(CultureInfo.InvariantCulture, "{0}:{1} [{2}] {3} -> {4} {5}", File, Line, Relation, FromClass, ToClass, what);
    }
}
