using System.Globalization;

namespace Catzc.Base.QualityGates;

// Row 0 means no row allows it; a missing endpoint is reported, never skipped.
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

    // A file a require row selects that has no edge the row requires: there is no edge to name, so no line either.
    public LinkDirectionFinding(string file, LinkRelation relation, string fromClass, string toSide, int row, string because)
    {
        File = file;
        Line = 0;
        Relation = relation;
        FromClass = fromClass ?? string.Empty;
        ToClass = toSide ?? string.Empty;
        Row = row;
        Because = because ?? string.Empty;
        Message = string.Format(CultureInfo.InvariantCulture, "is missing, required by row {0}: {1}", row, Because);
    }

    public override string ToString()
    {
        string what = Message ?? (Row > 0
            ? string.Format(CultureInfo.InvariantCulture, "denied by row {0}: {1}", Row, Because)
            : "no row allows it");
        return string.Format(CultureInfo.InvariantCulture, "{0}:{1} [{2}] {3} -> {4} {5}", File, Line, Relation, FromClass, ToClass, what);
    }
}
