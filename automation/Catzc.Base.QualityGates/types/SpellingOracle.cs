namespace Catzc.Base.QualityGates;

using System;
using System.Collections.Generic;
using System.IO;
using System.Text;

/// <summary> Deliberately dumb and fast: the rule picks the identifiers and exemptions, this type only tokenizes and looks up.
/// [ADR-AUTO-SPELL](/docs/adr/automation/spell-out-names.md),
/// [ADR-AUTO-TYPES#9](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types9)
/// [comment:1](/docs/references/automation/catzc-base-qualitygates/types/SpellingOracle.cs.md#comment1)
public static class SpellingOracle
{
    // Single letters are loop indices and type variables, so only fragments of two or more letters can be flagged.
    // [ADR-AUTO-SPELL#2](/docs/adr/automation/spell-out-names.md#rule-adr-auto-spell2)
    // [comment:2](/docs/references/automation/catzc-base-qualitygates/types/SpellingOracle.cs.md#comment2)
    public const int MinFragmentLength = 2;

    private static readonly object Gate = new object();
    private static HashSet<string> _words;
    private static HashSet<string> _fixtureWords;

    public static bool IsLoaded => _words != null;

    public static int WordCount => _words?.Count ?? 0;

    /// <summary> A second call is a no-op, so each analyzer shard pays the load once; fixture terms stay separate.
    /// [ADR-AUTO-SPELL#6](/docs/adr/automation/spell-out-names.md#rule-adr-auto-spell6)
    /// [comment:3](/docs/references/automation/catzc-base-qualitygates/types/SpellingOracle.cs.md#comment3)
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

    /// <summary> Fixture terms count as known only when includeFixtures is set, so a fixture token never blesses production code.
    /// [ADR-AUTO-SPELL#6](/docs/adr/automation/spell-out-names.md#rule-adr-auto-spell6)
    /// [comment:4](/docs/references/automation/catzc-base-qualitygates/types/SpellingOracle.cs.md#comment4)
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

    /// <summary>Production scope never accepts fixture terms, so a fixture token cannot bless a real identifier.</summary>
    /// [ADR-AUTO-SPELL#6](/docs/adr/automation/spell-out-names.md#rule-adr-auto-spell6)
    /// [comment:5](/docs/references/automation/catzc-base-qualitygates/types/SpellingOracle.cs.md#comment5)
    public static string[] CoinedFragments(string identifier)
    {
        return CoinedFragments(identifier, false);
    }

    /// <summary> Non-letter runs are dropped as separators, so numeric suffixes never form fragments.
    /// [comment:6](/docs/references/automation/catzc-base-qualitygates/types/SpellingOracle.cs.md#comment6)
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
