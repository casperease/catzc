// The engine-set check's settings (source-conventions.yml's engine_set) and its prose and C# matchers: the execution
// engines are declared once, in the ExecutionEngines model, and never restated
// ([ADR-AUTO-ENGINE#1](/docs/adr/automation/execution-engines.md#rule-adr-auto-engine1)). Beside the mode and the
// exempt globs every source check has (SourceCheck), it reads two lists of phrase patterns, each a .NET regular
// expression with a placeholder the matcher fills from the model, so no engine name or count is a literal here:
//   count_phrases — '{count}' stands for a number word or digits; a match restates the engine count when its number is
//                   not the model's count
//   name_phrases  — '{name}' stands for any engine name; the matches of one phrase on one line restate the engine set
//                   when they name two or more engines but not all of them (a pair joined by 'and', or bracketed test
//                   titles that leave one engine out)
// The defaults are empty lists, declared once here
// ([ADR-AUTO-DEFAULT#6](/docs/adr/automation/sensible-defaults.md#rule-adr-auto-default6)): the phrases themselves live
// in the config. Matching ignores case. Property names mirror the YAML keys (snake_case,
// [ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)).

using System;
using System.Collections;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Text.RegularExpressions;

namespace Catzc.Base.QualityGates;

public sealed class EngineSetCheck : SourceCheck
{
    const string CountPlaceholder = "{count}";
    const string NamePlaceholder = "{name}";
    const RegexOptions Options = RegexOptions.IgnoreCase | RegexOptions.CultureInvariant;

    // The number words a count phrase can carry; a digit run is read as its number.
    static readonly IReadOnlyDictionary<string, int> NumberWords = new Dictionary<string, int>(StringComparer.OrdinalIgnoreCase)
    {
        ["one"] = 1,
        ["two"] = 2,
        ["both"] = 2,
        ["three"] = 3,
        ["four"] = 4,
        ["five"] = 5,
    };

    public IReadOnlyList<string> count_phrases { get; }
    public IReadOnlyList<string> name_phrases { get; }

    public EngineSetCheck(IDictionary raw) : base("engine_set", raw, new[] { "count_phrases", "name_phrases" })
    {
        count_phrases = Phrases(raw, "count_phrases", CountPlaceholder);
        name_phrases = Phrases(raw, "name_phrases", NamePlaceholder);
    }

    // Every place in a stretch of prose that restates the engine set, given the model's engine names. Each result is
    // the offset into the text, the matched text, and the message.
    public IReadOnlyList<(int Offset, string Text, string Message)> FindProse(string text, IReadOnlyCollection<string> names)
    {
        var found = new List<(int, string, string)>();
        if (string.IsNullOrEmpty(text) || names == null || names.Count == 0) { return found; }

        string allNames = string.Join(", ", names);
        string countAlternation = string.Join("|", NumberWords.Keys.Select(Regex.Escape)) + @"|\d+";
        string nameAlternation = string.Join("|", names.Select(Regex.Escape));
        var countPatterns = count_phrases.Select(p => new Regex(p.Replace(CountPlaceholder, "(?<count>" + countAlternation + ")"), Options)).ToList();
        var namePatterns = name_phrases.Select(p => new Regex(p.Replace(NamePlaceholder, "(?<name>" + nameAlternation + ")"), Options)).ToList();

        int lineStart = 0;
        while (lineStart <= text.Length)
        {
            int lineEnd = text.IndexOf('\n', lineStart);
            if (lineEnd < 0) { lineEnd = text.Length; }
            string line = text.Substring(lineStart, lineEnd - lineStart);

            foreach (Regex pattern in countPatterns)
            {
                foreach (Match match in pattern.Matches(line))
                {
                    string word = match.Groups["count"].Value;
                    int count = NumberWords.TryGetValue(word, out int named) ? named : int.Parse(word, CultureInfo.InvariantCulture);
                    if (count != names.Count)
                    {
                        found.Add((lineStart + match.Index, match.Value, string.Format(CultureInfo.InvariantCulture,
                            "'{0}' restates the engine count: the model declares {1} ({2}); say 'every engine' or read ExecutionEngines",
                            match.Value, names.Count, allNames)));
                    }
                }
            }

            foreach (Regex pattern in namePatterns)
            {
                MatchCollection matches = pattern.Matches(line);
                if (matches.Count == 0) { continue; }
                var named = new HashSet<string>(StringComparer.OrdinalIgnoreCase);
                foreach (Match match in matches)
                {
                    foreach (Capture capture in match.Groups["name"].Captures) { named.Add(capture.Value); }
                }
                if (named.Count >= 2 && named.Count < names.Count)
                {
                    Match first = matches[0];
                    found.Add((lineStart + first.Index, first.Value, string.Format(CultureInfo.InvariantCulture,
                        "'{0}' names {1} of the {2} engines ({3}); say 'every engine' or name them all",
                        first.Value, named.Count, names.Count, allNames)));
                }
            }
            lineStart = lineEnd + 1;
        }
        return found;
    }

    // Every line of C# source that restates the engine set in code: two or more distinct engine names as string
    // literals on one line (an array or collection initializer, a chain of comparisons), where ExecutionEngines.Names
    // should be read. Each result is the offset of the line's first such literal and the message.
    public static IReadOnlyList<(int Offset, string Message)> FindCSharpLists(string text, IReadOnlyCollection<string> names)
    {
        var found = new List<(int, string)>();
        if (string.IsNullOrEmpty(text) || names == null || names.Count == 0) { return found; }

        var literal = new Regex("\"(?<name>" + string.Join("|", names.Select(Regex.Escape)) + ")\"", Options);
        int lineStart = 0;
        while (lineStart <= text.Length)
        {
            int lineEnd = text.IndexOf('\n', lineStart);
            if (lineEnd < 0) { lineEnd = text.Length; }
            MatchCollection matches = literal.Matches(text.Substring(lineStart, lineEnd - lineStart));
            var named = new HashSet<string>(matches.Select(m => m.Groups["name"].Value), StringComparer.OrdinalIgnoreCase);
            if (named.Count >= 2)
            {
                found.Add((lineStart + matches[0].Index, string.Format(CultureInfo.InvariantCulture,
                    "a literal list of engine names ({0}); read ExecutionEngines.Names instead", string.Join(", ", named))));
            }
            lineStart = lineEnd + 1;
        }
        return found;
    }

    static IReadOnlyList<string> Phrases(IDictionary raw, string key, string placeholder)
    {
        var phrases = new List<string>();
        if (raw == null || !raw.Contains(key) || raw[key] == null) { return phrases; }
        if (!(raw[key] is IEnumerable list) || raw[key] is string || raw[key] is IDictionary)
        {
            throw new ArgumentException(string.Format(CultureInfo.InvariantCulture, "engine_set: {0} must be a list of patterns", key));
        }
        foreach (object item in list)
        {
            string phrase = Convert.ToString(item, CultureInfo.InvariantCulture) ?? string.Empty;
            if (!phrase.Contains(placeholder, StringComparison.Ordinal))
            {
                throw new ArgumentException(string.Format(CultureInfo.InvariantCulture, "engine_set: {0} pattern '{1}' has no {2} placeholder", key, phrase, placeholder));
            }
            try
            {
                _ = new Regex(phrase.Replace(placeholder, "(?<x>x)"), Options);
            }
            catch (ArgumentException exception)
            {
                throw new ArgumentException(string.Format(CultureInfo.InvariantCulture, "engine_set: {0} pattern '{1}' is not a valid regular expression: {2}", key, phrase, exception.Message));
            }
            phrases.Add(phrase);
        }
        return phrases;
    }
}
