/*
---
catzc:
  immutable:
    path: automation/Catzc.Base.CodeMeta/types/HeadForm.cs
    folder: types
    name: head-form
    filetype: cs
    kind: type
    language: csharp
    track: automation
    module: Catzc.Base.CodeMeta
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    page: docs/references/automation/catzc-base-codemeta/types/HeadForm.cs.md
    test: automation/Catzc.Base.CodeMeta/tests/types/HeadForm.Tests.ps1
    cites:
      - ADR-REPO-CODEMETA#1
---
*/

using System;
using System.Collections.Generic;

namespace Catzc.Base.CodeMeta;

[Catzc.Base.Objects.ConsoleDisplay("Line", "BlockOpen", "BlockClose", "Anchor", "PreambleLines")]
public sealed class HeadForm
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    HeadForm(string line, string blockOpen, string blockClose, HeadAnchor anchor, int preambleLines, string[] strip)
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
        Strip = strip == null ? Array.Empty<string>() : (string[])strip.Clone();
    }

    // The line-comment prefix (e.g. #). Null when the head is a block comment.
    public string Line { get; }

    // The block comment's delimiters (e.g. /* and */). Null when the head is a line comment.
    public string BlockOpen { get; }

    public string BlockClose { get; }

    public HeadAnchor Anchor { get; }

    // How many leading lines stay above the head with the anchor AfterPreamble; zero otherwise.
    public int PreambleLines { get; }

    // Openers of old heads the formatter removes with their whole comment run, each as the first line is written (e.g. "// catzc:").
    public IReadOnlyList<string> Strip { get; }

    public bool IsBlock => BlockOpen != null;

    // A head of line comments, each line opened by the prefix.
    public static HeadForm ForLine(string line, HeadAnchor anchor = HeadAnchor.Start, int preambleLines = 0, string[] strip = null)
    {
        if (string.IsNullOrEmpty(line) || line.Trim() != line || line.Contains(" "))
        {
            throw new ArgumentException("a line-comment prefix is non-empty and has no spaces", nameof(line));
        }
        return new HeadForm(line, null, null, anchor, preambleLines, strip);
    }

    // A head of one block comment, opened and closed by the delimiters.
    public static HeadForm ForBlock(string open, string close, HeadAnchor anchor = HeadAnchor.Start, int preambleLines = 0, string[] strip = null)
    {
        if (string.IsNullOrEmpty(open) || string.IsNullOrEmpty(close) || open.Contains(" ") || close.Contains(" "))
        {
            throw new ArgumentException("a block comment needs a non-empty opening and closing delimiter without spaces", nameof(open));
        }
        return new HeadForm(null, open, close, anchor, preambleLines, strip);
    }
}
