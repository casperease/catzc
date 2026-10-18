using System;
using System.Collections;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;

namespace Catzc.Base.QualityGates;

// The help of a PowerShell function file or script, as the `## help` section of its comment page holds it (ADR-REPO-HELP#1).
public sealed class FunctionHelp
{
    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    public const string SectionTitle = "## help";

    static readonly Regex HelpHeading = new Regex(@"^## help[ \t]*$", RegexOptions.Compiled | RegexOptions.Multiline);
    static readonly Regex AnySection = new Regex(@"^## ", RegexOptions.Compiled | RegexOptions.Multiline);
    static readonly Regex Subsection = new Regex(@"^### (?<name>\S+)(?: (?<arg>\S+))?[ \t]*$", RegexOptions.Compiled);

    // The subsections in their one order; a parameter and an example repeat in place.
    static readonly string[] Order = { "synopsis", "description", "parameter", "inputs", "outputs", "example", "notes" };

    public string synopsis { get; private set; }
    public string description { get; private set; }
    public IReadOnlyList<KeyValuePair<string, string>> parameters { get; private set; } = new List<KeyValuePair<string, string>>();
    public string inputs { get; private set; }
    public string outputs { get; private set; }
    public IReadOnlyList<string> examples { get; private set; } = new List<string>();
    public string notes { get; private set; }

    // The shape faults the section has, each a sentence an author acts on.
    public IReadOnlyList<string> findings { get; private set; } = new List<string>();

    // Whether the page holds a help section at all.
    public bool present { get; private set; }

    // The help as a head's config part holds it: synopsis, description, parameters (name to text), inputs, outputs, examples, notes.
    public static FunctionHelp FromConfig(IDictionary config)
    {
        var help = new FunctionHelp { present = config != null };
        if (config == null) { return help; }
        help.synopsis = Text(config, "synopsis");
        help.description = Text(config, "description");
        var parameters = new List<KeyValuePair<string, string>>();
        if (config.Contains("parameters") && config["parameters"] is IDictionary map)
        {
            foreach (DictionaryEntry entry in map)
            {
                parameters.Add(new KeyValuePair<string, string>(Convert.ToString(entry.Key, CultureInfo.InvariantCulture), Convert.ToString(entry.Value, CultureInfo.InvariantCulture)));
            }
        }
        help.parameters = parameters;
        help.inputs = Text(config, "inputs");
        help.outputs = Text(config, "outputs");
        var examples = new List<string>();
        if (config.Contains("examples") && config["examples"] is IEnumerable items && !(config["examples"] is string))
        {
            foreach (object item in items) { examples.Add(Convert.ToString(item, CultureInfo.InvariantCulture)); }
        }
        help.examples = examples;
        help.notes = Text(config, "notes");
        return help;
    }

    // The `## help` section in its fixed shape, ending in a newline.
    public string ToSection()
    {
        var text = new StringBuilder(SectionTitle).Append("\n\n");
        Part(text, "synopsis", synopsis);
        Part(text, "description", description);
        foreach (KeyValuePair<string, string> parameter in parameters) { Part(text, "parameter " + parameter.Key, parameter.Value); }
        Part(text, "inputs", inputs);
        Part(text, "outputs", outputs);
        for (int i = 0; i < examples.Count; i++)
        {
            text.Append("### example ").Append((i + 1).ToString(CultureInfo.InvariantCulture)).Append("\n\n");
            text.Append("```powershell\n").Append(Trimmed(examples[i])).Append("\n```\n\n");
        }
        Part(text, "notes", notes);
        return text.ToString().TrimEnd('\n') + "\n";
    }

    // The page with its help section written: an existing one is replaced, a new one goes before the page's first section.
    public static string WithSection(string pageText, string section)
    {
        string page = (pageText ?? string.Empty).Replace("\r\n", "\n");
        string block = section.TrimEnd('\n') + "\n";
        Match existing = HelpHeading.Match(page);
        if (existing.Success)
        {
            int end = NextSection(page, existing.Index + existing.Length);
            string after = page.Substring(end);
            return page.Substring(0, existing.Index) + block + (after.Length > 0 ? "\n" + after : string.Empty);
        }
        Match first = AnySection.Match(page);
        if (first.Success)
        {
            return page.Substring(0, first.Index) + block + "\n" + page.Substring(first.Index);
        }
        return page.TrimEnd('\n') + "\n\n" + block;
    }

