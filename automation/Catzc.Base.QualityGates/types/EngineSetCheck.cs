/*
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/types/EngineSetCheck.cs
    kind: csharp-type
    language: csharp
    track: automation
    module: Catzc.Base.QualityGates
    relatives:
      page: docs/references/automation/catzc-base-qualitygates/types/EngineSetCheck.cs.md
      test: automation/Catzc.Base.QualityGates/tests/types/EngineSetCheck.Tests.ps1
    adrs:
      - ADR-AUTO-DEFAULT#6
      - ADR-AUTO-ENGINE#1
      - ADR-AUTO-TYPES#8
---
*/

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
