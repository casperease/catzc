using System;
using System.Collections;
using System.Collections.Generic;
using System.Collections.Specialized;

namespace Catzc.Base.Reports;

// Rests on [ADR-AUTO-TYPES-NATIVETYPEDMODEL](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types-nativetypedmodel) and [ADR-AUTO-DEFAULT-ONERESOLUTIONORDER](/docs/adr/automation/sensible-defaults.md#rule-adr-auto-default-oneresolutionorder).
[Catzc.Base.Objects.ConsoleDisplay(nameof(Subject), nameof(IssueCount), nameof(ReportPath))]
public sealed class QualityGateResult
{
    public string Subject { get; }

    public int IssueCount => Issues.Count;

    // The issues in the order the gate found them; empty when it passed, the default.
    public IReadOnlyList<string> Issues { get; }

    public string ReportPath { get; }

    // The facts the gate counted, keyed by name in the gate's order, read-only; empty when it states none, the default.
    public IDictionary Facts { get; }

    public QualityGateResult(string subject, IEnumerable<string> issues = null, string reportPath = null, IDictionary facts = null)
    {
        if (string.IsNullOrEmpty(subject))
        {
            throw new ArgumentException("quality gate result: the subject is required", nameof(subject));
        }
        Subject = subject;
        Issues = new List<string>(issues ?? Array.Empty<string>()).AsReadOnly();
        ReportPath = reportPath ?? "";
        var ordered = new OrderedDictionary(StringComparer.Ordinal);
        if (facts != null)
        {
            foreach (DictionaryEntry entry in facts)
            {
                ordered.Add(Convert.ToString(entry.Key, System.Globalization.CultureInfo.InvariantCulture), entry.Value);
            }
        }
        Facts = ordered.AsReadOnly();
    }

    public override string ToString() => Catzc.Base.Objects.ConsoleText.ToConsoleString(this);
}