    // The help a page's `## help` section holds, with a finding for every subsection the shape does not name or holds out of order.
    public static FunctionHelp Parse(string pageText)
    {
        var help = new FunctionHelp();
        var findings = new List<string>();
        string page = (pageText ?? string.Empty).Replace("\r\n", "\n");
        Match heading = HelpHeading.Match(page);
        if (!heading.Success)
        {
            help.findings = findings;
            return help;
        }
        help.present = true;
        int end = NextSection(page, heading.Index + heading.Length);
        string[] lines = page.Substring(heading.Index + heading.Length, end - heading.Index - heading.Length).Split('\n');

        var parameters = new List<KeyValuePair<string, string>>();
        var examples = new List<string>();
        int last = -1;
        string name = null;
        string arg = null;
        var body = new List<string>();
        bool inFence = false;
        void Flush()
        {
            if (name == null) { return; }
            string value = string.Join("\n", body).Trim('\n');
            switch (name)
            {
                case "synopsis": help.synopsis = Paragraph(value); break;
                case "description": help.description = value; break;
                case "parameter": parameters.Add(new KeyValuePair<string, string>(arg, value)); break;
                case "inputs": help.inputs = value; break;
                case "outputs": help.outputs = value; break;
                case "example": examples.Add(Unfenced(value)); break;
                case "notes": help.notes = value; break;
            }
        }
        foreach (string line in lines)
        {
            if (line.TrimStart().StartsWith("```", StringComparison.Ordinal)) { inFence = !inFence; }
            Match sub = inFence ? Match.Empty : Subsection.Match(line);
            if (!sub.Success)
            {
                if (name != null) { body.Add(line); }
                else if (line.Trim().Length > 0) { findings.Add("the help section holds text before its first subsection: put it under ### synopsis or ### description"); }
                continue;
            }
            Flush();
            body.Clear();
            name = sub.Groups["name"].Value;
            arg = sub.Groups["arg"].Success ? sub.Groups["arg"].Value : null;
            int rank = Array.IndexOf(Order, name);
            bool needsArg = name == "parameter" || name == "example";
            if (rank < 0 || needsArg != (arg != null))
            {
                findings.Add("the help section has a subsection the shape does not name: '" + line.Trim() + "'");
                name = null;
                continue;
            }
            bool repeats = needsArg && rank == last;
            if (rank < last || (rank == last && !repeats))
            {
                findings.Add("the help subsection '" + line.Trim() + "' is out of order: the order is synopsis, description, parameter, inputs, outputs, example, notes");
            }
            last = Math.Max(last, rank);
        }
        Flush();
        help.parameters = parameters;
        help.examples = examples;
        if (string.IsNullOrWhiteSpace(help.synopsis)) { findings.Add("the help section has no synopsis"); }
        help.findings = findings;
        return help;
    }

    static int NextSection(string page, int from)
    {
        Match next = AnySection.Match(page, from);
        return next.Success ? next.Index : page.Length;
    }

    static string Text(IDictionary config, string key) =>
        config.Contains(key) && config[key] != null ? Convert.ToString(config[key], CultureInfo.InvariantCulture) : null;

    static void Part(StringBuilder text, string heading, string value)
    {
        if (string.IsNullOrWhiteSpace(value)) { return; }
        text.Append("### ").Append(heading).Append("\n\n").Append(Markdown(Trimmed(value))).Append("\n\n");
    }

    static readonly Regex ListItem = new Regex(@"^(?<indent>[ \t]*)(?<marker>[-*+]|\d+[.)])[ \t]+(?<rest>.*)$", RegexOptions.Compiled);
    static readonly Regex Protected = new Regex(@"`[^`]*`|\[[^\]\n]*\]\([^)\s]*\)|<https?://[^>\s]+>", RegexOptions.Compiled);
    static readonly Regex SpacedPlaceholder = new Regex(@"(?<![\w`])<[A-Za-z][^<>\n`]*? [^<>\n`]*?>", RegexOptions.Compiled);
    static readonly Regex Emphasis = new Regex(@"(?<![\w*])\*(?<word>[A-Za-z0-9][\w'-]*)\*(?![\w*])", RegexOptions.Compiled);
    static readonly Regex Token = new Regex(@"\S+", RegexOptions.Compiled);
    static readonly Regex Placeholder = new Regex(@"<[^<>\s]+>|\*|\[[^\]]*\]", RegexOptions.Compiled);

