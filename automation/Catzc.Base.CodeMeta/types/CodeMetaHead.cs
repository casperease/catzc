/*
---
catzc:
  derived:
    path: automation/Catzc.Base.CodeMeta/types/CodeMetaHead.cs
    kind: type
    module: Catzc.Base.CodeMeta
    adrs:
      - ADR-REPO-CODEMETA#1
      - ADR-REPO-FILEMETA#6
---
*/

// Reads and writes a code file's meta head as pure text work, so every behaviour is proved on strings and no file is touched.
// [ADR-REPO-CODEMETA#1](/docs/adr/repository/code-file-meta.md#rule-adr-repo-codemeta1),
// [ADR-REPO-FILEMETA#6](/docs/adr/repository/file-meta.md#rule-adr-repo-filemeta6)
// [comment:1](/docs/references/automation/catzc-base-codemeta/types/CodeMetaHead.cs.md#comment1)

using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using Catzc.Base.MarkdownMeta;

namespace Catzc.Base.CodeMeta;

[Catzc.Base.Objects.ConsoleDisplay("HasHead", "NewLine")]
public sealed class CodeMetaHead
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    const string Fence = "---";

    static readonly Regex Coding = new Regex(@"^#.*coding[:=]\s*[-\w.]+", RegexOptions.Compiled);

    readonly HeadForm form;
    readonly IReadOnlyList<string> metaBlock;

    CodeMetaHead(HeadForm form, string newLine, string before, string rest, bool hasHead, IReadOnlyList<string> metaBlock)
    {
        this.form = form;
        NewLine = newLine;
        Before = before;
        Rest = rest;
        HasHead = hasHead;
        this.metaBlock = metaBlock;
    }

    public string NewLine { get; }

    // The text above the head, as written: a byte order mark, a shebang, a prolog or preamble lines.
    public string Before { get; }

    // The text from the first line after the head and its blank lines, or from the anchor when there is no head.
    public string Rest { get; }

    public bool HasHead { get; }

    // The keys directly under `catzc`, as a Markdown meta block reads them.
    public IReadOnlyList<string> Sections => MarkdownMetaBlock.SectionKeys(metaBlock);

    // The keys under `derived`.
    public IReadOnlyList<string> DerivedKeys => MarkdownMetaBlock.DerivedKeys(metaBlock);

    // The authored lines under `config`, as written.
    public IReadOnlyList<string> ConfigLines => MarkdownMetaBlock.ConfigLines(metaBlock);

    // Splits a text into what stays above the head, the head and the rest, byte for byte. An opener the form strips is removed with its run.
    public static CodeMetaHead Parse(string text, HeadForm form)
    {
        if (text == null) { throw new ArgumentNullException(nameof(text)); }
        if (form == null) { throw new ArgumentNullException(nameof(form)); }
        string newLine = text.Contains("\r\n") ? "\r\n" : "\n";
        string bom = text.StartsWith("﻿", StringComparison.Ordinal) ? "﻿" : "";
        string body = text.Substring(bom.Length);
        List<(int Start, int Length, int Next)> lines = SplitLines(body);
        int anchor = AnchorLine(body, lines, form);
        int beforeEnd = anchor < lines.Count ? lines[anchor].Start : body.Length;
        string before = bom + body.Substring(0, beforeEnd);

        int index = anchor;
        IReadOnlyList<string> block = new string[0];
        bool hasHead = false;
        if (anchor < lines.Count)
        {
            int stripped = StrippedRunEnd(body, lines, anchor, form);
            if (stripped > anchor)
            {
                index = stripped;
            }
            else if (ReadHead(body, lines, form, anchor, out int end, out IReadOnlyList<string> found))
            {
                hasHead = true;
                block = found;
                index = end;
            }
        }
        if (!hasHead && index == anchor)
        {
            return new CodeMetaHead(form, newLine, before, body.Substring(beforeEnd), false, block);
        }
        while (index < lines.Count && Content(body, lines[index]).Trim().Length == 0) { index++; }
        string rest = index < lines.Count ? body.Substring(lines[index].Start) : "";
        return new CodeMetaHead(form, newLine, before, rest, hasHead, block);
    }

    // The whole text again with the head written from `derived` in the order given and the authored config kept; nothing to write removes the head.
    public string WithFacts(IDictionary derived)
    {
        IReadOnlyList<string> config = HasHead ? ConfigLines : new string[0];
        IReadOnlyList<string> block = MarkdownMetaBlock.Render(derived, config);
        if (block.Count == 0) { return Before + Rest; }
        var text = new StringBuilder(Before);
        if (Before.Length > 0 && !Before.EndsWith("\n", StringComparison.Ordinal)) { text.Append(NewLine); }
        foreach (string line in Wrap(block, form)) { text.Append(line).Append(NewLine); }
        if (Rest.Length > 0) { text.Append(NewLine).Append(Rest); }
        return text.ToString();
    }

    // The head's comment lines in their one canonical form: the front matter fences around the meta block, inside the comment.
    public static IReadOnlyList<string> Wrap(IReadOnlyList<string> block, HeadForm form)
    {
        if (block == null) { throw new ArgumentNullException(nameof(block)); }
        if (form == null) { throw new ArgumentNullException(nameof(form)); }
        var inner = new List<string> { Fence };
        inner.AddRange(block);
        inner.Add(Fence);
        if (form.IsBlock)
        {
            var lines = new List<string> { form.BlockOpen };
            lines.AddRange(inner);
            lines.Add(form.BlockClose);
            return lines;
        }
        return inner.Select(line => line.Length == 0 ? form.Line : form.Line + " " + line).ToList();
    }

    // Reads the head at `from`: its comment lines without the comment syntax must be one front matter document holding a `catzc` block.
    static bool ReadHead(string body, List<(int Start, int Length, int Next)> lines, HeadForm form, int from, out int end, out IReadOnlyList<string> block)
    {
        end = from;
        block = new string[0];
        var inner = new List<string>();
        if (form.IsBlock)
        {
            if (Content(body, lines[from]).TrimEnd() != form.BlockOpen) { return false; }
            int close = -1;
            for (int i = from + 1; i < lines.Count; i++)
            {
                if (Content(body, lines[i]).TrimEnd() == form.BlockClose) { close = i; break; }
                inner.Add(Content(body, lines[i]).TrimEnd());
            }
            if (close < 0) { return false; }
            end = close + 1;
        }
        else
        {
            int i = from;
            for (; i < lines.Count; i++)
            {
                string line = Content(body, lines[i]).TrimEnd();
                if (line == form.Line) { inner.Add(string.Empty); continue; }
                if (!line.StartsWith(form.Line + " ", StringComparison.Ordinal)) { break; }
                inner.Add(line.Substring(form.Line.Length + 1));
                if (inner.Count > 1 && inner[inner.Count - 1] == Fence) { i++; break; }
            }
            end = i;
        }
        if (inner.Count < 2 || inner[0] != Fence || inner[inner.Count - 1] != Fence) { return false; }
        MarkdownDocument document = MarkdownDocument.Parse(string.Join("\n", inner) + "\n");
        if (!document.HasMetaBlock || document.Body.Trim().Length > 0) { return false; }
        block = document.MetaBlock;
        return true;
    }

    // The line after a run that opens with one of the form's strip openers, or `from` when the line opens none.
    static int StrippedRunEnd(string body, List<(int Start, int Length, int Next)> lines, int from, HeadForm form)
    {
        string first = Content(body, lines[from]).TrimEnd();
        string opener = form.Strip.FirstOrDefault(candidate => first == candidate || first.StartsWith(candidate, StringComparison.Ordinal));
        if (opener == null) { return from; }
        string marker = opener.Split(' ')[0];
        int index = from;
        while (index < lines.Count && Content(body, lines[index]).TrimEnd().StartsWith(marker, StringComparison.Ordinal)) { index++; }
        return index;
    }

    // The first line the head may stand on: after a shebang and encoding line, an XML prolog, or a fixed number of lines.
    static int AnchorLine(string body, List<(int Start, int Length, int Next)> lines, HeadForm form)
    {
        int index = 0;
        switch (form.Anchor)
        {
            case HeadAnchor.AfterShebang:
                if (lines.Count > 0 && Content(body, lines[0]).StartsWith("#!", StringComparison.Ordinal)) { index = 1; }
                if (index < lines.Count && Coding.IsMatch(Content(body, lines[index]))) { index++; }
                break;
            case HeadAnchor.AfterProlog:
                while (index < lines.Count)
                {
                    string line = Content(body, lines[index]).TrimStart();
                    if (!line.StartsWith("<?xml", StringComparison.OrdinalIgnoreCase) && !line.StartsWith("<!DOCTYPE", StringComparison.OrdinalIgnoreCase)) { break; }
                    index++;
                }
                break;
            case HeadAnchor.AfterPreamble:
                index = Math.Min(form.PreambleLines, lines.Count);
                break;
        }
        return index;
    }

    static string Content(string text, (int Start, int Length, int Next) line) => text.Substring(line.Start, line.Length);

    static List<(int Start, int Length, int Next)> SplitLines(string text)
    {
        var lines = new List<(int Start, int Length, int Next)>();
        int position = 0;
        while (position < text.Length)
        {
            int newline = text.IndexOf('\n', position);
            if (newline < 0)
            {
                lines.Add((position, text.Length - position, text.Length));
                break;
            }
            int length = newline - position;
            if (length > 0 && text[newline - 1] == '\r') { length--; }
            lines.Add((position, length, newline + 1));
            position = newline + 1;
        }
        return lines;
    }
}
