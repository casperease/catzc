// Finds the DRS codes a text cites and the rules it defines; one scanner serves a whole run, its patterns compiled once from the code form.

using System;
using System.Collections.Generic;
using System.Text.RegularExpressions;

namespace Catzc.Base.Drs;

public sealed class DrsCitationScanner
{
    // A ```yml drawio block's codes are the diagram's, not the prose's.
    private static readonly Regex DrawioBlock = new Regex(@"(?m)^```yml drawio[ \t]*\r?\n(?:(?!```)[^\r\n]*\r?\n)*```[ \t]*$");

    private readonly DrsCodeForm form;
    private readonly DrsCitationMap map;
    private readonly Regex cited;
    private readonly Regex ruleHeading;

    public DrsCitationScanner(DrsCodeForm form, DrsCitationMap map)
    {
        this.form = form ?? throw new ArgumentNullException(nameof(form));
        this.map = map;
        cited = new Regex(@"(?<![\w-])" + form.Cited + @"(?![\w#-]|:\d)");
        ruleHeading = new Regex(@"(?m)^###[ \t]+Rule[ \t]+(?<code>" + form.Rule + @")[ \t]*\r?$");
    }

    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);

    // The rules a text defines under a `### Rule <code>` heading, each once, in the order they appear.
    public string[] DefinedRules(string text)
    {
        var rules = new List<string>();
        foreach (Match match in ruleHeading.Matches(text ?? string.Empty))
        {
            string code = match.Groups["code"].Value;
            if (!rules.Contains(code)) { rules.Add(code); }
        }
        return rules.ToArray();
    }

    // The registered codes a text cites, minimized: a rule the text defines is no citation; domain codes only where the class takes them.
    public string[] Citations(string text, bool withDomain)
    {
        if (map == null) { throw new InvalidOperationException("a citation scan needs the citation map"); }
        text ??= string.Empty;
        string[] defined = withDomain ? Array.Empty<string>() : DefinedRules(text);
        string prose = DrawioBlock.Replace(text, string.Empty);
        var found = new SortedSet<string>(StringComparer.Ordinal);
        foreach (Match match in cited.Matches(prose)) { found.Add(match.Value); }
        foreach (string rule in defined) { found.Remove(rule); }
        foreach (string code in new List<string>(found))
        {
            bool own = false;
            foreach (string rule in defined)
            {
                if (rule.StartsWith(code + "-", StringComparison.Ordinal)) { own = true; break; }
            }
            bool registered = map.IsRule(code) || (map.HasCode(code) && !own) || (withDomain && map.IsDomainCode(code));
            if (!registered) { found.Remove(code); }
        }
        var minimized = form.Minimize(new List<string>(found).ToArray(), map);
        var result = new string[minimized.Count];
        for (int i = 0; i < minimized.Count; i++) { result[i] = minimized[i]; }
        return result;
    }
}
