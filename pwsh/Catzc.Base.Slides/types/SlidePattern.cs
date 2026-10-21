/*
---
catzc:
  immutable:
    with_body_sha: cb2901d4f758
  edges:
    test: pwsh/Catzc.Base.Slides/tests/types/SlidePattern.Tests.ps1
---
*/

using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Text.RegularExpressions;
using System.Xml.Linq;

namespace Catzc.Base.Slides;

public enum SlideFieldKind
{
    Inline,
    Block,
    Table
}

public sealed class SlideFieldSpec
{
    public string Name { get; }
    public SlideFieldKind Kind { get; }
    public bool Required { get; }
    public int Max { get; }
    public int MaxWords { get; }

    public SlideFieldSpec(string name, SlideFieldKind kind, bool required, int max, int maxWords)
    {
        Name = name;
        Kind = kind;
        Required = required;
        Max = max;
        MaxWords = maxWords;
    }

    public override string ToString() => Name + (Required ? string.Empty : "?") + " (" + Kind + ")";
}

public sealed class SlideRender
{
    public string Html { get; }
    public IReadOnlyList<SlideFault> Faults { get; }

    public SlideRender(string html, IReadOnlyList<SlideFault> faults)
    {
        Html = html ?? string.Empty;
        Faults = faults ?? new List<SlideFault>();
    }

    public override string ToString() => Faults.Count == 0 ? "rendered" : Faults.Count.ToString(CultureInfo.InvariantCulture) + " fault(s)";
}

public sealed class SlidePattern
{
    public const string TitleField = "title";
    public const string NotesField = "notes";

    private static readonly Regex Comments = new Regex("<!--.*?-->", RegexOptions.Compiled | RegexOptions.Singleline);
    private static readonly Regex BareAttribute = new Regex(@"\s(data-item|data-optional|data-separator)(?=[\s>/])", RegexOptions.Compiled);
    private static readonly Regex FieldPlaceholder = new Regex(@"\{\{([a-z][a-z0-9_]*)(\?)?\}\}", RegexOptions.Compiled);
    private static readonly Regex KitPlaceholder = new Regex(@"\{\{@([a-z][a-z0-9_.]*)\}\}", RegexOptions.Compiled);
    private static readonly Regex SelfClosing = new Regex(@"<([a-zA-Z][\w-]*)([^<>]*?)\s*/>", RegexOptions.Compiled);
    private static readonly Regex Tags = new Regex("<[^>]+>", RegexOptions.Compiled);
    private static readonly Regex Spaces = new Regex(@"\s+", RegexOptions.Compiled);

    private readonly XElement root;

    public string Name { get; }
    public IReadOnlyList<SlideFieldSpec> Fields { get; }

    private SlidePattern(string name, XElement root, IReadOnlyList<SlideFieldSpec> fields)
    {
        Name = name;
        this.root = root;
        Fields = fields;
    }

    public override string ToString() => Name + ": " + string.Join(", ", Fields.Select(f => f.ToString()));

    public SlideFieldSpec Field(string name) => Fields.FirstOrDefault(f => f.Name == name);

    public static SlidePattern Load(string name, string html)
    {
        if (string.IsNullOrWhiteSpace(name))
        {
            throw new ArgumentException("a pattern has a name, its file's stem", nameof(name));
        }

        string body = Comments.Replace(html ?? string.Empty, string.Empty).Trim();
        if (body.Length == 0)
        {
            throw new ArgumentException(string.Format(CultureInfo.InvariantCulture, "pattern '{0}' holds no section", name));
        }

        body = BareAttribute.Replace(body, " $1=\"true\"");
        XElement root;
        try
        {
            root = XElement.Parse(body, LoadOptions.PreserveWhitespace);
        }
        catch (System.Xml.XmlException error)
        {
            throw new ArgumentException(string.Format(CultureInfo.InvariantCulture, "pattern '{0}' is not one well-formed section: {1}", name, error.Message), error);
        }

        if (root.Name.LocalName != "section")
        {
            throw new ArgumentException(string.Format(CultureInfo.InvariantCulture, "pattern '{0}' must be one <section>, not <{1}>", name, root.Name.LocalName));
        }

        List<SlideFieldSpec> fields = new List<SlideFieldSpec>();
        foreach (XElement block in root.Descendants().Where(e => e.Attribute("data-field") != null))
        {
            string fieldName = (string)block.Attribute("data-field");
            SlideFieldKind kind = block.Name.LocalName == "table" ? SlideFieldKind.Table : SlideFieldKind.Block;
            bool required = block.Attribute("data-optional") == null;
            fields.Add(new SlideFieldSpec(fieldName, kind, required, IntAttribute(block, "data-max"), IntAttribute(block, "data-max-words")));
        }

        foreach (XText text in root.DescendantNodes().OfType<XText>().Where(t => !InsideBlock(t.Parent)))
        {
            foreach (Match match in FieldPlaceholder.Matches(text.Value))
            {
                string fieldName = match.Groups[1].Value;
                if (fields.Any(f => f.Name == fieldName))
                {
                    continue;
                }

                fields.Add(new SlideFieldSpec(fieldName, SlideFieldKind.Inline, !match.Groups[2].Success, 1, 0));
            }
        }

        // A field may also fill an attribute, such as an image's src.
        foreach (XAttribute attribute in root.DescendantsAndSelf().Attributes())
        {
            foreach (Match match in FieldPlaceholder.Matches(attribute.Value))
            {
                string fieldName = match.Groups[1].Value;
                if (!fields.Any(f => f.Name == fieldName))
                {
                    fields.Add(new SlideFieldSpec(fieldName, SlideFieldKind.Inline, !match.Groups[2].Success, 1, 0));
                }
            }
        }

        return new SlidePattern(name, root, fields);
    }

