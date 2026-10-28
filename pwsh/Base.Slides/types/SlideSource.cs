using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Text.RegularExpressions;

namespace Catzc.Base.Slides;

public sealed class SlideItem
{
    public string Lead { get; }
    public string Text { get; }

    // The target of the item when the item is exactly one markdown link, [text](target); null for any other item.
    public string Target { get; }

    public SlideItem(string lead, string text, string target)
    {
        Lead = lead;
        Text = text ?? string.Empty;
        Target = target;
    }

    public override string ToString() => Lead == null ? Text : Lead + ": " + Text;
}

public sealed class SlideFieldContent
{
    public string Name { get; }
    public IReadOnlyList<SlideItem> Items { get; }
    public IReadOnlyList<IReadOnlyList<string>> Rows { get; }
    public bool IsTable => Rows.Count > 0;
    public bool IsList { get; }

    public SlideFieldContent(string name, IReadOnlyList<SlideItem> items, IReadOnlyList<IReadOnlyList<string>> rows, bool isList)
    {
        Name = name;
        Items = items ?? new List<SlideItem>();
        Rows = rows ?? new List<IReadOnlyList<string>>();
        IsList = isList;
    }

    public int ItemCount => IsTable ? Math.Max(0, Rows.Count - 1) : Items.Count;

    public IEnumerable<string> Texts()
    {
        foreach (SlideItem item in Items)
        {
            if (item.Lead != null)
            {
                yield return item.Lead;
            }

            if (item.Text.Length > 0)
            {
                yield return item.Text;
            }
        }

        foreach (IReadOnlyList<string> row in Rows)
        {
            foreach (string cell in row)
            {
                if (cell.Length > 0)
                {
                    yield return cell;
                }
            }
        }
    }

    public int WordCount() => Texts().Sum(text => SlideSource.WordCount(text));

    public override string ToString() => Name + " (" + ItemCount.ToString(CultureInfo.InvariantCulture) + " items)";
}

public sealed class SlideSource
{
    private static readonly Regex Heading1 = new Regex(@"^#\s+(.+?)\s*$", RegexOptions.Compiled);
    private static readonly Regex Heading2 = new Regex(@"^##\s+(.+?)\s*$", RegexOptions.Compiled);
    private static readonly Regex ListItem = new Regex(@"^\s*(?:[-*+]|\d+[.)])\s+(.*)$", RegexOptions.Compiled);
    private static readonly Regex TableSeparator = new Regex(@"^\s*\|?\s*:?-{3,}:?\s*(\|\s*:?-{3,}:?\s*)*\|?\s*$", RegexOptions.Compiled);
    private static readonly Regex Lead = new Regex(@"^\*\*(.+?)\*\*\s*[:—–-]?\s*(.*)$", RegexOptions.Compiled | RegexOptions.Singleline);
    private static readonly Regex Link = new Regex(@"\[([^\]]+)\]\([^)]*\)", RegexOptions.Compiled);
    private static readonly Regex OneLink = new Regex(@"^\[[^\]]+\]\(([^)\s]+)\)$", RegexOptions.Compiled);
    private static readonly Regex Emphasis = new Regex(@"(\*\*|__|`)", RegexOptions.Compiled);
    private static readonly Regex Spaces = new Regex(@"\s+", RegexOptions.Compiled);

    public string Title { get; }
    public IReadOnlyDictionary<string, SlideFieldContent> Fields { get; }
    public IReadOnlyList<string> Errors { get; }

    private SlideSource(string title, IReadOnlyDictionary<string, SlideFieldContent> fields, IReadOnlyList<string> errors)
    {
        Title = title;
        Fields = fields;
        Errors = errors;
    }

    public override string ToString() => Title ?? "(no title)";

