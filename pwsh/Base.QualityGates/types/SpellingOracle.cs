/*
---
catzc:
  docs: "../../../docs/references/pwsh/catzc-base-quality-gates/types/SpellingOracle.cs.md"
  header: "generated"
---
*/

namespace Catzc.Base.QualityGates;

using System;
using System.Collections.Generic;
using System.IO;
using System.Text;

public static class SpellingOracle
{
    public const int MinFragmentLength = 2;

    public static string AssetsFolder(string moduleRoot)
    {
        if (string.IsNullOrEmpty(moduleRoot)) { throw new ArgumentException("moduleRoot must not be empty", "moduleRoot"); }
        return new Catzc.Base.Folders.PathSet().AddFile(moduleRoot, "assets").ToArray()[0];
    }

    // The English word list the oracle loads, and the stamp of the cspell dictionaries it was built from, both in an assets folder.
    public static string DictionaryPath(string assetsFolder) => AssetFile(assetsFolder, "english.txt.gz");

    public static string DictionaryStampPath(string assetsFolder) => AssetFile(assetsFolder, "english.stamp");

    // What the oracle's verdicts depend on, for a stamp over them: its word list, its own source, and the term lists under .cspell/.
    public static string[] Inputs(string repositoryRoot, string moduleRoot)
    {
        if (string.IsNullOrEmpty(repositoryRoot)) { throw new ArgumentException("repositoryRoot must not be empty", "repositoryRoot"); }
        if (string.IsNullOrEmpty(moduleRoot)) { throw new ArgumentException("moduleRoot must not be empty", "moduleRoot"); }
        return new Catzc.Base.Folders.PathSet()
            .AddFile(AssetsFolder(moduleRoot), "english.txt.gz")
            .AddFile(moduleRoot, "types/SpellingOracle.cs")
            .AddPattern(Path.Combine(repositoryRoot, ".cspell"), "*.txt", 1)
            .ToArray();
    }

    private static string AssetFile(string assetsFolder, string name)
    {
        if (string.IsNullOrEmpty(assetsFolder)) { throw new ArgumentException("assetsFolder must not be empty", "assetsFolder"); }
        return new Catzc.Base.Folders.PathSet().AddFile(assetsFolder, name).ToArray()[0];
    }

    private static readonly object Gate = new object();
    private static HashSet<string> _words;
    private static HashSet<string> _fixtureWords;

    public static bool IsLoaded => _words != null;

    public static int WordCount => _words?.Count ?? 0;

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

    public static string[] CoinedFragments(string identifier)
    {
        return CoinedFragments(identifier, false);
    }

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
