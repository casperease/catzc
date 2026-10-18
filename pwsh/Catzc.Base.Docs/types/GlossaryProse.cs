using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Management.Automation.Language;
using System.Text;
using System.Text.RegularExpressions;

namespace Catzc.Base.Docs;

public static class GlossaryProse
{
    static readonly Regex FenceMarker = new Regex("^(`{3,}|~{3,})", RegexOptions.Compiled);
    static readonly Regex LinkDestination = new Regex(@"\]\(([^)\s]+)", RegexOptions.Compiled);
    // A link label that is a bare repository path (no blanks, a folder, a file extension) is a name, not prose.
    static readonly Regex PathLabel = new Regex(@"\[[^\]\s]*/[^\]\s]*\.[A-Za-z0-9]+\]", RegexOptions.Compiled);
    // A reference-style link definition (`[3]: ../path.md`) holds a destination, not prose.
    static readonly Regex LinkDefinition = new Regex(@"^\s{0,3}\[[^\]]+\]:\s*\S+", RegexOptions.Compiled);
    static readonly Regex HelpKeyword = new Regex(@"(?im)^\s*\.(SYNOPSIS|DESCRIPTION)\b", RegexOptions.Compiled);
    static readonly Regex Mentions = new Regex(Span("`", "`") + "|" + Span("\"", "\"") + "|" + Span("“", "”"), RegexOptions.Compiled);
    static readonly HashSet<string> Writers = new HashSet<string>(StringComparer.OrdinalIgnoreCase) { "Write-Message", "Write-Warning", "Write-Error", "Write-Host" };
    static readonly HashSet<string> MessageParameters = new HashSet<string>(StringComparer.OrdinalIgnoreCase) { "ErrorText", "Because" };

    // One character of a span: anything but the closing delimiter, or a newline not followed by a blank line.
    static string Span(string open, string close) =>
        Regex.Escape(open) + "(?:[^" + Regex.Escape(close) + "\\n]|\\n(?![ \\t]*\\n))*?" + Regex.Escape(close);

    // Blanks every mention to spaces, keeping its line breaks.
    public static string RemoveMentions(string text)
    {
        if (string.IsNullOrEmpty(text)) { return text ?? string.Empty; }
        return Mentions.Replace(text, m =>
        {
            StringBuilder blank = new StringBuilder(m.Length);
            foreach (char c in m.Value) { blank.Append(c == '\n' ? '\n' : ' '); }
            return blank.ToString();
        });
    }

    public static GlossarySegment[] Markdown(string path)
    {
        string[] lines = File.ReadAllLines(path);
        string fence = null;
        // The meta block (the `catzc:` key and everything indented under it) holds derived facts and config, not prose.
        bool inFrontMatter = lines.Length > 1 && lines[0] == "---";
        bool inMeta = false;
        for (int i = 0; i < lines.Length; i++)
        {
            if (inFrontMatter && i > 0)
            {
                if (lines[i] == "---") { inFrontMatter = false; inMeta = false; continue; }
                if (lines[i] == "catzc:") { inMeta = true; lines[i] = string.Empty; continue; }
                if (inMeta && lines[i].Length > 0 && char.IsWhiteSpace(lines[i][0])) { lines[i] = string.Empty; continue; }
                inMeta = false;
            }
            Match marker = FenceMarker.Match(lines[i].TrimStart());
            if (fence == null)
            {
                if (marker.Success)
                {
                    fence = marker.Value;
                    lines[i] = string.Empty;
                }
                else
                {
                    lines[i] = LinkDestination.Replace(lines[i], m => "](" + new string(' ', m.Groups[1].Length));
                    lines[i] = PathLabel.Replace(lines[i], m => new string(' ', m.Length));
                    lines[i] = LinkDefinition.Replace(lines[i], m => new string(' ', m.Length));
                }
                continue;
            }
            // Inside a fence: blank the line; a marker of the same kind and at least the opening length closes it.
            if (marker.Success && marker.Value.StartsWith(fence, StringComparison.Ordinal)) { fence = null; }
            lines[i] = string.Empty;
        }
        return new[] { new GlossarySegment("markdown", 1, RemoveMentions(string.Join("\n", lines))) };
    }

