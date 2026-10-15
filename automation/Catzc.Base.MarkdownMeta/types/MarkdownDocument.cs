// catzc:
//   path: automation/Catzc.Base.MarkdownMeta/types/MarkdownDocument.cs
//   module: Catzc.Base.MarkdownMeta

using System;
using System.Collections.Generic;
using System.Security.Cryptography;
using System.Text;

namespace Catzc.Base.MarkdownMeta;

[Catzc.Base.Objects.ConsoleDisplay("HasFrontMatter", "HasMetaBlock", "NewLine")]
public sealed class MarkdownDocument
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    // The reserved front-matter key the tooling owns ([ADR-REPO-FILEMETA#1](/docs/adr/repository/file-meta.md#rule-adr-repo-filemeta1)).
    public const string MetaKey = "catzc";

    readonly List<string> frontMatter;
    readonly string openingFence;
    readonly string closingFence;

    // The fences are kept as written, with the line ending of the closing one, so an unchanged document reads back byte for byte.
    MarkdownDocument(string newLine, List<string> frontMatter, string openingFence, string closingFence, string body)
    {
        NewLine = newLine;
        this.frontMatter = frontMatter;
        this.openingFence = openingFence;
        this.closingFence = closingFence;
        Body = body;
    }

    public string NewLine { get; }

    public string Body { get; }

    public bool HasFrontMatter => frontMatter != null;

    public bool HasMetaBlock => FindMetaBlock(out _, out _);

    // The lines of the meta block, the `catzc:` line included; empty when the file has none.
    public IReadOnlyList<string> MetaBlock
    {
        get
        {
            if (!FindMetaBlock(out int start, out int end)) { return new string[0]; }
            return frontMatter.GetRange(start, end - start);
        }
    }

    // Splits a document into its YAML front matter lines and its body, byte for byte.
    public static MarkdownDocument Parse(string text)
    {
        if (text == null) { throw new ArgumentNullException(nameof(text)); }
        string newLine = text.Contains("\r\n") ? "\r\n" : "\n";
        List<(int Start, int Length, int Next)> lines = SplitLines(text);
        if (lines.Count == 0 || Content(text, lines[0]).TrimEnd() != "---")
        {
            return new MarkdownDocument(newLine, null, null, null, text);
        }
        for (int i = 1; i < lines.Count; i++)
        {
            string line = Content(text, lines[i]);
            if (line.TrimEnd() != "---" && line.TrimEnd() != "...") { continue; }
            var inside = new List<string>();
            for (int j = 1; j < i; j++) { inside.Add(Content(text, lines[j])); }
            string closing = text.Substring(lines[i].Start, lines[i].Next - lines[i].Start);
            return new MarkdownDocument(newLine, inside, Content(text, lines[0]), closing, text.Substring(lines[i].Next));
        }
        return new MarkdownDocument(newLine, null, null, null, text);
    }

    // The whole document again, with the meta block replaced by `block`; an empty block removes it. Nothing else changes.
    public string WithMetaBlock(IReadOnlyList<string> block)
    {
        bool remove = block == null || block.Count == 0;
        if (!HasFrontMatter)
        {
            if (remove) { return Body; }
            var created = new StringBuilder("---").Append(NewLine);
            foreach (string line in block) { created.Append(line).Append(NewLine); }
            created.Append("---").Append(NewLine);
            if (Body.Length > 0) { created.Append(NewLine); }
            return created.Append(Body).ToString();
        }
        var lines = new List<string>(frontMatter);
        if (FindMetaBlock(out int start, out int end))
        {
            lines.RemoveRange(start, end - start);
            if (!remove) { lines.InsertRange(start, block); }
        }
        else if (!remove)
        {
            lines.AddRange(block);
        }
        if (lines.Count == 0 && remove) { return Body; }
        var text = new StringBuilder(openingFence).Append(NewLine);
        foreach (string line in lines) { text.Append(line).Append(NewLine); }
        return text.Append(closingFence).Append(Body).ToString();
    }

    // The document as it was parsed.
    public string ToText() => WithMetaBlock(MetaBlock);

    // The first 12 hex characters of the SHA-256 of the body, its line endings read as LF and its leading blank lines dropped.
    // [comment:1](/docs/references/automation/catzc-base-markdownmeta/types/MarkdownDocument.cs.md#comment1)
    public string BodyHash()
    {
        byte[] bytes = Encoding.UTF8.GetBytes(Body.Replace("\r\n", "\n").TrimStart('\n'));
        using (SHA256 sha = SHA256.Create())
        {
            byte[] hash = sha.ComputeHash(bytes);
            var hex = new StringBuilder();
            for (int i = 0; i < 6; i++) { hex.Append(hash[i].ToString("x2")); }
            return hex.ToString();
        }
    }

    // The meta block runs from its top-level `catzc:` line to the next top-level line, without the blank lines before that one.
    bool FindMetaBlock(out int start, out int end)
    {
        start = end = -1;
        if (frontMatter == null) { return false; }
        for (int i = 0; i < frontMatter.Count; i++)
        {
            string line = frontMatter[i];
            if (!line.StartsWith(MetaKey + ":", StringComparison.Ordinal)) { continue; }
            string rest = line.Substring(MetaKey.Length + 1).Trim();
            if (rest.Length > 0 && rest[0] != '#') { continue; }
            start = i;
            end = i + 1;
            for (int j = i + 1; j < frontMatter.Count; j++)
            {
                string next = frontMatter[j];
                if (next.Trim().Length == 0) { continue; }
                if (next[0] != ' ' && next[0] != '\t') { break; }
                end = j + 1;
            }
            return true;
        }
        return false;
    }

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

    static string Content(string text, (int Start, int Length, int Next) line) => text.Substring(line.Start, line.Length);
}
