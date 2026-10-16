/*
---
catzc:
  derived:
    path: automation/Catzc.Base.QualityGates/types/SentenceGuid.cs
    kind: type
    language: csharp
    filekind: cs
    track: automation
    module: Catzc.Base.QualityGates
    relatives:
      page: docs/references/automation/catzc-base-qualitygates/types/SentenceGuid.cs.md
      test: automation/Catzc.Base.QualityGates/tests/types/SentenceGuid.Tests.ps1
    adrs:
      - ADR-PWSH-TYPES#1
---
*/

namespace Catzc.Base.QualityGates;

using System;
using System.Collections.Generic;
using System.Text;

public static class SentenceGuid
{
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
