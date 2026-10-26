// The line and page models the comment engine reads and writes: a text split into lines with their offsets, and a comment page split into its numbered sections.

using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using static Catzc.Base.QualityGates.CommentEngine;

namespace Catzc.Base.QualityGates;

public static class CommentPageText
{
    static readonly Regex SectionHeading = new Regex(@"^## comment:(?<number>\d+)[ \t]*$", RegexOptions.Compiled | RegexOptions.Multiline);
    static readonly Regex PageIgnoreLine = new Regex(@"^<!-- cspell:ignore (?<words>[^\r\n]*?) -->[ \t]*$", RegexOptions.Compiled | RegexOptions.Multiline);
    // The Markdown line limit a page's generated lines stay within (.editorconfig [*.md] max_line_length).
    const int PageLineLimit = 140;

    internal sealed class Lines
    {
        readonly List<string> lines = new List<string>();
        readonly List<int> starts = new List<int>();
        readonly string eol;
        readonly bool trailingNewline;

        Lines(string text)
        {
            eol = text.Contains("\r\n") ? "\r\n" : "\n";
            int position = 0;
            while (position <= text.Length)
            {
                int newline = text.IndexOf('\n', position);
                starts.Add(position);
                if (newline < 0)
                {
                    lines.Add(text.Substring(position));
                    break;
                }
                lines.Add(text.Substring(position, newline - position).TrimEnd('\r'));
                position = newline + 1;
            }
            trailingNewline = text.EndsWith("\n", StringComparison.Ordinal);
            if (trailingNewline)
            {
                lines.RemoveAt(lines.Count - 1);
                starts.RemoveAt(starts.Count - 1);
            }
        }

        public static Lines Of(string text) => new Lines(text);

        public int Count => lines.Count;
        public string this[int index] => lines[index];
        public int StartOf(int line) => starts[line];

        public int LineOf(int offset)
        {
            int index = starts.BinarySearch(offset);
            return index >= 0 ? index : ~index - 1;
        }

        // The index of the first code line at or after the given one (not blank, not a comment), or -1.
        public static int NextCodeIndex(IReadOnlyList<string> all, int from)
        {
            for (int i = from; i < all.Count; i++)
            {
                string trimmed = all[i].Trim();
                if (trimmed.Length == 0) { continue; }
                if (trimmed.StartsWith("#", StringComparison.Ordinal) || trimmed.StartsWith("//", StringComparison.Ordinal)
                    || trimmed.StartsWith("<#", StringComparison.Ordinal) || trimmed.StartsWith("/*", StringComparison.Ordinal)
                    || trimmed.StartsWith("*/", StringComparison.Ordinal) || trimmed.StartsWith("<!--", StringComparison.Ordinal))
                {
                    continue;
                }
                return i;
            }
            return -1;
        }

        public string Join(IEnumerable<string> output)
        {
            string joined = string.Join(eol, output);
            return joined.Length == 0 ? string.Empty : joined + (trailingNewline ? eol : string.Empty);
        }
    }

    internal sealed class PageSection
    {
        public string Raw { get; set; }
        public IReadOnlyList<string> Lines { get; set; }
        // The line between the heading and the fence that says what the section annotated.
        public string Context { get; set; }
    }

    internal sealed class Page
    {
        public string Prefix { get; private set; }
        public SortedDictionary<int, PageSection> Sections { get; } = new SortedDictionary<int, PageSection>();
        public int HighestNumber => Sections.Count == 0 ? 0 : Sections.Keys.Max();

        public static Page Parse(string pageText)
        {
            var page = new Page();
            string text = (pageText ?? string.Empty).Replace("\r\n", "\n");
            MatchCollection headings = SectionHeading.Matches(text);
            page.Prefix = headings.Count == 0 ? text : text.Substring(0, headings[0].Index);
            for (int h = 0; h < headings.Count; h++)
            {
                int start = headings[h].Index;
                int end = h + 1 < headings.Count ? headings[h + 1].Index : text.Length;
                string raw = text.Substring(start, end - start);
                int number = int.Parse(headings[h].Groups["number"].Value, CultureInfo.InvariantCulture);
                page.Sections[number] = new PageSection { Raw = raw, Lines = FencedLines(raw), Context = ContextLine(raw) };
            }
            return page;
        }

