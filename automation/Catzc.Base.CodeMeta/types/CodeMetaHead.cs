// catzc:
//   path: automation/Catzc.Base.CodeMeta/types/CodeMetaHead.cs
//   module: Catzc.Base.CodeMeta

// Reads and writes a code file's meta head as pure text work, so every behaviour is proved on strings and no file is touched.
// [ADR-REPO-CODEMETA#1](/docs/adr/repository/code-file-meta.md#rule-adr-repo-codemeta1),
// [ADR-REPO-FILEMETA#6](/docs/adr/repository/file-meta.md#rule-adr-repo-filemeta6)
// [comment:1](/docs/references/automation/catzc-base-codemeta/types/CodeMetaHead.cs.md#comment1)

using System;
using System.Collections;
using System.Collections.Generic;
using System.Text;
using System.Text.RegularExpressions;

namespace Catzc.Base.CodeMeta;

[Catzc.Base.Objects.ConsoleDisplay("HasHead", "NewLine")]
public sealed class CodeMetaHead
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    // The line that opens a head, after the comment prefix.
    public const string Opener = "catzc:";

    static readonly Regex KeyPattern = new Regex("^[a-z][a-z0-9_]*$", RegexOptions.Compiled);
    static readonly Regex ValuePattern = new Regex(@"^[A-Za-z0-9_.][A-Za-z0-9_./#@+-]*$", RegexOptions.Compiled);
    static readonly Regex Fact = new Regex(@"^(?<key>[a-z][a-z0-9_]*): (?<value>\S.*)$", RegexOptions.Compiled);
    static readonly Regex Coding = new Regex(@"^#.*coding[:=]\s*[-\w.]+", RegexOptions.Compiled);

    readonly HeadForm form;

    CodeMetaHead(HeadForm form, string newLine, string before, string rest, bool hasHead, List<KeyValuePair<string, string>> facts)
    {
        this.form = form;
        NewLine = newLine;
        Before = before;
        Rest = rest;
        HasHead = hasHead;
        Facts = facts;
    }

    public string NewLine { get; }

    // The text above the head, as written: a byte order mark, a shebang, a prolog or preamble lines.
    public string Before { get; }

    // The text from the first line after the head and its blank lines, or from the anchor when there is no head.
    public string Rest { get; }

    public bool HasHead { get; }

    // The head's keys and values in the order written; empty when there is no head.
    public IReadOnlyList<KeyValuePair<string, string>> Facts { get; }

    // Splits a text into what stays above the head, the head's facts and the rest, byte for byte.
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

        var facts = new List<KeyValuePair<string, string>>();
        int index = anchor;
        bool hasHead = anchor < lines.Count && ReadHead(body, lines, form, ref index, facts);
        if (!hasHead)
        {
            return new CodeMetaHead(form, newLine, before, body.Substring(beforeEnd), false, new List<KeyValuePair<string, string>>());
        }
        while (index < lines.Count && Content(body, lines[index]).Trim().Length == 0) { index++; }
        string rest = index < lines.Count ? body.Substring(lines[index].Start) : "";
        return new CodeMetaHead(form, newLine, before, rest, true, facts);
    }

    // The whole text again with the head written from `facts` in the order given; no facts removes the head. Nothing else changes.
    public string WithFacts(IDictionary facts)
    {
        if (facts == null || facts.Count == 0) { return Before + Rest; }
        var text = new StringBuilder(Before);
        if (Before.Length > 0 && !Before.EndsWith("\n", StringComparison.Ordinal)) { text.Append(NewLine); }
        foreach (string line in Render(facts, form)) { text.Append(line).Append(NewLine); }
        if (Rest.Length > 0) { text.Append(NewLine).Append(Rest); }
        return text.ToString();
    }

    // The head's comment lines in their one canonical form, the opener first.
    public static IReadOnlyList<string> Render(IDictionary facts, HeadForm form)
    {
        if (form == null) { throw new ArgumentNullException(nameof(form)); }
        var lines = new List<string> { (form.IsBlock ? form.BlockOpen : form.Line) + " " + Opener };
        string indent = form.IsBlock ? "  " : form.Line + "   ";
        var seen = new HashSet<string>(StringComparer.Ordinal);
        foreach (DictionaryEntry fact in facts)
        {
            string key = Convert.ToString(fact.Key, System.Globalization.CultureInfo.InvariantCulture);
            string value = Convert.ToString(fact.Value, System.Globalization.CultureInfo.InvariantCulture);
            if (!KeyPattern.IsMatch(key ?? "")) { throw new ArgumentException("A meta head key is lowercase words joined by '_', got '" + key + "'."); }
            if (!seen.Add(key)) { throw new ArgumentException("The meta head key '" + key + "' is given twice."); }
            if (!ValuePattern.IsMatch(value ?? ""))
            {
                throw new ArgumentException("The meta head value of '" + key + "' must be a plain path or name, got '" + value + "'.");
            }
            lines.Add(indent + key + ": " + value);
        }
        if (form.IsBlock) { lines.Add(form.BlockClose); }
        return lines;
    }

    // Reads an opener and its fact lines from `index`; leaves `index` after the head. A head that never closes is no head.
    static bool ReadHead(string body, List<(int Start, int Length, int Next)> lines, HeadForm form, ref int index, List<KeyValuePair<string, string>> facts)
    {
        string opener = (form.IsBlock ? form.BlockOpen : form.Line) + " " + Opener;
        if (Content(body, lines[index]).TrimEnd() != opener) { return false; }
        int next = index + 1;
        bool closed = !form.IsBlock;
        string prefix = form.IsBlock ? "  " : form.Line + "   ";
        while (next < lines.Count)
        {
            string line = Content(body, lines[next]).TrimEnd();
            if (form.IsBlock && line == form.BlockClose) { closed = true; next++; break; }
            if (!line.StartsWith(prefix, StringComparison.Ordinal)) { break; }
            Match match = Fact.Match(line.Substring(prefix.Length));
            if (!match.Success) { break; }
            facts.Add(new KeyValuePair<string, string>(match.Groups["key"].Value, match.Groups["value"].Value.TrimEnd()));
            next++;
        }
        if (!closed)
        {
            facts.Clear();
            return false;
        }
        index = next;
        return true;
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
