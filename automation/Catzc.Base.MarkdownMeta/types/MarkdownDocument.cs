/*
---
catzc:
  immutable:
    repo_status: clean
    path: automation/Catzc.Base.MarkdownMeta/types/MarkdownDocument.cs
    folder: types
    name: markdown-document
    filetype: cs
    kind: type
    language: csharp
    track: automation
    tracktype: modules
    module: Catzc.Base.MarkdownMeta
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    page: docs/references/automation/catzc-base-markdownmeta/types/MarkdownDocument.cs.md
    test: automation/Catzc.Base.MarkdownMeta/tests/types/MarkdownDocument.Tests.ps1
    cites:
      - ADR-REPO-FILEMETA#1
---
*/

using System;
using System.Collections.Generic;
using System.Security.Cryptography;
using System.Text;

namespace Catzc.Base.MarkdownMeta;

[Catzc.Base.Objects.ConsoleDisplay("HasFrontMatter", "HasMetaBlock", "Key", "NewLine")]
public sealed class MarkdownDocument
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    // The reserved front-matter key the tooling owns ([ADR-REPO-FILEMETA#1](/docs/adr/repository/file-meta.md#rule-adr-repo-filemeta1)).
    public const string MetaKey = "catzc";

    readonly List<string> frontMatter;
    readonly string openingFence;
    readonly string closingFence;
    readonly string[] path;

    // The fences are kept as written, with the line ending of the closing one, so an unchanged document reads back byte for byte.
    MarkdownDocument(string newLine, List<string> frontMatter, string openingFence, string closingFence, string body, string[] path)
    {
        NewLine = newLine;
        this.frontMatter = frontMatter;
        this.openingFence = openingFence;
        this.closingFence = closingFence;
        Body = body;
        this.path = path;
    }

    public string NewLine { get; }

    public string Body { get; }

    // The key path of the block: the reserved key at the top level, or a dotted path that nests it under another tool's keys.
    public string Key => string.Join(".", path);

    public bool HasFrontMatter => frontMatter != null;

    // The front-matter lines that are not the block's, as written: what the other tools that read the file own.
    public IReadOnlyList<string> OtherFrontMatter
    {
        get
        {
            if (frontMatter == null) { return new string[0]; }
            Location at = Locate();
            var lines = new List<string>(frontMatter);
            if (at.Found) { lines.RemoveRange(at.Start, at.End - at.Start); }
            return lines;
        }
    }

    public bool HasMetaBlock => Locate().Found;

    // False when a key above the block holds a flow or scalar value, which nothing can nest under.
    public bool CanHoldMetaBlock => !Locate().Blocked;

    // The lines of the meta block, the `catzc:` line included and the block's own indent removed; empty when the file has none.
    public IReadOnlyList<string> MetaBlock
    {
        get
        {
            Location at = Locate();
            if (!at.Found) { return new string[0]; }
            var lines = new List<string>();
            for (int i = at.Start; i < at.End; i++) { lines.Add(Dedent(frontMatter[i], at.Indent)); }
            return lines;
        }
    }

    public static MarkdownDocument Parse(string text) => Parse(text, MetaKey);

    // Splits a document into its YAML front matter lines and its body, byte for byte, and remembers where the block lives.
    public static MarkdownDocument Parse(string text, string key)
    {
        if (text == null) { throw new ArgumentNullException(nameof(text)); }
        string[] path = SplitKey(key);
        string newLine = text.Contains("\r\n") ? "\r\n" : "\n";
        List<(int Start, int Length, int Next)> lines = SplitLines(text);
        if (lines.Count == 0 || Content(text, lines[0]).TrimEnd() != "---")
        {
            return new MarkdownDocument(newLine, null, null, null, text, path);
        }
        for (int i = 1; i < lines.Count; i++)
        {
            string line = Content(text, lines[i]);
            if (line.TrimEnd() != "---" && line.TrimEnd() != "...") { continue; }
            var inside = new List<string>();
            for (int j = 1; j < i; j++) { inside.Add(Content(text, lines[j])); }
            string closing = text.Substring(lines[i].Start, lines[i].Next - lines[i].Start);
            return new MarkdownDocument(newLine, inside, Content(text, lines[0]), closing, text.Substring(lines[i].Next), path);
        }
        return new MarkdownDocument(newLine, null, null, null, text, path);
    }

    // The whole document again, with the meta block replaced by `block`; an empty block removes it. Nothing else changes.
    public string WithMetaBlock(IReadOnlyList<string> block)
    {
        bool remove = block == null || block.Count == 0;
        if (!HasFrontMatter)
        {
            if (remove) { return Body; }
            var created = new StringBuilder("---").Append(NewLine);
            foreach (string line in Nested(block, 0, 0)) { created.Append(line).Append(NewLine); }
            created.Append("---").Append(NewLine);
            if (Body.Length > 0) { created.Append(NewLine); }
            return created.Append(Body).ToString();
        }
        var lines = new List<string>(frontMatter);
        Location at = Locate();
        if (at.Found)
        {
            lines.RemoveRange(at.Start, at.End - at.Start);
            if (!remove) { lines.InsertRange(at.Start, Indented(block, at.Indent)); }
        }
        else if (!remove)
        {
            if (at.Blocked)
            {
                throw new InvalidOperationException("The front-matter key '" + path[at.Depth - 1] + "' holds a flow or scalar value, so no meta block can nest under it at '" + Key + "'.");
            }
            lines.InsertRange(at.Insert, Nested(block, at.Depth, at.Indent));
        }
        // A front matter left empty goes whole, with the one blank line a created front matter puts before the body.
        if (lines.Count == 0 && remove) { return WithoutSeparator(Body); }
        var text = new StringBuilder(openingFence).Append(NewLine);
        foreach (string line in lines) { text.Append(line).Append(NewLine); }
        return text.Append(closingFence).Append(Body).ToString();
    }

    static string WithoutSeparator(string body)
    {
        if (body.StartsWith("\r\n", StringComparison.Ordinal)) { return body.Substring(2); }
        if (body.StartsWith("\n", StringComparison.Ordinal)) { return body.Substring(1); }
        return body;
    }

    // The document as it was parsed.
    public string ToText() => WithMetaBlock(MetaBlock);

    public string BodyHash() => HashOf(Body);

    // The one body hash: line endings and the blank line after a head never move it, so every carrier stamps the same value.
    public static string HashOf(string body)
    {
        byte[] bytes = Encoding.UTF8.GetBytes((body ?? string.Empty).Replace("\r\n", "\n").TrimStart('\n'));
        using (SHA256 sha = SHA256.Create())
        {
            byte[] hash = sha.ComputeHash(bytes);
            var hex = new StringBuilder();
            for (int i = 0; i < 6; i++) { hex.Append(hash[i].ToString("x2")); }
            return hex.ToString();
        }
    }

    // A key path is dotted plain keys and ends in the reserved key, because the block's own line is always `catzc:`.
    public static bool IsKeyPath(string key)
    {
        if (string.IsNullOrEmpty(key)) { return false; }
        string[] path = key.Split('.');
        foreach (string segment in path)
        {
            if (segment.Length == 0 || segment.IndexOfAny(new[] { ' ', '\t', ':', '#', '"', '\'' }) >= 0) { return false; }
        }
        return path[path.Length - 1] == MetaKey;
    }

    static string[] SplitKey(string key)
    {
        if (!IsKeyPath(key))
        {
            throw new ArgumentException("A meta key path is dotted plain keys ending in '" + MetaKey + "', and '" + key + "' is not.", nameof(key));
        }
        return key.Split('.');
    }

    // Where the block is, or where it would go: the parents found along the key path, and the block's lines when the last key is there.
    sealed class Location
    {
        public int Start = -1;
        public int End = -1;
        public int Depth;
        public int Indent;
        public int Insert;
        public bool Blocked;
        public bool Found => Start >= 0;
    }

    Location Locate()
    {
        var at = new Location();
        if (frontMatter == null) { return at; }
        int from = 0;
        int to = frontMatter.Count;
        at.Insert = to;
        for (int k = 0; k < path.Length; k++)
        {
            bool last = k == path.Length - 1;
            int line = FindKey(path[k], at.Indent, from, to, last, out bool holdsBlock);
            if (line < 0) { return at; }
            int subtreeEnd = SubtreeEnd(line, at.Indent, to);
            if (last)
            {
                at.Start = line;
                at.End = subtreeEnd;
                return at;
            }
            at.Depth = k + 1;
            if (!holdsBlock)
            {
                at.Blocked = true;
                return at;
            }
            from = line + 1;
            to = subtreeEnd;
            at.Insert = subtreeEnd;
            int child = FirstNonBlank(from, to);
            at.Indent = child < 0 ? at.Indent + 2 : IndentOf(frontMatter[child]);
        }
        return at;
    }

    // The line in the window that writes `key:` at this indent; the block's own key must open a block, a parent is found either way.
    int FindKey(string key, int indent, int from, int to, bool last, out bool holdsBlock)
    {
        holdsBlock = false;
        for (int i = from; i < to; i++)
        {
            string line = frontMatter[i];
            if (line.Trim().Length == 0 || IndentOf(line) != indent) { continue; }
            string body = line.Substring(indent);
            if (!body.StartsWith(key + ":", StringComparison.Ordinal)) { continue; }
            string rest = body.Substring(key.Length + 1).Trim();
            holdsBlock = rest.Length == 0 || rest[0] == '#';
            if (last && !holdsBlock) { continue; }
            return i;
        }
        return -1;
    }

    // One past the last non-blank line below `line` that is indented deeper than it.
    int SubtreeEnd(int line, int indent, int to)
    {
        int end = line + 1;
        for (int j = line + 1; j < to; j++)
        {
            string next = frontMatter[j];
            if (next.Trim().Length == 0) { continue; }
            if (IndentOf(next) <= indent) { break; }
            end = j + 1;
        }
        return end;
    }

    int FirstNonBlank(int from, int to)
    {
        for (int i = from; i < to; i++)
        {
            if (frontMatter[i].Trim().Length > 0) { return i; }
        }
        return -1;
    }

    // The missing parent keys from `depth` on, each two spaces deeper, then the block under the last of them.
    List<string> Nested(IReadOnlyList<string> block, int depth, int indent)
    {
        var lines = new List<string>();
        for (int k = depth; k < path.Length - 1; k++)
        {
            lines.Add(new string(' ', indent) + path[k] + ":");
            indent += 2;
        }
        lines.AddRange(Indented(block, indent));
        return lines;
    }

    static List<string> Indented(IReadOnlyList<string> block, int indent)
    {
        var lines = new List<string>();
        string prefix = new string(' ', indent);
        foreach (string line in block) { lines.Add(line.Trim().Length == 0 ? line : prefix + line); }
        return lines;
    }

    static string Dedent(string line, int indent)
    {
        if (line.Trim().Length == 0) { return line; }
        int n = 0;
        while (n < indent && n < line.Length && (line[n] == ' ' || line[n] == '\t')) { n++; }
        return line.Substring(n);
    }

    static int IndentOf(string line)
    {
        int n = 0;
        while (n < line.Length && (line[n] == ' ' || line[n] == '\t')) { n++; }
        return n;
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
