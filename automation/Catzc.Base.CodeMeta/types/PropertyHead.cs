/*
---
catzc:
  derived:
    path: automation/Catzc.Base.CodeMeta/types/PropertyHead.cs
    kind: csharp-type
    language: csharp
    track: automation
    module: Catzc.Base.CodeMeta
    relatives:
      page: docs/references/automation/catzc-base-codemeta/types/PropertyHead.cs.md
      test: automation/Catzc.Base.CodeMeta/tests/types/PropertyHead.Tests.ps1
    adrs:
      - ADR-REPO-FILEMETA#8
---
*/

// Reads and writes a JSON file's meta block, kept as the text of one ignored top-level property, as pure text work on strings.

using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Catzc.Base.MarkdownMeta;

namespace Catzc.Base.CodeMeta;

[Catzc.Base.Objects.ConsoleDisplay("Property", "IsObject", "HasHead", "Foreign")]
public sealed class PropertyHead
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    readonly string text;
    readonly string newLine;
    readonly List<Member> members;
    readonly int open;
    readonly int close;
    readonly int headIndex;
    readonly IReadOnlyList<string> metaBlock;

    // One top-level member: where it starts (its key), where its value ends and the value's text.
    sealed class Member
    {
        public string Key;
        public int Start;
        public int ValueStart;
        public int End;
    }

    PropertyHead(string property, string text, string newLine, List<Member> members, int open, int close, int headIndex, IReadOnlyList<string> metaBlock, bool foreign)
    {
        Property = property;
        this.text = text;
        this.newLine = newLine;
        this.members = members;
        this.open = open;
        this.close = close;
        this.headIndex = headIndex;
        this.metaBlock = metaBlock;
        Foreign = foreign;
    }

    // The head of a text that is no JSON object: nothing is found and nothing is ever written.
    static PropertyHead NotAnObject(string property, string text, string newLine) =>
        new PropertyHead(property, text, newLine, new List<Member>(), -1, -1, -1, new string[0], false);

    // The name of the ignored property that holds the block (e.g. // or $comment).
    public string Property { get; }

    // False when the text is not a JSON object, which has no top level to put a property in; such a text is never changed.
    public bool IsObject => open >= 0;

    // True when the property holds a catzc meta block.
    public bool HasHead => metaBlock.Count > 0;

    // True when the property exists and holds something else than a meta block or an old head to strip; the text is then never changed.
    public bool Foreign { get; }

    // The keys directly under `catzc`, as a Markdown meta block reads them.
    public IReadOnlyList<string> Sections => MarkdownMetaBlock.SectionKeys(metaBlock);

    // The keys under `derived`.
    public IReadOnlyList<string> DerivedKeys => MarkdownMetaBlock.DerivedKeys(metaBlock);

    // The authored lines under `config`, as written.
    public IReadOnlyList<string> ConfigLines => MarkdownMetaBlock.ConfigLines(metaBlock);

    // Finds the property among the top-level members. A string value that starts with one of the strip openers is an old head.
    public static PropertyHead Parse(string text, string property, IEnumerable<string> strip = null)
    {
        if (text == null) { throw new ArgumentNullException(nameof(text)); }
        if (string.IsNullOrEmpty(property)) { throw new ArgumentException("a property name is required", nameof(property)); }
        string newLine = text.Contains("\r\n") ? "\r\n" : "\n";
        var members = new List<Member>();
        int open = text.StartsWith("﻿", StringComparison.Ordinal) ? 1 : 0;
        open = SkipSpace(text, open);
        if (open >= text.Length || text[open] != '{') { return NotAnObject(property, text, newLine); }
        int position = open + 1;
        int close;
        while (true)
        {
            position = SkipSpace(text, position);
            if (position >= text.Length) { return NotAnObject(property, text, newLine); }
            if (text[position] == '}') { close = position; break; }
            if (text[position] != '"') { return NotAnObject(property, text, newLine); }
            int keyEnd = SkipString(text, position);
            if (keyEnd < 0) { return NotAnObject(property, text, newLine); }
            string key = Unescape(text.Substring(position + 1, keyEnd - position - 2));
            int colon = SkipSpace(text, keyEnd);
            if (colon >= text.Length || text[colon] != ':') { return NotAnObject(property, text, newLine); }
            int valueStart = SkipSpace(text, colon + 1);
            int valueEnd = SkipValue(text, valueStart);
            if (valueEnd < 0) { return NotAnObject(property, text, newLine); }
            members.Add(new Member { Key = key, Start = position, ValueStart = valueStart, End = valueEnd });
            position = SkipSpace(text, valueEnd);
            if (position < text.Length && text[position] == ',') { position++; continue; }
            if (position < text.Length && text[position] == '}') { close = position; break; }
            return NotAnObject(property, text, newLine);
        }

        int headIndex = members.FindIndex(m => m.Key == property);
        IReadOnlyList<string> block = new string[0];
        bool foreign = false;
        if (headIndex >= 0)
        {
            Member member = members[headIndex];
            string value = text[member.ValueStart] == '"' ? Unescape(text.Substring(member.ValueStart + 1, member.End - member.ValueStart - 2)) : null;
            string[] lines = value == null ? new string[0] : value.Replace("\r\n", "\n").Split('\n');
            if (lines.Length > 0 && lines[0] == MarkdownDocument.MetaKey + ":")
            {
                block = lines;
            }
            else if (value == null || strip == null || !strip.Any(opener => value.StartsWith(opener, StringComparison.Ordinal)))
            {
                foreign = true;
            }
        }
        return new PropertyHead(property, text, newLine, members, open, close, headIndex, block, foreign);
    }

    public string WithFacts(IDictionary derived)
    {
        if (!IsObject || Foreign) { return text; }
        IReadOnlyList<string> config = HasHead ? ConfigLines : new string[0];
        IReadOnlyList<string> block = MarkdownMetaBlock.Render(derived, config);
        if (block.Count == 0) { return headIndex >= 0 ? Without(headIndex) : text; }
        string indent = Indent();
        string member = Quote(Property) + ": " + Quote(string.Join("\n", block));
        if (headIndex == 0)
        {
            Member first = members[0];
            return text.Substring(0, first.Start) + member + text.Substring(first.End);
        }
        string rest = headIndex > 0 ? Without(headIndex) : text;
        PropertyHead without = headIndex > 0 ? Parse(rest, Property) : this;
        return without.InsertFirst(member, indent);
    }

    string InsertFirst(string member, string indent)
    {
        if (members.Count == 0)
        {
            return text.Substring(0, open + 1) + newLine + indent + member + newLine + text.Substring(close);
        }
        return text.Substring(0, open + 1) + newLine + indent + member + "," + text.Substring(open + 1);
    }

    // The text without one member and its comma; the member before the closing brace takes the preceding comma with it.
    string Without(int index)
    {
        Member member = members[index];
        if (members.Count == 1) { return text.Substring(0, open + 1) + text.Substring(close); }
        if (index < members.Count - 1)
        {
            return text.Substring(0, member.Start) + text.Substring(members[index + 1].Start);
        }
        return text.Substring(0, members[index - 1].End) + text.Substring(member.End);
    }

    // The whitespace before the first member on its line, or two spaces when the object has no member yet.
    string Indent()
    {
        if (members.Count == 0) { return "  "; }
        int start = members[0].Start;
        int lineStart = text.LastIndexOf('\n', Math.Max(0, start - 1)) + 1;
        string before = text.Substring(lineStart, start - lineStart);
        return before.Trim().Length == 0 && lineStart > open ? before : "  ";
    }

    static int SkipSpace(string text, int position)
    {
        while (position < text.Length)
        {
            char c = text[position];
            if (c == ' ' || c == '\t' || c == '\r' || c == '\n') { position++; continue; }
            if (c == '/' && position + 1 < text.Length && text[position + 1] == '/')
            {
                while (position < text.Length && text[position] != '\n') { position++; }
                continue;
            }
            if (c == '/' && position + 1 < text.Length && text[position + 1] == '*')
            {
                int end = text.IndexOf("*/", position + 2, StringComparison.Ordinal);
                position = end < 0 ? text.Length : end + 2;
                continue;
            }
            break;
        }
        return position;
    }

    // The index after the closing quote of the string that starts at `position`, or -1 when it never closes.
    static int SkipString(string text, int position)
    {
        for (int i = position + 1; i < text.Length; i++)
        {
            if (text[i] == '\\') { i++; continue; }
            if (text[i] == '"') { return i + 1; }
        }
        return -1;
    }

    // The index after the value that starts at `position`, or -1 when the text ends first.
    static int SkipValue(string text, int position)
    {
        if (position >= text.Length) { return -1; }
        char first = text[position];
        if (first == '"') { return SkipString(text, position); }
        if (first == '{' || first == '[')
        {
            int depth = 0;
            for (int i = position; i < text.Length; i++)
            {
                char c = text[i];
                if (c == '"') { i = SkipString(text, i); if (i < 0) { return -1; } i--; continue; }
                if (c == '/' && i + 1 < text.Length && (text[i + 1] == '/' || text[i + 1] == '*')) { i = SkipSpace(text, i) - 1; continue; }
                if (c == '{' || c == '[') { depth++; }
                else if (c == '}' || c == ']') { depth--; if (depth == 0) { return i + 1; } }
            }
            return -1;
        }
        int end = position;
        while (end < text.Length && ",}] \t\r\n".IndexOf(text[end]) < 0) { end++; }
        return end > position ? end : -1;
    }

    static string Quote(string value)
    {
        var quoted = new StringBuilder("\"");
        foreach (char c in value)
        {
            switch (c)
            {
                case '"': quoted.Append("\\\""); break;
                case '\\': quoted.Append("\\\\"); break;
                case '\n': quoted.Append("\\n"); break;
                case '\r': quoted.Append("\\r"); break;
                case '\t': quoted.Append("\\t"); break;
                default:
                    if (c < 0x20) { quoted.Append("\\u").Append(((int)c).ToString("x4")); }
                    else { quoted.Append(c); }
                    break;
            }
        }
        return quoted.Append('"').ToString();
    }

    static string Unescape(string value)
    {
        if (value.IndexOf('\\') < 0) { return value; }
        var text = new StringBuilder();
        for (int i = 0; i < value.Length; i++)
        {
            char c = value[i];
            if (c != '\\' || i + 1 >= value.Length) { text.Append(c); continue; }
            char next = value[++i];
            switch (next)
            {
                case 'n': text.Append('\n'); break;
                case 'r': text.Append('\r'); break;
                case 't': text.Append('\t'); break;
                case 'b': text.Append('\b'); break;
                case 'f': text.Append('\f'); break;
                case 'u':
                    if (i + 4 < value.Length && int.TryParse(value.Substring(i + 1, 4), System.Globalization.NumberStyles.HexNumber, System.Globalization.CultureInfo.InvariantCulture, out int code))
                    {
                        text.Append((char)code);
                        i += 4;
                    }
                    else { text.Append("\\u"); }
                    break;
                default: text.Append(next); break;
            }
        }
        return text.ToString();
    }
}
