// GitHub's heading anchors: the slug GitHub renders for a markdown heading, and the full anchor set of a
// markdown document — what a link's #fragment must name to resolve on GitHub
// ([ADR-REPO-LINK#2](/docs/adr/repository/markdown-links.md#rule-adr-repo-link2)).
//
// The slug follows GitHub's rendered-text algorithm: inline markup is reduced to its text (code-span backticks
// dropped, a link to its text, emphasis asterisks dropped), the text is lowercased, every character that is not
// a letter, digit, space, hyphen, or underscore is removed, and each space becomes a hyphen. Duplicate headings
// in one document take -1, -2, … suffixes in document order. Headings inside fenced code blocks are not
// headings; an explicit <a id="…"> or <a name="…"> is an anchor too.

using System;
using System.Collections.Generic;
using System.Globalization;
using System.Text;
using System.Text.RegularExpressions;

namespace Catzc.Base.Docs;

public static class GitHubAnchor
{
    static readonly Regex Image = new Regex(@"!\[([^\]]*)\]\([^)]*\)", RegexOptions.Compiled);
    static readonly Regex Link = new Regex(@"\[([^\]]*)\]\([^)]*\)", RegexOptions.Compiled);
    static readonly Regex Atx = new Regex(@"^ {0,3}(#{1,6})(?:[ \t]+(.*?))?(?:[ \t]+#+)?[ \t]*$", RegexOptions.Compiled);
    static readonly Regex Fence = new Regex(@"^ {0,3}(`{3,}|~{3,})", RegexOptions.Compiled);
    static readonly Regex SetextUnderline = new Regex(@"^ {0,3}(=+|-+)[ \t]*$", RegexOptions.Compiled);
    static readonly Regex HtmlAnchor = new Regex(@"<a\s+(?:[^>]*?\s)?(?:id|name)\s*=\s*""([^""]+)""", RegexOptions.Compiled | RegexOptions.IgnoreCase);

    // The anchor GitHub renders for one heading's text (without the leading #s), before duplicate suffixing.
    public static string Slug(string heading)
    {
        if (heading == null) { return string.Empty; }

        string text = Image.Replace(heading, "$1");
        text = Link.Replace(text, "$1");
        text = text.Replace("`", string.Empty).Replace("*", string.Empty);

        var slug = new StringBuilder(text.Length);
        foreach (char c in text.Trim().ToLower(CultureInfo.InvariantCulture))
        {
            if (char.IsLetterOrDigit(c) || c == '-' || c == '_')
            {
                slug.Append(c);
            }
            else if (c == ' ')
            {
                slug.Append('-');
            }
        }
        return slug.ToString();
    }

    // Every anchor a markdown document exposes: heading slugs (with GitHub's -1/-2 duplicate suffixes) plus
    // explicit HTML anchors. Fenced code blocks are skipped.
    public static IReadOnlyCollection<string> Anchors(string markdown)
    {
        var anchors = new HashSet<string>(StringComparer.Ordinal);
        var seen = new Dictionary<string, int>(StringComparer.Ordinal);
        if (string.IsNullOrEmpty(markdown)) { return anchors; }

        string[] lines = markdown.Replace("\r\n", "\n").Split('\n');
        string fence = null;
        for (int i = 0; i < lines.Length; i++)
        {
            string line = lines[i];
            Match fenceMatch = Fence.Match(line);
            if (fence != null)
            {
                if (fenceMatch.Success && fenceMatch.Groups[1].Value[0] == fence[0] && fenceMatch.Groups[1].Value.Length >= fence.Length)
                {
                    fence = null;
                }
                continue;
            }
            if (fenceMatch.Success)
            {
                fence = fenceMatch.Groups[1].Value;
                continue;
            }

            foreach (Match html in HtmlAnchor.Matches(line))
            {
                anchors.Add(html.Groups[1].Value);
            }

            string heading = null;
            Match atx = Atx.Match(line);
            if (atx.Success)
            {
                heading = atx.Groups[2].Value;
            }
            else if (i + 1 < lines.Length && SetextUnderline.IsMatch(lines[i + 1]) && IsSetextText(line))
            {
                heading = line.Trim();
            }
            if (heading == null) { continue; }

            string slug = Slug(heading);
            if (seen.TryGetValue(slug, out int count))
            {
                seen[slug] = count + 1;
                anchors.Add(slug + "-" + count.ToString(CultureInfo.InvariantCulture));
            }
            else
            {
                seen[slug] = 1;
                anchors.Add(slug);
            }
        }
        return anchors;
    }

    // A setext heading's text line: non-blank paragraph text, not a list item, table row, quote, or thematic break.
    static bool IsSetextText(string line)
    {
        string trimmed = line.Trim();
        if (trimmed.Length == 0) { return false; }
        char first = trimmed[0];
        if (first == '|' || first == '>' || first == '-' || first == '*' || first == '+' || first == '#' || first == '<') { return false; }
        return !char.IsDigit(first) || !Regex.IsMatch(trimmed, @"^\d+[.)]\s");
    }
}
