/*
---
catzc:
  derived:
    path: automation/Catzc.Base.Docs/types/GitHubAnchor.cs
    kind: type
    language: csharp
    filetype: cs
    track: automation
    module: Catzc.Base.Docs
    moduletype: pwsh-folder-module
    bundle: azure
    relatives:
      page: docs/references/automation/catzc-base-docs/types/GitHubAnchor.cs.md
      test: automation/Catzc.Base.Docs/tests/types/GitHubAnchor.Tests.ps1
    adrs:
      - ADR-REPO-LINK#2
---
*/

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