    public SlideRender Render(SlideSource source, string path, Func<string, string> kitValue, string id, int page)
    {
        if (source == null)
        {
            throw new ArgumentNullException(nameof(source));
        }

        List<SlideFault> faults = new List<SlideFault>();
        foreach (string error in source.Errors)
        {
            faults.Add(new SlideFault(path, string.Empty, error));
        }

        XElement clone = new XElement(root);
        FillKitValues(clone, kitValue, id, page, path, faults);
        FillBlocks(clone, source, path, faults);
        FillInline(clone, source, path, faults);

        foreach (string fieldName in source.Fields.Keys)
        {
            if (Field(fieldName) == null)
            {
                faults.Add(new SlideFault(path, fieldName, string.Format(CultureInfo.InvariantCulture, "pattern '{0}' does not know this field (it takes: {1})", Name, string.Join(", ", Fields.Select(f => f.Name)))));
            }
        }

        // Whitespace between elements is layout in the pattern file, nothing on the slide, so the section is written compact.
        foreach (XText whitespace in clone.DescendantNodes().OfType<XText>().Where(t => string.IsNullOrWhiteSpace(t.Value)).ToList())
        {
            whitespace.Remove();
        }

        string html = SelfClosing.Replace(clone.ToString(SaveOptions.DisableFormatting), "<$1$2></$1>");
        return new SlideRender(html, faults);
    }

    public static string TextOf(string html)
    {
        string text = Tags.Replace(html ?? string.Empty, " ");
        text = text.Replace("&lt;", "<").Replace("&gt;", ">").Replace("&quot;", "\"").Replace("&apos;", "'").Replace("&#39;", "'").Replace("&amp;", "&");
        return Spaces.Replace(text, " ").Trim();
    }

    private void FillKitValues(XElement clone, Func<string, string> kitValue, string id, int page, string path, List<SlideFault> faults)
    {
        MatchEvaluator evaluate = match =>
        {
            string reference = match.Groups[1].Value;
            if (reference == "id")
            {
                return id ?? string.Empty;
            }

            if (reference == "page")
            {
                return page.ToString(CultureInfo.InvariantCulture);
            }

            try
            {
                return kitValue(reference) ?? string.Empty;
            }
            catch (Exception error)
            {
                // The lookup may run as a PowerShell delegate, which wraps the kit's own exception; the innermost message is the kit's.
                Exception inner = error;
                while (inner.InnerException != null)
                {
                    inner = inner.InnerException;
                }

                faults.Add(new SlideFault(path, string.Empty, string.Format(CultureInfo.InvariantCulture, "pattern '{0}': {1}", Name, inner.Message)));
                return string.Empty;
            }
        };

        foreach (XAttribute attribute in clone.DescendantsAndSelf().Attributes())
        {
            if (attribute.Value.IndexOf("{{@", StringComparison.Ordinal) >= 0)
            {
                attribute.Value = KitPlaceholder.Replace(attribute.Value, evaluate);
            }
        }

        foreach (XText text in clone.DescendantNodes().OfType<XText>().ToList())
        {
            if (text.Value.IndexOf("{{@", StringComparison.Ordinal) >= 0)
            {
                text.Value = KitPlaceholder.Replace(text.Value, evaluate);
            }
        }
    }

