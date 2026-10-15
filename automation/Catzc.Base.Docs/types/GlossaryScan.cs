// catzc:
//   path: automation/Catzc.Base.Docs/types/GlossaryScan.cs
//   module: Catzc.Base.Docs

// A file's prose is read once per run via the surface cache, and hits come sorted by file, line and message, de-duplicated.
// [comment:1](/docs/references/automation/catzc-base-docs/types/GlossaryScan.cs.md#comment1)

using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text.RegularExpressions;

namespace Catzc.Base.Docs;

public static class GlossaryScan
{
    static readonly Regex PowerShellFile = new Regex(@"\.psm?1$", RegexOptions.IgnoreCase | RegexOptions.Compiled);
    static readonly Regex Number = new Regex(@"^\d+$", RegexOptions.Compiled);
    static readonly Regex Whitespace = new Regex(@"\s+", RegexOptions.Compiled);

    // Function words never count as qualifiers, so a phrase like the gate or only slots does not demand a listed form.
    // [comment:2](/docs/references/automation/catzc-base-docs/types/GlossaryScan.cs.md#comment2)
    static readonly HashSet<string> FunctionWords = new HashSet<string>(new[]
    {
        "a", "an", "the", "this", "that", "these", "those", "each", "every", "any", "all", "no", "some", "both", "either",
        "neither", "its", "their", "our", "your", "my", "his", "her", "which", "whose", "what", "same", "other", "another",
        "own", "one", "two", "three", "four", "five", "first", "second", "last", "next", "single", "per", "more", "most",
        "many", "few", "several", "s", "and", "or", "nor", "but", "of", "for", "to", "in", "on", "at", "by", "with", "from",
        "into", "onto", "across", "between", "within", "without", "via", "than", "then", "as", "is", "are", "was", "be",
        "only", "also", "not", "just", "even", "against", "about", "over", "under", "after", "before", "behind", "through",
        "around", "along", "among", "beyond", "during", "except", "inside", "outside", "toward", "towards", "upon", "past",
        "off", "out", "up", "down", "since", "until", "versus", "vs"
    }, StringComparer.OrdinalIgnoreCase);

    sealed class Hit
    {
        public string File;
        public int Line;
        public string Message;
    }

    sealed class Source
    {
        public GlossaryOptions Options;
        public readonly List<GlossaryEntry> Entries = new List<GlossaryEntry>();
    }

    public static string[] Phrasing(IEnumerable<GlossaryEntry> entries, IEnumerable<string> trackedFiles, string root, IDictionary surfaceCache)
    {
        List<Hit> hits = new List<Hit>();
        foreach (Source source in Sources(entries, e => e.Options.checks.Contains("avoid") && e.Concept.avoid.Count > 0))
        {
            var avoids = source.Entries.SelectMany(e => e.Concept.avoid.Select(a => new
            {
                a.phrase,
                a.say,
                e.Concept.defined_by,
                Pattern = new Regex("(?<![\\w-])" + string.Join("\\s+", Whitespace.Split(a.phrase).Select(Regex.Escape)) + "(?![\\w-])", RegexOptions.IgnoreCase),
            })).ToList();
            foreach ((string file, GlossarySegment segment) in Segments(source, trackedFiles, root, surfaceCache))
            {
                foreach (var avoid in avoids)
                {
                    foreach (Match match in avoid.Pattern.Matches(segment.Text))
                    {
                        int line = LineOf(segment, match.Index);
                        hits.Add(new Hit { File = file, Line = line, Message = $"{file}:{line} says \"{avoid.phrase}\" — say \"{avoid.say}\" ({avoid.defined_by})" });
                    }
                }
            }
        }
        return Sorted(hits);
    }