        static string ContextLine(string section)
        {
            foreach (string line in section.Split('\n').Skip(1))
            {
                string trimmed = line.Trim();
                if (trimmed == FenceOpen) { return null; }
                if (trimmed.Length > 0) { return trimmed; }
            }
            return null;
        }

        static IReadOnlyList<string> FencedLines(string section)
        {
            var lines = section.Split('\n');
            var body = new List<string>();
            bool inside = false;
            foreach (string line in lines)
            {
                if (!inside && line.TrimEnd() == FenceOpen) { inside = true; continue; }
                if (inside && line.TrimEnd() == FenceClose) { break; }
                if (inside) { body.Add(line.TrimEnd()); }
            }
            return body;
        }

        // The page text with the new sections appended: an existing page keeps its text as written.
        public string With(IEnumerable<string> newSections, string repoRelativePath, IReadOnlyList<string> ignoredWords, int width)
        {
            var builder = new StringBuilder();
            bool fresh = Sections.Count == 0 && Prefix.Trim().Length == 0;
            string prefix = fresh ? CommentEngine.FreshPage(repoRelativePath, width) : Prefix.TrimEnd('\n') + "\n";
            builder.Append(WithIgnoreLine(prefix, repoRelativePath, ignoredWords).TrimEnd('\n')).Append("\n\n");
            if (!fresh)
            {
                foreach (PageSection section in Sections.Values) { builder.Append(section.Raw.TrimEnd('\n')).Append("\n\n"); }
            }
            foreach (string section in newSections) { builder.Append(section.TrimEnd('\n')).Append("\n\n"); }
            return builder.ToString().TrimEnd('\n') + "\n";
        }

        // The prefix comes back untouched when the file ignores nothing new, so a rerun leaves the page unchanged.
        static string WithIgnoreLine(string prefix, string repoRelativePath, IReadOnlyList<string> ignoredWords)
        {
            if (ignoredWords == null || ignoredWords.Count == 0) { return prefix; }
            MatchCollection existing = PageIgnoreLine.Matches(prefix);
            var words = new List<string>();
            foreach (Match match in existing)
            {
                foreach (string word in Whitespace.Split(match.Groups["words"].Value.Trim()))
                {
                    if (word.Length > 0 && !words.Contains(word)) { words.Add(word); }
                }
            }
            int before = words.Count;
            foreach (string word in ignoredWords) { if (!words.Contains(word)) { words.Add(word); } }
            if (existing.Count > 0 && words.Count == before) { return prefix; }
            string block = IgnoreLines(words);
            if (existing.Count > 0)
            {
                // The existing lines are one block: the first is replaced by the merged block, the rest are removed.
                var builder = new StringBuilder(prefix.Substring(0, existing[0].Index)).Append(block);
                int copied = existing[0].Index + existing[0].Length;
                for (int m = 1; m < existing.Count; m++)
                {
                    builder.Append(prefix, copied, existing[m].Index - copied);
                    copied = existing[m].Index + existing[m].Length;
                    if (copied < prefix.Length && prefix[copied] == '\n') { copied++; }
                }
                builder.Append(prefix, copied, prefix.Length - copied);
                return Regex.Replace(builder.ToString(), @"\n{3,}", "\n\n");
            }
            string pathLine = "# " + repoRelativePath + "\n";
            int at = prefix.IndexOf(pathLine, StringComparison.Ordinal);
            if (at < 0) { return prefix.TrimEnd('\n') + "\n\n" + block + "\n"; }
            int after = at + pathLine.Length;
            return prefix.Substring(0, after) + "\n" + block + "\n" + prefix.Substring(after);
        }

        // The words as `<!-- cspell:ignore … -->` lines, each within the Markdown line limit; the spell checker reads them all.
        static string IgnoreLines(IReadOnlyList<string> words)
        {
            const string open = "<!-- cspell:ignore";
            const string close = " -->";
            var lines = new List<string>();
            var current = new StringBuilder(open);
            int count = 0;
            foreach (string word in words)
            {
                if (count > 0 && current.Length + 1 + word.Length + close.Length > PageLineLimit)
                {
                    lines.Add(current.Append(close).ToString());
                    current = new StringBuilder(open);
                    count = 0;
                }
                current.Append(' ').Append(word);
                count++;
            }
            lines.Add(current.Append(close).ToString());
            return string.Join("\n", lines);
        }
    }
}