    private void FillBlocks(XElement clone, SlideSource source, string path, List<SlideFault> faults)
    {
        foreach (XElement block in clone.Descendants().Where(e => e.Attribute("data-field") != null).ToList())
        {
            string fieldName = (string)block.Attribute("data-field");
            SlideFieldSpec spec = Field(fieldName);
            List<XElement> templates = block.Elements().Where(e => e.Attribute("data-item") != null).ToList();
            XElement separator = block.Elements().FirstOrDefault(e => e.Attribute("data-separator") != null);
            XElement header = templates.FirstOrDefault(t => (string)t.Attribute("data-item") == "header");
            XElement itemTemplate = templates.FirstOrDefault(t => (string)t.Attribute("data-item") == "true");
            foreach (XElement template in templates)
            {
                template.Remove();
            }

            if (separator != null)
            {
                separator.Remove();
            }

            StripDataAttributes(block);
            SlideFieldContent content;
            if (!source.Fields.TryGetValue(fieldName, out content) || content.ItemCount == 0 && !content.IsTable && content.Items.Count == 0)
            {
                if (spec.Required)
                {
                    faults.Add(new SlideFault(path, fieldName, string.Format(CultureInfo.InvariantCulture, "pattern '{0}' requires this field and the slide has none", Name)));
                }

                block.Remove();
                continue;
            }

            if (itemTemplate == null)
            {
                faults.Add(new SlideFault(path, fieldName, string.Format(CultureInfo.InvariantCulture, "pattern '{0}' declares the field without a data-item template", Name)));
                block.Remove();
                continue;
            }

            if (spec.Kind == SlideFieldKind.Table)
            {
                FillTable(block, content, header, itemTemplate, spec, path, faults);
            }
            else
            {
                FillItems(block, content, itemTemplate, separator, spec, path, faults);
            }

            if (spec.MaxWords > 0 && content.WordCount() > spec.MaxWords)
            {
                faults.Add(new SlideFault(path, fieldName, string.Format(CultureInfo.InvariantCulture, "{0} words; pattern '{1}' holds at most {2}", content.WordCount(), Name, spec.MaxWords)));
            }
        }
    }

    private void FillTable(XElement block, SlideFieldContent content, XElement header, XElement itemTemplate, SlideFieldSpec spec, string path, List<SlideFault> faults)
    {
        if (!content.IsTable)
        {
            faults.Add(new SlideFault(path, spec.Name, string.Format(CultureInfo.InvariantCulture, "pattern '{0}' takes a markdown table here, with its first row the header", Name)));
            block.Remove();
            return;
        }

        if (spec.Max > 0 && content.ItemCount > spec.Max)
        {
            faults.Add(new SlideFault(path, spec.Name, string.Format(CultureInfo.InvariantCulture, "{0} rows; pattern '{1}' holds at most {2}", content.ItemCount, Name, spec.Max)));
        }

        for (int index = 0; index < content.Rows.Count; index++)
        {
            XElement template = index == 0 && header != null ? header : itemTemplate;
            XElement row = new XElement(template);
            StripDataAttributes(row);
            XElement cellTemplate = row.Elements().FirstOrDefault();
            if (cellTemplate == null)
            {
                faults.Add(new SlideFault(path, spec.Name, string.Format(CultureInfo.InvariantCulture, "pattern '{0}': a row template holds one cell template", Name)));
                break;
            }

            cellTemplate.Remove();
            foreach (string cell in content.Rows[index])
            {
                XElement filled = new XElement(cellTemplate);
                ReplaceText(filled, "{{cell}}", cell);
                row.Add(filled);
            }

            block.Add(row);
        }
    }

