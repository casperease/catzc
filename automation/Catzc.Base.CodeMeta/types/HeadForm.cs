// catzc:
//   path: automation/Catzc.Base.CodeMeta/types/HeadForm.cs
//   module: Catzc.Base.CodeMeta

// The comment syntax of one file class's meta head, handed in as parameters because this module reads no config.
// [ADR-REPO-CODEMETA#1](/docs/adr/repository/code-file-meta.md#rule-adr-repo-codemeta1)
// [comment:1](/docs/references/automation/catzc-base-codemeta/types/HeadForm.cs.md#comment1)

using System;

namespace Catzc.Base.CodeMeta;

[Catzc.Base.Objects.ConsoleDisplay("Line", "BlockOpen", "BlockClose", "Anchor", "PreambleLines")]
public sealed class HeadForm
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    HeadForm(string line, string blockOpen, string blockClose, HeadAnchor anchor, int preambleLines)
    {
        if (anchor == HeadAnchor.AfterPreamble ? preambleLines <= 0 : preambleLines != 0)
        {
            throw new ArgumentException("preambleLines is required, and only allowed, with the anchor AfterPreamble");
        }
        Line = line;
        BlockOpen = blockOpen;
        BlockClose = blockClose;
        Anchor = anchor;
        PreambleLines = preambleLines;
    }

    // The line-comment prefix (e.g. #). Null when the head is a block comment.
    public string Line { get; }

    // The block comment's delimiters (e.g. <!-- and -->). Null when the head is a line comment.
    public string BlockOpen { get; }

    public string BlockClose { get; }

    public HeadAnchor Anchor { get; }

    // How many leading lines stay above the head with the anchor AfterPreamble; zero otherwise.
    public int PreambleLines { get; }

    public bool IsBlock => BlockOpen != null;

    // A head of line comments, each line opened by the prefix.
    public static HeadForm ForLine(string line, HeadAnchor anchor = HeadAnchor.Start, int preambleLines = 0)
    {
        if (string.IsNullOrEmpty(line) || line.Trim() != line || line.Contains(" "))
        {
            throw new ArgumentException("a line-comment prefix is non-empty and has no spaces", nameof(line));
        }
        return new HeadForm(line, null, null, anchor, preambleLines);
    }

    // A head of one block comment, opened and closed by the delimiters.
    public static HeadForm ForBlock(string open, string close, HeadAnchor anchor = HeadAnchor.Start, int preambleLines = 0)
    {
        if (string.IsNullOrEmpty(open) || string.IsNullOrEmpty(close) || open.Contains(" ") || close.Contains(" "))
        {
            throw new ArgumentException("a block comment needs a non-empty opening and closing delimiter without spaces", nameof(open));
        }
        return new HeadForm(null, open, close, anchor, preambleLines);
    }
}