    // Plain help text written inside YAML, as Markdown that means the same: lists at the margin, aligned layouts fenced verbatim, and a
    // placeholder, glob or bracket token in a code span, so a formatter or a linter reads what the author wrote.
    public static string Markdown(string text)
    {
        string[] lines = (text ?? string.Empty).Replace("\r\n", "\n").Split('\n');
        var output = new List<string>();
        int listBase = -1;
        for (int i = 0; i < lines.Length; i++)
        {
            string line = lines[i];
            if (line.TrimStart().StartsWith("```", StringComparison.Ordinal))
            {
                listBase = -1;
                Blank(output);
                int close = i + 1;
                while (close < lines.Length && !lines[close].TrimStart().StartsWith("```", StringComparison.Ordinal)) { close++; }
                for (int k = i; k <= Math.Min(close, lines.Length - 1); k++) { output.Add(lines[k].TrimEnd()); }
                i = close;
                output.Add(string.Empty);
                continue;
            }
            if (line.Trim().Length == 0)
            {
                if (output.Count > 0 && output[output.Count - 1].Length > 0) { output.Add(string.Empty); }
                continue;
            }
            int indent = Indent(line);
            Match item = ListItem.Match(line);
            if (item.Success && (listBase < 0 ? true : indent >= listBase))
            {
                if (listBase < 0) { listBase = indent; Blank(output); }
                string marker = char.IsDigit(item.Groups["marker"].Value[0]) ? item.Groups["marker"].Value : "-";
                output.Add(new string(' ', indent - listBase) + marker + " " + Inline(item.Groups["rest"].Value));
                continue;
            }
            if (listBase >= 0 && indent > listBase)
            {
                output.Add(new string(' ', indent - listBase) + Inline(line.Trim()));
                continue;
            }
            if (listBase >= 0) { listBase = -1; Blank(output); }
            if (indent >= 2)
            {
                // An indented run that is no list is a layout the author aligned by hand: kept verbatim in a fence.
                int end = i;
                while (end + 1 < lines.Length && lines[end + 1].Trim().Length > 0 && Indent(lines[end + 1]) >= 2 && !ListItem.IsMatch(lines[end + 1])) { end++; }
                int strip = Enumerable.Range(i, end - i + 1).Min(k => Indent(lines[k]));
                Blank(output);
                output.Add("```text");
                for (int k = i; k <= end; k++) { output.Add(lines[k].Substring(strip).TrimEnd()); }
                output.Add("```");
                output.Add(string.Empty);
                i = end;
                continue;
            }
            output.Add(Inline(line.TrimEnd()));
        }
        while (output.Count > 0 && output[output.Count - 1].Length == 0) { output.RemoveAt(output.Count - 1); }
        return string.Join("\n", output);
    }

    static void Blank(List<string> output)
    {
        if (output.Count > 0 && output[output.Count - 1].Length > 0) { output.Add(string.Empty); }
    }

    static int Indent(string line) => line.Length - line.TrimStart(' ', '\t').Length;

    // One line of prose: code spans, links and URLs kept, emphasis written with underscores, and a token Markdown would misread spanned.
    static string Inline(string line)
    {
        var kept = new List<string>();
        string Keep(string value) { kept.Add(value); return "\u0001" + (kept.Count - 1).ToString(CultureInfo.InvariantCulture) + "\u0002"; }
        string masked = Protected.Replace(line, m => Keep(m.Value));
        masked = SpacedPlaceholder.Replace(masked, m => Keep("`" + m.Value + "`"));
        masked = Emphasis.Replace(masked, m => "_" + m.Groups["word"].Value + "_");
        masked = Token.Replace(masked, m => Spanned(m.Value));
        return Regex.Replace(masked, "\u0001(\\d+)\u0002", m => kept[int.Parse(m.Groups[1].Value, CultureInfo.InvariantCulture)]);
    }

    static string Spanned(string token)
    {
        if (token.Contains('\u0001')) { return token; }
        int url = token.IndexOf("://", StringComparison.Ordinal);
        if (url > 0 && Regex.IsMatch(token.Substring(0, url), @"(^|[('""])https?$"))
        {
            // A URL with a placeholder in it is a pattern, so a code span; any other bare URL is an autolink.
            int open = token.IndexOf("http", StringComparison.Ordinal);
            int close = token.Length;
            while (close > open && ".,;:)'\"".IndexOf(token[close - 1]) >= 0) { close--; }
            string address = token.Substring(open, close - open);
            string wrapped = address.IndexOfAny(new[] { '<', '{', '*' }) >= 0 ? "`" + address + "`" : "<" + address + ">";
            return token.Substring(0, open) + wrapped + token.Substring(close);
        }
        if (!Placeholder.IsMatch(token)) { return token; }
        if (Regex.IsMatch(token, @"^\*\*[^*]+\*\*[.,;:)]*$")) { return token; }
        int start = 0;
        int end = token.Length;
        while (start < end && "('\"".IndexOf(token[start]) >= 0) { start++; }
        while (end > start && ".,;:)'\"".IndexOf(token[end - 1]) >= 0) { end--; }
        if (end <= start) { return token; }
        string core = token.Substring(start, end - start);
        if (!Placeholder.IsMatch(core)) { return token; }
        return token.Substring(0, start) + "`" + core + "`" + token.Substring(end);
    }

    static string Trimmed(string value) => value.Replace("\r\n", "\n").Trim('\n').TrimEnd();

    // A paragraph a formatter wrapped reads back as the one line it was written as.
    static string Paragraph(string value) => string.Join(" ", value.Split('\n').Select(l => l.Trim()).Where(l => l.Length > 0));

    static string Unfenced(string value)
    {
        var lines = value.Split('\n').ToList();
        if (lines.Count >= 2 && lines[0].TrimStart().StartsWith("```", StringComparison.Ordinal) && lines[lines.Count - 1].Trim() == "```")
        {
            lines = lines.Skip(1).Take(lines.Count - 2).ToList();
        }
        return string.Join("\n", lines);
    }
}
