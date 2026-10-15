/*
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/types/SentenceGuid.cs
    kind: type
    module: Catzc.Base.QualityGates
    adrs:
      - ADR-PWSH-TYPES#1
---
*/

namespace Catzc.Base.QualityGates;

using System;
using System.Collections.Generic;
using System.Text;

/// <summary> Never called by production code: it mints readable placeholder GUIDs for the managed-GUID registry.
/// [comment:1](/docs/references/automation/catzc-base-qualitygates/types/SentenceGuid.cs.md#comment1)
public static class SentenceGuid
{
    // Extending the table changes only GUIDs minted afterwards, never the ones already registered.
    // [comment:2](/docs/references/automation/catzc-base-qualitygates/types/SentenceGuid.cs.md#comment2)
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

    // The leading zero makes leading whitespace a no-op, so words align with the dash groups from the first digit.
    // [comment:3](/docs/references/automation/catzc-base-qualitygates/types/SentenceGuid.cs.md#comment3)
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
                // At a boundary this fills nothing, so runs of whitespace collapse into a single step.
                // [comment:4](/docs/references/automation/catzc-base-qualitygates/types/SentenceGuid.cs.md#comment4)
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
                // Rendering zero rather than skipping keeps one digit per character, so the sentence decodes by position.
                // [comment:5](/docs/references/automation/catzc-base-qualitygates/types/SentenceGuid.cs.md#comment5)
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
