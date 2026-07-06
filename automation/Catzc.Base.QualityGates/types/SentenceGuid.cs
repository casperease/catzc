namespace Catzc.Base.QualityGates;

using System;
using System.Collections.Generic;
using System.Text;

/// <summary>
/// Deterministically converts a sentence into a valid GUID whose hex digits best-effort spell the sentence
/// (leet-style: s→5, o→0, i/l→1, …). One input character yields exactly one hex digit — a character with no
/// hex look-alike becomes '0' — so the rendering is positionally stable and human-decodable; whitespace
/// instead advances to the next GUID dash group, so each word lands in its own segment
/// ("sample test data" → 5a001e00-7e57-da7a-…). The mint behind ConvertTo-Guid: run by a human or an LLM to
/// produce readable placeholder GUIDs for the managed-GUID registry (guids.yml) — never called by
/// production code. Validity is structural: any 32 hex digits form a parseable GUID, so every input yields
/// one. BCL-only (ADR-TYPES:5).
/// </summary>
public static class SentenceGuid
{
    // Visual best-guess map into the hex alphabet. Identity hex letters map to themselves; digits pass
    // through in Convert; characters absent here have no honest hex look-alike and render as '0'. The
    // table is data — extending it changes only GUIDs minted after the change, never registered ones.
    private static readonly Dictionary<char, char> Map = new Dictionary<char, char>
    {
        ['a'] = 'a',
        ['b'] = 'b',
        ['c'] = 'c',
        ['d'] = 'd',
        ['e'] = 'e',
        ['f'] = 'f',
        ['o'] = '0',
        ['i'] = '1',
        ['l'] = '1',
        ['z'] = '2',
        ['s'] = '5',
        ['g'] = '6',
        ['t'] = '7',
        ['q'] = '9',
    };

    // The digit positions where the GUID's dash groups begin and end (8-4-4-4-12). Whitespace advances to
    // the next of these, so words align with segments; 0 makes leading whitespace a no-op.
    private static readonly int[] GroupBoundaries = { 0, 8, 12, 16, 20, 32 };

    public static Guid Convert(string sentence)
    {
        if (string.IsNullOrWhiteSpace(sentence))
        {
            throw new ArgumentException("Sentence must be a non-empty, non-whitespace string.", nameof(sentence));
        }

        var hex = new StringBuilder(32);
        foreach (char raw in sentence)
        {
            if (hex.Length == 32)
            {
                break;
            }

            if (char.IsWhiteSpace(raw))
            {
                // Skip one dash down: fill to the next group boundary so the next word starts its own
                // segment. At a boundary this is a no-op, so runs of whitespace collapse.
                int boundary = NextGroupBoundary(hex.Length);
                while (hex.Length < boundary)
                {
                    hex.Append('0');
                }
                continue;
            }

            char lower = char.ToLowerInvariant(raw);
            if (lower >= '0' && lower <= '9')
            {
                hex.Append(lower);
            }
            else if (Map.TryGetValue(lower, out char mapped))
            {
                hex.Append(mapped);
            }
            else
            {
                // No hex look-alike: render '0' rather than skip, so one character is always one digit
                // and a human can decode the sentence positionally.
                hex.Append('0');
            }
        }
        while (hex.Length < 32)
        {
            hex.Append('0');
        }

        string digits = hex.ToString();
        string formatted = digits.Substring(0, 8) + "-" + digits.Substring(8, 4) + "-" + digits.Substring(12, 4)
            + "-" + digits.Substring(16, 4) + "-" + digits.Substring(20, 12);
        return Guid.Parse(formatted);
    }

    private static int NextGroupBoundary(int position)
    {
        foreach (int boundary in GroupBoundaries)
        {
            if (boundary >= position)
            {
                return boundary;
            }
        }
        return 32;
    }
}
