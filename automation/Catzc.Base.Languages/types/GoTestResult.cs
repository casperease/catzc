/*
---
catzc:
  derived:
    path: automation/Catzc.Base.Languages/types/GoTestResult.cs
    kind: csharp-type
    module: Catzc.Base.Languages
    relatives:
      page: docs/references/automation/catzc-base-languages/types/GoTestResult.cs.md
      test: automation/Catzc.Base.Languages/tests/types/GoTestResult.Tests.ps1
    adrs:
      - ADR-AUTO-TEST#1
      - ADR-AUTO-TYPES#8
---
*/

using System;
using System.Collections.Generic;
using System.Globalization;

namespace Catzc.Base.Languages;

public sealed class GoTestResult
{
    public const string IntegrityPrefix = "TestIntegrity";

    private static readonly string[] Outcomes = { "pass", "fail", "skip" };

    // The Go import path of the test's package (e.g. catzc/go/tests/catzc-widget).
    public string Package { get; }

    // The top-level test function's name (e.g. TestWidgetRoot).
    public string Name { get; }

    // pass | fail | skip.
    public string Outcome { get; }

    // The elapsed time go reported for the test, in seconds.
    public double DurationSeconds { get; }

    // Everything the test (and its subtests) printed, in event order.
    public string Output { get; }

    // integrity when the name starts with TestIntegrity, else logic.
    public string Category { get; }

    public GoTestResult(string package, string name, string outcome, double durationSeconds, string output)
    {
        List<string> errors = new List<string>();
        if (string.IsNullOrWhiteSpace(package)) { errors.Add("Package is required"); }
        if (string.IsNullOrWhiteSpace(name) || !name.StartsWith("Test", StringComparison.Ordinal) || name.IndexOf('/') >= 0)
        {
            errors.Add(string.Format(CultureInfo.InvariantCulture, "Name '{0}' is not a top-level Go test name (Test*, no '/')", name));
        }
        if (Array.IndexOf(Outcomes, outcome) < 0)
        {
            errors.Add(string.Format(CultureInfo.InvariantCulture, "Outcome '{0}' is not one of: {1}", outcome, string.Join(", ", Outcomes)));
        }
        if (double.IsNaN(durationSeconds) || durationSeconds < 0)
        {
            errors.Add(string.Format(CultureInfo.InvariantCulture, "DurationSeconds '{0}' must be zero or more", durationSeconds));
        }
        if (errors.Count > 0) { throw new ArgumentException("Go test result validation failed:\n" + string.Join("\n", errors)); }

        Package = package;
        Name = name;
        Outcome = outcome;
        DurationSeconds = durationSeconds;
        Output = output ?? "";
        Category = name.StartsWith(IntegrityPrefix, StringComparison.Ordinal) ? "integrity" : "logic";
    }

    public override string ToString()
    {
        return string.Format(CultureInfo.InvariantCulture, "{0} {1}: {2}", Package, Name, Outcome);
    }
}
