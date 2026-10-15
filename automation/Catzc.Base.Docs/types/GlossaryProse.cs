// The prose of one file, as the glossary checks read it (G4, G6): never a regex over source text
// ([ADR-REPO-VOCAB#5](/docs/adr/repository/controlled-vocabulary.md#rule-adr-repo-vocab5)).
//   Markdown    the whole file as one 'markdown' segment, fenced code blocks blanked;
//   PowerShell  the real parser's tokens and AST: 'help' (a block comment holding .SYNOPSIS or .DESCRIPTION),
//               'comments' (every other comment), and 'messages' — the strings passed to throw, Write-Message,
//               Write-Warning, Write-Error or Write-Host, and the value of any -ErrorText or -Because parameter. A
//               constant string gives its value; an expandable string its value with every embedded variable or
//               sub-expression removed. A string several of those contexts hold is read once.
// Every segment's mentions — `code`, "quoted" and “curly-quoted” spans that do not cross a blank line — are blanked to
// spaces (RemoveMentions), and it carries the line it starts on, so a match's offset maps to its line. Markdown also
// blanks what is not prose: a link or image destination, the `(path)` after `]`, and the title line that names the
// file's own repository path ([ADR-REPO-FORMAT#6](/docs/adr/repository/uniform-formatting.md#rule-adr-repo-format6)).

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
    static readonly Regex PathTitle = new Regex(@"^# \S+/\S+\.md$", RegexOptions.Compiled);
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
        for (int i = 0; i < lines.Length; i++)
        {
            Match marker = FenceMarker.Match(lines[i].TrimStart());
            if (fence == null)
            {
                if (marker.Success)
                {
                    fence = marker.Value;
                    lines[i] = string.Empty;
                }
                else if (PathTitle.IsMatch(lines[i]))
                {
                    lines[i] = string.Empty;
                }
                else
                {
                    lines[i] = LinkDestination.Replace(lines[i], m => "](" + new string(' ', m.Groups[1].Length));
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
            segments.Add(Segment(isHelp ? "help" : "comments", token.Extent.StartLineNumber, token.Text));
        }

        // The argument elements that carry a message: everything after the command name of a writer, the operand of
        // throw, and the value of -ErrorText / -Because on any command.
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
                // A string inside an expandable string's sub-expression is code, not message text: its parent string
                // drops it with the rest of the sub-expression.
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

    static GlossarySegment Segment(string surface, int line, string text) =>
        new GlossarySegment(surface, line, RemoveMentions((text ?? string.Empty).Replace("\r", string.Empty)));
}
