// The fragment check of a contract asset ([ADR-REPO-CONTRACT#6](/docs/adr/repository/api-contracts.md#rule-adr-repo-contract6)):
// the real file must contain the fragment. Each method returns its findings, one precise message per mismatch, and an
// empty list when the real file contains the fragment.
//
// MatchData, for JSON and YAML, after both sides are parsed (ContractValue is the value model). It is a key subset:
//   - an object in the fragment requires an object in the target holding every one of its keys, each value matched
//     by these same rules; the target may hold more keys;
//   - an array in the fragment requires an array in the target in which every fragment element is matched by at
//     least one target element, in any order; two fragment elements may be matched by the same target element, and
//     the target may hold more elements;
//   - a null (an empty YAML value, a JSON null) pins only that its key exists, whatever the target's value;
//   - any other scalar requires an equal target value (ContractValue.Equal: numbers by value, strings ordinally).
// A finding names the location in JSONPath form (ContractValue.MemberPath).
//
// MatchLines, for any other text: every non-blank fragment line must appear in the target, in the same order, not
// necessarily adjacent. Trailing whitespace is trimmed from every line on both sides, and nothing else, so leading
// indentation counts. Lines are matched greedily: each fragment line takes the first equal target line after the one
// the previous fragment line took. A line the target holds only at or before that point is reported as out of order.

using System;
using System.Collections;
using System.Collections.Generic;
using System.Globalization;
using System.Text.RegularExpressions;

namespace Catzc.Base.Contracts;

public static class ContractFragment
{
    private static readonly Regex LineBreak = new Regex("\r\n|\n|\r");

    public static IReadOnlyList<string> MatchData(object fragment, object target)
    {
        var findings = new List<string>();
        Match(fragment, target, "$", findings);
        return findings;
    }

    public static IReadOnlyList<string> MatchLines(string fragment, string target)
    {
        var findings = new List<string>();
        string[] targetLines = Lines(target);
        string[] fragmentLines = Lines(fragment);
        int cursor = 0;
        int previous = 0;
        for (int i = 0; i < fragmentLines.Length; i++)
        {
            string line = fragmentLines[i];
            if (line.Length == 0)
            {
                continue;
            }
            int found = Array.IndexOf(targetLines, line, cursor);
            if (found >= 0)
            {
                cursor = found + 1;
                previous = i + 1;
                continue;
            }
            if (Array.IndexOf(targetLines, line) >= 0)
            {
                findings.Add(string.Format(CultureInfo.InvariantCulture,
                    "fragment line {0} '{1}' is out of order: the target has it only at or before line {2}, where fragment line {3} matched",
                    i + 1, line, cursor, previous));
            }
            else
            {
                findings.Add(string.Format(CultureInfo.InvariantCulture,
                    "fragment line {0} '{1}' is missing from the target", i + 1, line));
            }
        }
        return findings;
    }

    private static string[] Lines(string text)
    {
        string[] lines = LineBreak.Split(text ?? string.Empty);
        for (int i = 0; i < lines.Length; i++)
        {
            lines[i] = lines[i].TrimEnd();
        }
        return lines;
    }

    private static void Match(object fragment, object target, string path, List<string> findings)
    {
        fragment = ContractValue.Unwrap(fragment);
        target = ContractValue.Unwrap(target);
        if (fragment == null)
        {
            return;
        }
        if (fragment is IDictionary map)
        {
            MatchObject(map, target, path, findings);
        }
        else if (fragment is IList list)
        {
            MatchArray(list, target, path, findings);
        }
        else if (!ContractValue.Equal(fragment, target))
        {
            findings.Add(string.Format(CultureInfo.InvariantCulture, "{0}: expected {1}, found {2}",
                path, ContractValue.Describe(fragment), ContractValue.Describe(target)));
        }
    }

    private static void MatchObject(IDictionary fragment, object target, string path, List<string> findings)
    {
        if (!(target is IDictionary targetMap))
        {
            findings.Add(string.Format(CultureInfo.InvariantCulture, "{0}: expected an object, found {1}",
                path, ContractValue.Describe(target)));
            return;
        }
        foreach (DictionaryEntry entry in fragment)
        {
            string key = ContractValue.Text(entry.Key);
            string member = ContractValue.MemberPath(path, key);
            if (ContractValue.TryGetMember(targetMap, key, out object value))
            {
                Match(entry.Value, value, member, findings);
            }
            else
            {
                findings.Add(string.Format(CultureInfo.InvariantCulture, "{0}: the key is missing from the target", member));
            }
        }
    }

    private static void MatchArray(IList fragment, object target, string path, List<string> findings)
    {
        if (!(target is IList targetList))
        {
            findings.Add(string.Format(CultureInfo.InvariantCulture, "{0}: expected an array, found {1}",
                path, ContractValue.Describe(target)));
            return;
        }
        for (int i = 0; i < fragment.Count; i++)
        {
            bool matched = false;
            foreach (object candidate in targetList)
            {
                var trial = new List<string>();
                Match(fragment[i], candidate, path, trial);
                if (trial.Count == 0)
                {
                    matched = true;
                    break;
                }
            }
            if (!matched)
            {
                findings.Add(string.Format(CultureInfo.InvariantCulture,
                    "{0}: fragment element [{1}] ({2}) is matched by no element of the target array",
                    path, i, ContractValue.Describe(fragment[i])));
            }
        }
    }
}
