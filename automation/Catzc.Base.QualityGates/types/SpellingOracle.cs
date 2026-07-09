namespace Catzc.Base.QualityGates;

using System;
using System.Collections.Generic;
using System.IO;
using System.Text;

/// <summary>
/// The word oracle behind the spell-out-names analyzer rule (Measure-SpellOutIdentifiers), backing
/// docs/adr/automation/spell-out-names.md. It answers one question fast: given an identifier, which of its
/// word fragments are neither a real English word nor approved repository vocabulary — i.e. invented local
/// abbreviations that must be spelled out.
///
/// The dictionary is a single HashSet loaded once per process from the committed english.txt.gz (flattened
/// from cspell's own dictionaries by Build-EnglishDictionary) plus every generated .cspell/*.txt term list
/// (the domain vocabulary and the conventional-abbreviation allow-list, from terminology.yml). Both the load
/// and the per-fragment lookup are here in C# rather than PowerShell on purpose: a PowerShell method call
/// costs ~10 microseconds, so tokenizing and looking up thousands of fragments per file in PowerShell would
/// dominate the analyzer's runtime, whereas the same work in C# is microseconds (ADR-AUTO-TYPES:9 — a concept the
/// platform's own logic operates on becomes a native type).
///
/// The rule decides WHICH identifiers to feed and applies AST-level exemptions (automatic variables, drive
/// scopes); this type is deliberately dumb and fast — it only tokenizes and looks up.
/// </summary>
public static class SpellingOracle
{
    // Fragments shorter than this are never flagged: single letters are loop indices / type variables
    // (ADR-AUTO-SPELL:2), which the ADR exempts.
    public const int MinFragmentLength = 2;

    private static readonly object Gate = new object();
    private static HashSet<string> _words;
    private static HashSet<string> _fixtureWords;

    public static bool IsLoaded => _words != null;

    public static int WordCount => _words?.Count ?? 0;

    /// <summary>
    /// Load the oracle once: the gzip-compressed English list plus every plain-text term list. Idempotent — a
    /// second call is a no-op, so each analyzer shard pays the load once. Fixture terms are kept SEPARATE
    /// (ADR-AUTO-SPELL:6): they are accepted only when CoinedFragments is called with includeFixtures — i.e. for a test
    /// file — so a fixture token cannot bless a real identifier in production code. Term-list lines starting
    /// with '#' (the generated-file header) and blank lines are skipped; every other token is added lower-cased.
    /// </summary>
    public static void Initialize(string englishGzPath, IEnumerable<string> termListPaths, IEnumerable<string> fixtureListPaths)
    {
        if (_words != null)
        {
            return;
        }
        lock (Gate)
        {
            if (_words != null)
            {
                return;
            }

            var words = new HashSet<string>(StringComparer.OrdinalIgnoreCase);
            if (!string.IsNullOrEmpty(englishGzPath) && File.Exists(englishGzPath))
            {
                var text = Encoding.UTF8.GetString(GzipText.Decompress(File.ReadAllBytes(englishGzPath)));
                foreach (var line in text.Split('\n'))
                {
                    var word = line.Trim();
                    if (word.Length > 0)
                    {
                        words.Add(word);
                    }
                }
            }
            LoadTermLists(words, termListPaths);

            var fixtures = new HashSet<string>(StringComparer.OrdinalIgnoreCase);
            LoadTermLists(fixtures, fixtureListPaths);

            _fixtureWords = fixtures;
            _words = words;
        }
    }

    private static void LoadTermLists(HashSet<string> target, IEnumerable<string> paths)
    {
        if (paths == null)
        {
            return;
        }
        foreach (var path in paths)
        {
            if (string.IsNullOrEmpty(path) || !File.Exists(path))
            {
                continue;
            }
            foreach (var line in File.ReadLines(path))
            {
                var word = line.Trim();
                if (word.Length > 0 && word[0] != '#')
                {
                    target.Add(word);
                }
            }
        }
    }

    /// <summary>True when the fragment (already lower-cased) is a known English word or approved term.</summary>
    public static bool IsKnown(string fragment)
    {
        EnsureLoaded();
        return _words.Contains(fragment);
    }

    /// <summary>
    /// Split an identifier into word fragments and return those (length >= MinFragmentLength) that are not in
    /// the dictionary — the invented abbreviations to spell out. Returns an empty array for a fully
    /// spelled-out identifier. Fixture terms count as known only when <paramref name="includeFixtures"/> is set
    /// (the caller passes true only for a test file), so a fixture token never blesses a production identifier
    /// (ADR-AUTO-SPELL:6).
    /// </summary>
    public static string[] CoinedFragments(string identifier, bool includeFixtures)
    {
        EnsureLoaded();
        if (string.IsNullOrEmpty(identifier))
        {
            return Array.Empty<string>();
        }

        var coined = new List<string>();
        foreach (var fragment in Tokenize(identifier))
        {
            if (fragment.Length < MinFragmentLength)
            {
                continue;
            }
            if (_words.Contains(fragment))
            {
                continue;
            }
            if (includeFixtures && _fixtureWords.Contains(fragment))
            {
                continue;
            }
            coined.Add(fragment);
        }
        return coined.ToArray();
    }

    /// <summary>Production-scope overload: fixture terms are not accepted (ADR-AUTO-SPELL:6).</summary>
    public static string[] CoinedFragments(string identifier)
    {
        return CoinedFragments(identifier, false);
    }

    /// <summary>
    /// Split on non-letters (snake_case underscores, digits) and case boundaries: a camelCase hump
    /// (rule|Collection) and an acronym-to-word seam (HTTP|Server, IO|Stream). Each fragment is returned
    /// lower-cased; non-letter runs are separators and are dropped, so numeric suffixes never form fragments.
    /// </summary>
    public static IEnumerable<string> Tokenize(string identifier)
    {
        var builder = new StringBuilder();
        for (var i = 0; i < identifier.Length; i++)
        {
            var current = identifier[i];
            if (!char.IsLetter(current))
            {
                if (builder.Length > 0)
                {
                    yield return builder.ToString().ToLowerInvariant();
                    builder.Clear();
                }
                continue;
            }

            if (builder.Length > 0)
            {
                var previous = identifier[i - 1];
                var camelBoundary = char.IsUpper(current) && !char.IsUpper(previous);
                var acronymBoundary = char.IsUpper(current) && char.IsUpper(previous) &&
                    i + 1 < identifier.Length && char.IsLower(identifier[i + 1]);
                if (camelBoundary || acronymBoundary)
                {
                    yield return builder.ToString().ToLowerInvariant();
                    builder.Clear();
                }
            }
            builder.Append(current);
        }
        if (builder.Length > 0)
        {
            yield return builder.ToString().ToLowerInvariant();
        }
    }

    private static void EnsureLoaded()
    {
        if (_words == null)
        {
            throw new InvalidOperationException(
                "SpellingOracle.Initialize must be called before use (pass english.txt.gz and the .cspell/*.txt term lists).");
        }
    }
}