    public static GlossarySegment[] PowerShell(string path)
    {
        ScriptBlockAst ast = Parser.ParseFile(path, out Token[] tokens, out _);
        List<GlossarySegment> segments = new List<GlossarySegment>();

        foreach (Token token in tokens)
        {
            if (token.Kind != TokenKind.Comment) { continue; }
            bool isHelp = token.Text.StartsWith("<#", StringComparison.Ordinal) && HelpKeyword.IsMatch(token.Text);
            segments.Add(Segment(isHelp ? "help" : "comments", token.Extent.StartLineNumber, WithoutImmutableFacts(token.Text)));
        }

        List<Ast> carriers = new List<Ast>();
        foreach (Ast node in ast.FindAll(n => n is ThrowStatementAst, true))
        {
            PipelineBaseAst pipeline = ((ThrowStatementAst)node).Pipeline;
            if (pipeline != null) { carriers.Add(pipeline); }
        }
        foreach (Ast node in ast.FindAll(n => n is CommandAst, true))
        {
            CommandAst command = (CommandAst)node;
            IReadOnlyList<CommandElementAst> elements = command.CommandElements;
            string name = command.GetCommandName();
            bool isWriter = name != null && Writers.Contains(name);
            for (int i = 1; i < elements.Count; i++)
            {
                CommandElementAst element = elements[i];
                if (element is CommandParameterAst parameter)
                {
                    if (!MessageParameters.Contains(parameter.ParameterName)) { continue; }
                    if (parameter.Argument != null) { carriers.Add(parameter.Argument); }
                    else if (i + 1 < elements.Count) { carriers.Add(elements[i + 1]); }
                    continue;
                }
                if (isWriter) { carriers.Add(element); }
            }
        }

        HashSet<int> seen = new HashSet<int>();
        List<Ast> strings = new List<Ast>();
        foreach (Ast carrier in carriers)
        {
            foreach (Ast found in carrier.FindAll(n => n is StringConstantExpressionAst || n is ExpandableStringExpressionAst, true))
            {
                bool inExpandable = false;
                for (Ast parent = found.Parent; parent != null; parent = parent.Parent)
                {
                    if (parent is ExpandableStringExpressionAst) { inExpandable = true; break; }
                }
                if (inExpandable || !seen.Add(found.Extent.StartOffset)) { continue; }
                strings.Add(found);
            }
        }
        foreach (Ast found in strings.OrderBy(s => s.Extent.StartOffset))
        {
            string text;
            if (found is ExpandableStringExpressionAst expandable)
            {
                text = expandable.Value;
                foreach (ExpressionAst nested in expandable.NestedExpressions)
                {
                    text = text.Replace(nested.Extent.Text, " ");
                }
            }
            else
            {
                text = ((StringConstantExpressionAst)found).Value;
            }
            // A here-string's value starts on the line after its opening @" / @'.
            int line = found.Extent.StartLineNumber;
            if (found.Extent.Text.StartsWith("@", StringComparison.Ordinal)) { line++; }
            segments.Add(Segment("messages", line, text));
        }
        return segments.ToArray();
    }

    static string WithoutImmutableFacts(string comment)
    {
        if (comment == null || !comment.Contains("\n  immutable:")) { return comment; }
        string[] lines = comment.Split('\n');
        bool inImmutable = false;
        for (int i = 0; i < lines.Length; i++)
        {
            string line = lines[i].TrimEnd('\r');
            if (line == "  immutable:") { inImmutable = true; lines[i] = string.Empty; continue; }
            if (!inImmutable) { continue; }
            if (line.Length > 2 && line.StartsWith("   ", StringComparison.Ordinal)) { lines[i] = string.Empty; continue; }
            if (line.Length > 0) { inImmutable = false; }
        }
        return string.Join("\n", lines);
    }

    static GlossarySegment Segment(string surface, int line, string text) =>
        new GlossarySegment(surface, line, RemoveMentions((text ?? string.Empty).Replace("\r", string.Empty)));
}
