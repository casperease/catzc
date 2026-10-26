/*
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-drs/types/DrsCitationForm.cs.md"
  header: "generated"
---
*/

using System;
using System.Collections.Generic;
using System.Text;
using System.Text.RegularExpressions;

using static Catzc.Base.Drs.DrsCitationText;

namespace Catzc.Base.Drs;

public static class DrsCitationForm
{
    static readonly Regex Definition = new Regex(@"^ {0,3}\[(?<label>[^\]\r\n]+)\]:[ \t]*(?<dest>\S+)", RegexOptions.Compiled | RegexOptions.Multiline);
    static readonly Regex NumberedLabel = new Regex(@"^r(?<n>[1-9][0-9]*)$", RegexOptions.Compiled);

    public static string ToReference(string text, string path, ISet<int> lines, int width, string codePattern, List<DrsCitationChange> changes)
    {
        if (text == null) { throw new ArgumentNullException(nameof(text)); }
        if (width <= 0 || lines == null || lines.Count == 0) { return text; }
        var inline = new Regex(@"(?<!\\)\[(?<code>" + codePattern + @")\]\((?<dest>[^)\s]+)\)", RegexOptions.Compiled);

        var labelOf = new Dictionary<string, string>(StringComparer.Ordinal);
        int highest = 0;
        foreach (Match match in Definition.Matches(text))
        {
            string label = match.Groups["label"].Value;
            if (!labelOf.ContainsKey(match.Groups["dest"].Value)) { labelOf[match.Groups["dest"].Value] = label; }
            Match numbered = NumberedLabel.Match(label);
            if (numbered.Success) { highest = Math.Max(highest, int.Parse(numbered.Groups["n"].Value, System.Globalization.CultureInfo.InvariantCulture)); }
        }

        string newline = text.Contains("\r\n") ? "\r\n" : "\n";
        string[] split = text.Split('\n');
        var added = new List<string>();
        foreach (int number in lines)
        {
            int index = number - 1;
            if (index < 0 || index >= split.Length) { continue; }
            string line = split[index].TrimEnd('\r');
            if (line.Length <= width) { continue; }
            var links = new List<Match>();
            foreach (Match match in inline.Matches(line)) { links.Add(match); }
            links.Sort((left, right) => right.Groups["dest"].Length.CompareTo(left.Groups["dest"].Length));
            string respelled = line;
            foreach (Match link in links)
            {
                if (respelled.Length <= width) { break; }
                string code = link.Groups["code"].Value;
                string destination = link.Groups["dest"].Value;
                if (!labelOf.TryGetValue(destination, out string label))
                {
                    label = "r" + (++highest).ToString(System.Globalization.CultureInfo.InvariantCulture);
                    labelOf[destination] = label;
                    added.Add("[" + label + "]: " + destination);
                }
                string reference = "[" + code + "][" + label + "]";
                int at = respelled.IndexOf(link.Value, StringComparison.Ordinal);
                respelled = respelled.Substring(0, at) + reference + respelled.Substring(at + link.Value.Length);
                changes.Add(new DrsCitationChange(path, number, DrsCitationChangeKind.Form, link.Value, reference));
            }
            if (respelled != line) { split[index] = respelled + (split[index].EndsWith("\r", StringComparison.Ordinal) ? "\r" : string.Empty); }
        }
        if (added.Count == 0) { return string.Join("\n", split); }

        var output = new StringBuilder(string.Join("\n", split).TrimEnd('\r', '\n'));
        bool endsInDefinition = Definition.IsMatch(LastLine(output.ToString()));
        output.Append(newline);
        if (!endsInDefinition) { output.Append(newline); }
        foreach (string definition in added) { output.Append(definition).Append(newline); }
        return output.ToString();
    }

    static string LastLine(string text)
    {
        int last = text.LastIndexOf('\n');
        return (last >= 0 ? text.Substring(last + 1) : text).TrimEnd('\r');
    }
}