    private void FillItems(XElement block, SlideFieldContent content, XElement itemTemplate, XElement separator, SlideFieldSpec spec, string path, List<SlideFault> faults)
    {
        if (content.IsTable)
        {
            faults.Add(new SlideFault(path, spec.Name, string.Format(CultureInfo.InvariantCulture, "pattern '{0}' takes paragraphs or a list here, not a table", Name)));
            block.Remove();
            return;
        }

        if (spec.Max > 0 && content.Items.Count > spec.Max)
        {
            faults.Add(new SlideFault(path, spec.Name, string.Format(CultureInfo.InvariantCulture, "{0} items; pattern '{1}' holds at most {2}", content.Items.Count, Name, spec.Max)));
        }

        bool wantsLead = itemTemplate.ToString(SaveOptions.DisableFormatting).IndexOf("{{item.lead}}", StringComparison.Ordinal) >= 0;
        for (int index = 0; index < content.Items.Count; index++)
        {
            SlideItem item = content.Items[index];
            if (index > 0 && separator != null)
            {
                XElement between = new XElement(separator);
                StripDataAttributes(between);
                block.Add(between);
            }

            XElement filled = new XElement(itemTemplate);
            StripDataAttributes(filled);
            if (wantsLead)
            {
                if (item.Lead == null)
                {
                    faults.Add(new SlideFault(path, spec.Name, string.Format(CultureInfo.InvariantCulture, "item {0} has no bold lead; pattern '{1}' shows one per item", index + 1, Name)));
                }

                ReplaceText(filled, "{{item.lead}}", item.Lead ?? string.Empty);
            }

            ReplaceText(filled, "{{item}}", item.Lead != null && !wantsLead ? item.Lead + ": " + item.Text : item.Text);
            block.Add(filled);
        }
    }

    private void FillInline(XElement clone, SlideSource source, string path, List<SlideFault> faults)
    {
        foreach (XText text in clone.DescendantNodes().OfType<XText>().Where(t => t.Value.IndexOf("{{", StringComparison.Ordinal) >= 0).ToList())
        {
            bool removeParent = false;
            string value = FieldPlaceholder.Replace(text.Value, match =>
            {
                string fieldName = match.Groups[1].Value;
                bool optional = match.Groups[2].Success;
                if (fieldName == TitleField)
                {
                    return source.Title ?? string.Empty;
                }

                SlideFieldContent content;
                if (!source.Fields.TryGetValue(fieldName, out content) || content.Items.Count == 0)
                {
                    if (optional)
                    {
                        removeParent = true;
                    }
                    else
                    {
                        faults.Add(new SlideFault(path, fieldName, string.Format(CultureInfo.InvariantCulture, "pattern '{0}' requires this field and the slide has none", Name)));
                    }

                    return string.Empty;
                }

                if (content.Items.Count > 1 || content.IsTable)
                {
                    faults.Add(new SlideFault(path, fieldName, string.Format(CultureInfo.InvariantCulture, "pattern '{0}' takes one line here; the slide gives {1} items", Name, content.Items.Count)));
                }

                return string.Join(" ", content.Items.Select(i => i.ToString()));
            });

            if (removeParent && text.Parent != null && text.Parent.Parent != null)
            {
                text.Parent.Remove();
                continue;
            }

            text.Value = value.Trim();
        }

        foreach (XAttribute attribute in clone.DescendantsAndSelf().Attributes().Where(a => FieldPlaceholder.IsMatch(a.Value)).ToList())
        {
            attribute.Value = FieldPlaceholder.Replace(attribute.Value, match =>
            {
                string fieldName = match.Groups[1].Value;
                if (fieldName == TitleField)
                {
                    return source.Title ?? string.Empty;
                }

                SlideFieldContent content;
                if (source.Fields.TryGetValue(fieldName, out content) && content.Items.Count == 1 && !content.IsTable)
                {
                    return content.Items[0].ToString().Trim();
                }

                if (!match.Groups[2].Success)
                {
                    faults.Add(new SlideFault(path, fieldName, string.Format(CultureInfo.InvariantCulture, "pattern '{0}' requires this field as one line and the slide has none", Name)));
                }

                return string.Empty;
            }).Trim();
        }
    }

    private static void ReplaceText(XElement element, string placeholder, string value)
    {
        foreach (XText text in element.DescendantNodes().OfType<XText>().Where(t => t.Value.IndexOf(placeholder, StringComparison.Ordinal) >= 0).ToList())
        {
            text.Value = text.Value.Replace(placeholder, value ?? string.Empty).Trim();
        }
    }

    private static void StripDataAttributes(XElement element)
    {
        foreach (XAttribute attribute in element.Attributes().Where(a => a.Name.LocalName.StartsWith("data-", StringComparison.Ordinal) && a.Name.LocalName != "data-transition").ToList())
        {
            attribute.Remove();
        }
    }

    private static bool InsideBlock(XElement element)
    {
        for (XElement current = element; current != null; current = current.Parent)
        {
            if (current.Attribute("data-field") != null)
            {
                return true;
            }
        }

        return false;
    }

    private static int IntAttribute(XElement element, string name)
    {
        string value = (string)element.Attribute(name);
        int parsed;
        if (value != null && int.TryParse(value, NumberStyles.None, CultureInfo.InvariantCulture, out parsed))
        {
            return parsed;
        }

        return 0;
    }
}