    public static SlideSource Parse(string body)
    {
        List<string> errors = new List<string>();
        Dictionary<string, SlideFieldContent> fields = new Dictionary<string, SlideFieldContent>(StringComparer.Ordinal);
        string title = null;
        string fieldName = null;
        List<SlideItem> items = new List<SlideItem>();
        List<IReadOnlyList<string>> rows = new List<IReadOnlyList<string>>();
        List<string> paragraph = new List<string>();
        bool isList = false;

        Action flushParagraph = () =>
        {
            if (paragraph.Count > 0)
            {
                items.Add(ItemOf(string.Join(" ", paragraph)));
                paragraph.Clear();
            }
        };
        Action flushField = () =>
        {
            flushParagraph();
            if (fieldName != null)
            {
                if (fields.ContainsKey(fieldName))
                {
                    errors.Add(string.Format(CultureInfo.InvariantCulture, "the field '{0}' appears twice", fieldName));
                }
                else
                {
                    fields[fieldName] = new SlideFieldContent(fieldName, new List<SlideItem>(items), new List<IReadOnlyList<string>>(rows), isList);
                }
            }

            items = new List<SlideItem>();
            rows = new List<IReadOnlyList<string>>();
            isList = false;
        };

        foreach (string raw in (body ?? string.Empty).Replace("\r\n", "\n").Split('\n'))
        {
            string line = raw.TrimEnd();
            Match h1 = Heading1.Match(line);
            if (h1.Success)
            {
                if (title == null)
                {
                    flushField();
                    fieldName = null;
                    title = PlainText(h1.Groups[1].Value);
                }
                else
                {
                    errors.Add("a slide has one level-one heading, its title; a second one was found");
                }

                continue;
            }

            Match h2 = Heading2.Match(line);
            if (h2.Success)
            {
                flushField();
                fieldName = PlainText(h2.Groups[1].Value).ToLowerInvariant().Replace(' ', '_');
                continue;
            }

            if (line.Length == 0)
            {
                flushParagraph();
                continue;
            }

            if (fieldName == null)
            {
                errors.Add(string.Format(CultureInfo.InvariantCulture, "text outside a field: '{0}'", line.Trim()));
                continue;
            }

            if (line.TrimStart().StartsWith("|", StringComparison.Ordinal))
            {
                flushParagraph();
                if (!TableSeparator.IsMatch(line))
                {
                    rows.Add(CellsOf(line));
                }

                continue;
            }

            Match item = ListItem.Match(line);
            if (item.Success)
            {
                flushParagraph();
                isList = true;
                items.Add(ItemOf(item.Groups[1].Value));
                continue;
            }

            // An indented line under a list item continues that item, as a formatter wraps a long item.
            if (isList && paragraph.Count == 0 && items.Count > 0 && char.IsWhiteSpace(raw[0]))
            {
                SlideItem last = items[items.Count - 1];
                items[items.Count - 1] = new SlideItem(last.Lead, (last.Text + " " + PlainText(line)).Trim(), null);
                continue;
            }

            paragraph.Add(line.Trim());
        }

        flushField();
        if (title == null)
        {
            errors.Add("a slide has a level-one heading, its title; none was found");
        }

        return new SlideSource(title, fields, errors);
    }

    public static string PlainText(string markdown)
    {
        if (string.IsNullOrEmpty(markdown))
        {
            return string.Empty;
        }

        string text = Link.Replace(markdown, "$1");
        text = Emphasis.Replace(text, string.Empty);
        return Spaces.Replace(text, " ").Trim();
    }

    public static int WordCount(string text)
    {
        if (string.IsNullOrWhiteSpace(text))
        {
            return 0;
        }

        return Spaces.Split(text.Trim()).Length;
    }

    private static SlideItem ItemOf(string markdown)
    {
        Match lead = Lead.Match(markdown.Trim());
        if (lead.Success)
        {
            return new SlideItem(PlainText(lead.Groups[1].Value), PlainText(lead.Groups[2].Value), null);
        }

        Match link = OneLink.Match(markdown.Trim());
        return new SlideItem(null, PlainText(markdown), link.Success ? link.Groups[1].Value : null);
    }

    private static IReadOnlyList<string> CellsOf(string line)
    {
        string inner = line.Trim();
        if (inner.StartsWith("|", StringComparison.Ordinal))
        {
            inner = inner.Substring(1);
        }

        if (inner.EndsWith("|", StringComparison.Ordinal))
        {
            inner = inner.Substring(0, inner.Length - 1);
        }

        return inner.Split('|').Select(cell => PlainText(cell)).ToList();
    }
}
