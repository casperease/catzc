// A per-engine fixture table: one row per case, one column per execution engine (pwsh, bash), so the parity of a
// behaviour across the repository's two engines reads side by side. Get-EngineCaseTable loads one from YAML; any
// subject (the time safeguard, an engine start, an importer) can keep its cases in this one shape.
//
//   subject: <what the cases exercise>
//   cases:
//     - case: <unique name>
//       pwsh: { <subject-specific fields> }     # every engine column is filled ...
//       bash: "n/a: <reason>"                   # ... or names why the case does not apply to that engine
//
// Constructing an instance validates the table, collecting every violation into one ArgumentException:
//   - only the keys subject and cases at the top, and case plus the engine columns in a case;
//   - a non-empty subject; unique, non-empty case names;
//   - every engine column present in every case, as a map or as "n/a: <reason>" with a non-empty reason — so a case
//     can never silently skip an engine.
// The columns are the repository's execution engines, read from their one declaration (ExecutionEngines.Names,
// [ADR-AUTO-ENGINE#1](/docs/adr/automation/execution-engines.md#rule-adr-auto-engine1)), so a table cannot invent one.

using System;
using System.Collections;
using System.Collections.Generic;

namespace Catzc.Tooling.Core;

public sealed class EngineCaseTable
{
    // The columns: the execution engines, declared once
    // ([ADR-AUTO-ENGINE#1](/docs/adr/automation/execution-engines.md#rule-adr-auto-engine1)), in their order.
    private static readonly IReadOnlyList<string> Engines = Catzc.Base.Engines.ExecutionEngines.Names;

    private const string NotApplicablePrefix = "n/a:";
    private static readonly string[] TopKeys = { "subject", "cases" };

    private readonly List<Hashtable> rows = new List<Hashtable>();

    // What the cases exercise.
    public string Subject { get; }

    // The case names, in file order.
    public IReadOnlyList<string> Cases { get; }

    // One row per case and engine, in file order: case, engine, fields (the column's map, or null) and not_applicable
    // (the reason, or null).
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
