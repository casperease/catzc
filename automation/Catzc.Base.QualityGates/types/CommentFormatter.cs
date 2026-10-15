/*
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/types/CommentFormatter.cs
    kind: type
    module: Catzc.Base.QualityGates
    adrs:
      - ADR-AUTO-IDEM#1
      - ADR-PRIN-CONFIG#1
      - ADR-REPO-COMMENTS#1
      - ADR-REPO-COMMENTS#5
---
*/

// A second run changes nothing: obvious insights and prose on the link line go to a person, never rewritten here.
// [comment:1](/docs/references/automation/catzc-base-qualitygates/types/CommentFormatter.cs.md#comment1)

using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;

namespace Catzc.Base.QualityGates;

public static class CommentFormatter
{
    const string DocsLinkStart = "[comment:";
    const int MinimumInsightLength = 16;

    // text: the file; pageText: its comment page as it is, or null; lineLimit: the longest line the file allows.
    public static CommentFormatResult Format(string text, string extension, string language, string repoRelativePath, string pageText,
        CommentsConfig config, int lineLimit)
    {
        if (string.IsNullOrEmpty(repoRelativePath)) { throw new ArgumentException("comment formatter: the file path is required"); }
        if (config == null) { throw new ArgumentNullException(nameof(config)); }
        var findings = new List<CommentFinding>();
        if (string.IsNullOrEmpty(text)) { return new CommentFormatResult(repoRelativePath, null, findings); }

        List<SourceLine> lines = Split(text);
        bool changed = false;
        // Last residue first: an inserted insight line moves every line below it, never one above.
        foreach (CommentResidue residue in CommentEngine.FindResidues(text, extension).OrderByDescending(r => r.StartLine))
        {
            changed |= FormatResidue(lines, residue, repoRelativePath, pageText, config, lineLimit, findings);
        }
        // The insight fixes above may have moved lines, so the residues are found again before their citations go.
        List<SourceLine> settled = changed ? Split(Join(lines)) : lines;
        foreach (CommentResidue residue in CommentEngine.FindResidues(Join(settled), extension).OrderByDescending(r => r.StartLine))
        {
            changed |= DropCitations(settled, residue, repoRelativePath, findings);
        }
        lines = settled;
        foreach (CommentBlock block in CommentEngine.FindBlocks(text, extension, language, config))
        {
            findings.Add(new CommentFinding(repoRelativePath, block.StartLine + 1, CommentFindingKind.LongComment,
                string.Format(CultureInfo.InvariantCulture, "a comment of {0} prose lines still lives in the file — run Export-Comments", block.ProseLineCount)));
        }
        findings.Sort((a, b) => a.Line != b.Line ? a.Line.CompareTo(b.Line) : a.Kind.CompareTo(b.Kind));
        return new CommentFormatResult(repoRelativePath, changed ? Join(lines) : null, findings);
    }

