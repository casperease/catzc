/*
---
catzc:
  immutable:
    path: automation/Catzc.Tooling.Core/types/EngineCaseTable.cs
    folder: types
    name: engine-case-table
    filetype: cs
    kind: type
    language: csharp
    track: automation
    tracktype: modules
    module: Catzc.Tooling.Core
    moduletype: pwsh-folder
    catzc_bundle: azure
  edges:
    page: docs/references/automation/catzc-tooling-core/types/EngineCaseTable.cs.md
    test: automation/Catzc.Tooling.Core/tests/types/EngineCaseTable.Tests.ps1
    cites:
      - ADR-AUTO-ENGINE#1
---
*/

using System;
using System.Collections;
using System.Collections.Generic;

namespace Catzc.Tooling.Core;

public sealed class EngineCaseTable
{
    private static readonly IReadOnlyList<string> Engines = Catzc.Base.Engines.ExecutionEngines.Names;

    private const string NotApplicablePrefix = "n/a:";
    private static readonly string[] TopKeys = { "subject", "cases" };

    private readonly List<Hashtable> rows = new List<Hashtable>();

    // What the cases exercise.
    public string Subject { get; }

    // The case names, in file order.
    public IReadOnlyList<string> Cases { get; }

    public IReadOnlyList<Hashtable> Rows { get { return rows; } }

    public EngineCaseTable(IDictionary d)
    {
        List<string> errors = new List<string>();
        List<string> names = new List<string>();
        if (d == null)
        {
            throw new ArgumentException("engine case table validation failed:\nthe table is empty (needs subject and cases)");
        }
        CheckKeys(d, TopKeys, "", errors);

        string subject = d.Contains("subject") ? d["subject"] as string : null;
        if (string.IsNullOrWhiteSpace(subject))
        {
            errors.Add("missing subject (what the cases exercise)");
        }
        Subject = subject == null ? null : subject.Trim();

        IList cases = d.Contains("cases") ? d["cases"] as IList : null;
        if (cases == null || d["cases"] is string || cases.Count == 0)
        {
            errors.Add("missing cases (a non-empty list of cases)");
        }
        else
        {
            for (int i = 0; i < cases.Count; i++)
            {
                ReadCase(cases[i], i, names, errors);
            }
        }

        if (errors.Count > 0)
        {
            throw new ArgumentException("engine case table validation failed:\n" + string.Join("\n", errors));
        }
        Cases = names;
    }

    private void ReadCase(object value, int index, List<string> names, List<string> errors)
    {
        string path = "cases[" + index + "]";
        IDictionary entry = value as IDictionary;
        if (entry == null)
        {
            errors.Add(string.Format("invalid {0} (must be a map of case and the engine columns)", path));
            return;
        }
        List<string> allowed = new List<string>(Engines);
        allowed.Insert(0, "case");
        CheckKeys(entry, allowed.ToArray(), path + ".", errors);

        string name = entry.Contains("case") ? entry["case"] as string : null;
        if (string.IsNullOrWhiteSpace(name))
        {
            errors.Add(string.Format("invalid {0}: missing case (a name for the case)", path));
            return;
        }
        name = name.Trim();
        if (names.Contains(name))
        {
            errors.Add(string.Format("duplicate case '{0}'", name));
            return;
        }
        names.Add(name);

        foreach (string engine in Engines)
        {
            object cell = entry.Contains(engine) ? entry[engine] : null;
            IDictionary fields = cell as IDictionary;
            string text = cell as string;
            if (fields != null)
            {
                rows.Add(Row(name, engine, fields, null));
            }
            else if (text != null && text.StartsWith(NotApplicablePrefix, StringComparison.Ordinal) &&
                text.Substring(NotApplicablePrefix.Length).Trim().Length > 0)
            {
                rows.Add(Row(name, engine, null, text.Substring(NotApplicablePrefix.Length).Trim()));
            }
            else
            {
                errors.Add(string.Format(
                    "case '{0}': the {1} column must be a map, or \"n/a: <reason>\" naming why the case does not apply", name, engine));
            }
        }
    }

    private static Hashtable Row(string name, string engine, IDictionary fields, string notApplicable)
    {
        Hashtable copy = null;
        if (fields != null)
        {
            copy = new Hashtable(StringComparer.OrdinalIgnoreCase);
            foreach (DictionaryEntry field in fields) { copy[field.Key.ToString()] = field.Value; }
        }
        return new Hashtable(StringComparer.OrdinalIgnoreCase)
        {
            { "case", name },
            { "engine", engine },
            { "fields", copy },
            { "not_applicable", notApplicable },
        };
    }

    private static void CheckKeys(IDictionary d, string[] allowed, string prefix, List<string> errors)
    {
        foreach (object k in d.Keys)
        {
            string key = k == null ? null : k.ToString();
            if (Array.IndexOf(allowed, key) < 0)
            {
                errors.Add(string.Format("unknown key '{0}{1}' (allowed: {2})", prefix, key, string.Join(", ", allowed)));
            }
        }
    }

    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);
}