    public static string[] Forms(IEnumerable<GlossaryEntry> entries, IEnumerable<string> trackedFiles, string root, IDictionary surfaceCache)
    {
        List<Hit> hits = new List<Hit>();
        foreach (Source source in Sources(entries, e => e.Options.checks.Contains("forms") && e.Concept.forms.Count > 0))
        {
            var concepts = source.Entries.Select(e =>
            {
                string[] words = Regex.Split(e.Concept.term, "[ -]");
                string head = words[words.Length - 1];
                string stem = head.EndsWith("e", StringComparison.Ordinal) ? head.Substring(0, head.Length - 1) : head;
                return new
                {
                    e.Concept.term,
                    e.Concept.defined_by,
                    Allowed = new HashSet<string>(e.Concept.forms, StringComparer.OrdinalIgnoreCase),
                    Forms = string.Join(", ", e.Concept.forms.Select(f => f + " " + head).Concat(new[] { head })),
                    // A word after a dot is a keyword, not a qualifier, so a help line such as .PARAMETER Slot is not flagged.
                    // [comment:3](/docs/references/automation/catzc-base-docs/types/GlossaryScan.cs.md#comment3)
                    Qualified = new Regex("(?<![A-Za-z0-9.])(?<q>[A-Za-z0-9]+)(?:[ \\t]+|[ \\t]*\\n[ \\t]*|-)(?<w>" + Regex.Escape(head) + "s?)(?![\\w-])", RegexOptions.IgnoreCase),
                    // A verb form counts after a hyphen too (`double-gated`).
                    e.Concept.verbs,
                    Verb = new Regex("(?<![A-Za-z0-9])(?<w>" + Regex.Escape(stem) + "(?:ed|ing))(?![\\w-])", RegexOptions.IgnoreCase),
                };
            }).ToList();
            foreach ((string file, GlossarySegment segment) in Segments(source, trackedFiles, root, surfaceCache))
            {
                foreach (var concept in concepts)
                {
                    List<Match> uses = new List<Match>();
                    foreach (Match match in concept.Qualified.Matches(segment.Text))
                    {
                        string qualifier = match.Groups["q"].Value;
                        if (!concept.Allowed.Contains(qualifier) && !FunctionWords.Contains(qualifier) && !Number.IsMatch(qualifier))
                        {
                            uses.Add(match);
                        }
                    }
                    if (!concept.verbs)
                    {
                        foreach (Match match in concept.Verb.Matches(segment.Text)) { uses.Add(match); }
                    }
                    foreach (Match match in uses)
                    {
                        int line = LineOf(segment, match.Index);
                        string use = Whitespace.Replace(match.Value, " ");
                        hits.Add(new Hit { File = file, Line = line, Message = $"{file}:{line} says \"{use}\" — \"{concept.term}\" takes only: {concept.Forms} ({concept.defined_by})" });
                    }
                }
            }
        }
        return Sorted(hits);
    }

    // The glossary sources whose entries pass the check's filter, in first-seen order, each with those entries.
    static IEnumerable<Source> Sources(IEnumerable<GlossaryEntry> entries, Func<GlossaryEntry, bool> applies)
    {
        Dictionary<string, Source> byPath = new Dictionary<string, Source>(StringComparer.Ordinal);
        List<Source> ordered = new List<Source>();
        foreach (GlossaryEntry entry in entries)
        {
            if (!applies(entry)) { continue; }
            if (!byPath.TryGetValue(entry.SourcePath, out Source source))
            {
                source = new Source { Options = entry.Options };
                byPath[entry.SourcePath] = source;
                ordered.Add(source);
            }
            source.Entries.Add(entry);
        }
        return ordered;
    }

    // A file's prose is parsed on first use and cached, so many sources over one file cost a single read.
    // [comment:4](/docs/references/automation/catzc-base-docs/types/GlossaryScan.cs.md#comment4)
    static IEnumerable<(string, GlossarySegment)> Segments(Source source, IEnumerable<string> trackedFiles, string root, IDictionary surfaceCache)
    {
        Catzc.Base.Globs.GlobPattern[] scope = source.Options.scope.Select(p => new Catzc.Base.Globs.GlobPattern(p)).ToArray();
        Catzc.Base.Globs.GlobPattern[] exclude = source.Options.exclude.Select(p => new Catzc.Base.Globs.GlobPattern(p)).ToArray();
        HashSet<string> surfaces = new HashSet<string>(source.Options.surfaces, StringComparer.OrdinalIgnoreCase);
        foreach (string file in trackedFiles)
        {
            bool isMarkdown = file.EndsWith(".md", StringComparison.OrdinalIgnoreCase);
            bool isPowerShell = PowerShellFile.IsMatch(file);
            if (!(isMarkdown || isPowerShell)) { continue; }
            if (!scope.Any(p => p.Matches(file)) || exclude.Any(p => p.Matches(file))) { continue; }
            string fullPath = Path.Combine(root, file);
            if (!File.Exists(fullPath)) { continue; }   // a tracked file deleted in the working tree has no prose to read
            if (!surfaceCache.Contains(file))
            {
                surfaceCache[file] = isMarkdown ? GlossaryProse.Markdown(fullPath) : GlossaryProse.PowerShell(fullPath);
            }
            if (!(surfaceCache[file] is IEnumerable cached)) { continue; }
            foreach (object item in cached)
            {
                if (item is GlossarySegment segment && surfaces.Contains(segment.Surface)) { yield return (file, segment); }
            }
        }
    }

    static int LineOf(GlossarySegment segment, int index)
    {
        int line = segment.Line;
        for (int i = 0; i < index; i++)
        {
            if (segment.Text[i] == '\n') { line++; }
        }
        return line;
    }

    // Sorted by file, line and message, duplicates removed — case-insensitive, as the checks' PowerShell sort was.
    static string[] Sorted(List<Hit> hits)
    {
        StringComparer text = StringComparer.CurrentCultureIgnoreCase;
        return hits
            .OrderBy(h => h.File, text).ThenBy(h => h.Line).ThenBy(h => h.Message, text)
            .GroupBy(h => (h.File.ToUpperInvariant(), h.Line, h.Message.ToUpperInvariant()))
            .Select(g => g.First().Message)
            .ToArray();
    }
}