    static bool FormatResidue(List<SourceLine> lines, CommentResidue residue, string file, string pageText, CommentsConfig config, int lineLimit,
        List<CommentFinding> findings)
    {
        string prefix = residue.Indent + (residue.Marker.Length > 0 ? residue.Marker + " " : string.Empty);
        int maxInsight = Math.Max(MinimumInsightLength, lineLimit - prefix.Length);
        int linkLine = residue.EndLine;
        string linkBody = Body(lines[linkLine].Text, residue.Indent, residue.Marker);
        bool linkLineIsMechanical = CommentEngine.IsMechanical(linkBody) && linkBody.IndexOf(DocsLinkStart, StringComparison.Ordinal) >= 0;
        if (!linkLineIsMechanical)
        {
            findings.Add(new CommentFinding(file, linkLine + 1, CommentFindingKind.ProseOnLinkLine,
                "the docs-link line carries more than citations and links — move the words to the insight line above it"));
        }

        if (residue.Insight.Length == 0)
        {
            IReadOnlyList<string> section = CommentEngine.SectionLines(pageText, residue.Number);
            if (section.Count == 0)
            {
                findings.Add(new CommentFinding(file, linkLine + 1, CommentFindingKind.MissingSection,
                    string.Format(CultureInfo.InvariantCulture, "no insight line, and {0} holds no section comment:{1} to cut one from", residue.Page, residue.Number)));
                return false;
            }
            string provisional = CommentEngine.Insight(string.Join(" ", section.Where(line => line.Trim().Length > 0)), maxInsight);
            if (provisional.Length == 0)
            {
                findings.Add(new CommentFinding(file, linkLine + 1, CommentFindingKind.MissingSection,
                    string.Format(CultureInfo.InvariantCulture, "no insight line, and section comment:{0} has no prose to cut one from", residue.Number)));
                return false;
            }
            findings.Add(new CommentFinding(file, linkLine + 1, CommentFindingKind.Empty,
                "no insight line above the docs link — the comment's first sentence is put there, provisionally"));
            lines.Insert(residue.StartLine, new SourceLine(prefix + provisional, TerminatorFor(lines, residue.StartLine)));
            return true;
        }

        int insightLine = residue.StartLine;
        string insight = residue.Insight;
        bool fixedInsight = false;
        bool carriesLink = CommentEngine.Citations(insight).Count > 0 || insight.IndexOf("](", StringComparison.Ordinal) >= 0;
        if (carriesLink)
        {
            if (linkLineIsMechanical)
            {
                findings.Add(new CommentFinding(file, insightLine + 1, CommentFindingKind.LinkInInsight,
                    "the insight line carries a link or citation — both go, the file's head lists its citations"));
                fixedInsight = true;
            }
            else
            {
                findings.Add(new CommentFinding(file, insightLine + 1, CommentFindingKind.ProseOnLinkLine,
                    "the insight line carries a link or citation, and the docs-link line is not mechanical — fix that line first"));
            }
        }
        if (prefix.Length + insight.Length > lineLimit)
        {
            findings.Add(new CommentFinding(file, insightLine + 1, CommentFindingKind.Overlong,
                string.Format(CultureInfo.InvariantCulture, "the insight line is {0} characters, over the limit of {1} — cut at a word", prefix.Length + insight.Length, lineLimit)));
            fixedInsight = true;
        }
        if (config.IsObvious(insight))
        {
            findings.Add(new CommentFinding(file, insightLine + 1, CommentFindingKind.Obvious,
                "the insight line states the obvious — say what the code does not (the invariant, the order, the edge it guards)"));
        }
        if (!fixedInsight) { return false; }

        string replacement = CommentEngine.Insight(insight, maxInsight);
        if (replacement.Length == 0) { return false; }
        lines[insightLine] = new SourceLine(prefix + replacement, lines[insightLine].Terminator);
        return true;
    }

    // A residue is the insight line and the docs link; the citation lines and the citations before the link go, because the head lists them.
    static bool DropCitations(List<SourceLine> lines, CommentResidue residue, string file, List<CommentFinding> findings)
    {
        string prefix = residue.Indent + (residue.Marker.Length > 0 ? residue.Marker + " " : string.Empty);
        int linkLine = residue.EndLine;
        string linkBody = Body(lines[linkLine].Text, residue.Indent, residue.Marker);
        int linkAt = linkBody.IndexOf(DocsLinkStart, StringComparison.Ordinal);
        if (linkAt < 0 || !CommentEngine.IsMechanical(linkBody)) { return false; }
        int first = residue.StartLine + (residue.Insight.Length > 0 ? 1 : 0);
        if (first >= linkLine && linkAt == 0) { return false; }
        findings.Add(new CommentFinding(file, first + 1, CommentFindingKind.CitationInResidue,
            "citations stand in the residue — they go, the file's head lists them"));
        lines.RemoveRange(first, linkLine - first);
        lines[first] = new SourceLine(prefix + linkBody.Substring(linkAt).Trim(), lines[first].Terminator);
        return true;
    }

    static string Body(string line, string indent, string marker)
    {
        string body = line.StartsWith(indent + marker, StringComparison.Ordinal) ? line.Substring(indent.Length + marker.Length) : line.TrimStart();
        return body.StartsWith(" ", StringComparison.Ordinal) ? body.Substring(1) : body;
    }

    // ---- lines with their own terminators, so a rewrite touches only the lines it changes ----------------------

    sealed class SourceLine
    {
        public string Text { get; }
        public string Terminator { get; }

        public SourceLine(string text, string terminator)
        {
            Text = text;
            Terminator = terminator;
        }
    }

    static List<SourceLine> Split(string text)
    {
        var lines = new List<SourceLine>();
        int position = 0;
        while (position < text.Length)
        {
            int newline = text.IndexOf('\n', position);
            if (newline < 0)
            {
                lines.Add(new SourceLine(text.Substring(position), string.Empty));
                break;
            }
            bool carriage = newline > position && text[newline - 1] == '\r';
            lines.Add(new SourceLine(text.Substring(position, newline - position - (carriage ? 1 : 0)), carriage ? "\r\n" : "\n"));
            position = newline + 1;
        }
        return lines;
    }

    // The terminator an inserted line takes: the one of the line it goes above, or the file's when that line has none.
    static string TerminatorFor(List<SourceLine> lines, int index)
    {
        if (lines[index].Terminator.Length > 0) { return lines[index].Terminator; }
        return lines.Any(line => line.Terminator == "\r\n") ? "\r\n" : "\n";
    }

    static string Join(List<SourceLine> lines) => string.Concat(lines.Select(line => line.Text + line.Terminator));
}
