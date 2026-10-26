namespace Catzc.Base.Objects;

using System;
using System.Collections.Generic;
using System.Text;

// Turns a sentence into a valid GUID whose hex digits best-effort spell it, one input character to one hex digit.
public static class SentenceGuid
{
    // A visual best-guess map into the hex alphabet; a character absent here has no honest hex look-alike.
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

    // Where the GUID's 8-4-4-4-12 dash groups begin and end; whitespace advances to the next, so words align with segments.
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
                // Fill to the next group boundary, so the next word starts its own segment; runs of whitespace collapse.
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
