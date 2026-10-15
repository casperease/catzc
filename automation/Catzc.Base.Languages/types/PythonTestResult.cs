/*
---
catzc:
  derived:
    path: automation/Catzc.Base.Languages/types/PythonTestResult.cs
    kind: type
    module: Catzc.Base.Languages
---
*/

// The category is derived here, the one place the rule lives: a name starting test_integrity is integrity, all else logic.
// [ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8),
// [ADR-AUTO-TEST#1](/docs/adr/automation/test-automation.md#rule-adr-auto-test1)
// [comment:1](/docs/references/automation/catzc-base-languages/types/PythonTestResult.cs.md#comment1)

using System;
using System.Collections.Generic;
using System.Globalization;

namespace Catzc.Base.Languages;

public sealed class PythonTestResult
{
    private static readonly string[] Outcomes = { "pass", "fail", "skip" };

    // The test file's module path inside its test folder, dotted (test_widget, or nested.test_widget).
    public string Package { get; }

    // The top-level test function's name (e.g. test_widget_root), without a parametrisation suffix.
    public string Name { get; }

    // pass | fail | skip.
    public string Outcome { get; }

    // The elapsed time pytest reported, summed over the parametrised cases, in seconds.
    public double DurationSeconds { get; }

    // The failure, error and skip messages and captured output, in report order.
    public string Output { get; }

    // integrity when the name starts with test_integrity, else logic.
    public string Category { get; }

    public PythonTestResult(string package, string name, string outcome, double durationSeconds, string output)
    {
        List<string> errors = new List<string>();
        if (string.IsNullOrWhiteSpace(package)) { errors.Add("Package is required"); }
        if (string.IsNullOrWhiteSpace(name) || !name.StartsWith("test", StringComparison.Ordinal) || name.IndexOf('[') >= 0 || name.IndexOf('.') >= 0)
        {
            errors.Add(string.Format(CultureInfo.InvariantCulture, "Name '{0}' is not a top-level Python test name (test*, no '[' or '.')", name));
        }
        if (Array.IndexOf(Outcomes, outcome) < 0)
        {
            errors.Add(string.Format(CultureInfo.InvariantCulture, "Outcome '{0}' is not one of: {1}", outcome, string.Join(", ", Outcomes)));
        }
        if (double.IsNaN(durationSeconds) || durationSeconds < 0)
        {
            errors.Add(string.Format(CultureInfo.InvariantCulture, "DurationSeconds '{0}' must be zero or more", durationSeconds));
        }
        if (errors.Count > 0) { throw new ArgumentException("Python test result validation failed:\n" + string.Join("\n", errors)); }

        Package = package;
        Name = name;
        Outcome = outcome;
        DurationSeconds = durationSeconds;
        Output = output ?? "";
        Category = name.StartsWith(PythonConfig.IntegrityPrefix, StringComparison.Ordinal) ? "integrity" : "logic";
    }

    public override string ToString()
    {
        return string.Format(CultureInfo.InvariantCulture, "{0} {1}: {2}", Package, Name, Outcome);
    }
}
