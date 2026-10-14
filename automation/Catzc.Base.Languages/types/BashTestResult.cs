// One Bash test's result, as Invoke-BashTest returns it from the bats JUnit report: an `@test "<name>"` of a .bats file.
// It has the shape of GoTestResult and PythonTestResult (Package, Name, Outcome, DurationSeconds, Output, Category), so
// the harness maps every language's results the same way. A result type, so its properties are PascalCase
// ([ADR-AUTO-TYPES#8](/docs/adr/automation/BCL/native-csharp-types.md#rule-adr-auto-types8)).
//
// The category is derived here, the one place the rule lives: a test whose name starts with "integrity:" reads the
// shipped artifacts and is `integrity`; every other test is `logic`
// ([ADR-AUTO-TEST#1](/docs/adr/automation/test-automation.md#rule-adr-auto-test1)). Construction validates every
// field and reports every violation in one ArgumentException.

using System;
using System.Collections.Generic;
using System.Globalization;

namespace Catzc.Base.Languages;

public sealed class BashTestResult
{
    private static readonly string[] Outcomes = { "pass", "fail", "skip" };

    // The .bats file's path inside its test folder, '/'-separated (repository.bats, or nested/widget.bats).
    public string Package { get; }

    // The test's name, as its @test declares it (e.g. "repository root").
    public string Name { get; }

    // pass | fail | skip.
    public string Outcome { get; }

    // The elapsed time bats reported, in seconds.
    public double DurationSeconds { get; }

    // The failure or skip message and the test's output.
    public string Output { get; }

    // integrity when the name starts with "integrity:", else logic.
    public string Category { get; }

    public BashTestResult(string package, string name, string outcome, double durationSeconds, string output)
    {
        List<string> errors = new List<string>();
        if (string.IsNullOrWhiteSpace(package) || !package.EndsWith(".bats", StringComparison.Ordinal) || package.IndexOf('\\') >= 0)
        {
            errors.Add(string.Format(CultureInfo.InvariantCulture, "Package '{0}' is not a '/'-separated .bats file path", package));
        }
        if (string.IsNullOrWhiteSpace(name) || name.Trim() != name)
        {
            errors.Add(string.Format(CultureInfo.InvariantCulture, "Name '{0}' is not a Bash test name (non-empty, no leading or trailing space)", name));
        }
        if (Array.IndexOf(Outcomes, outcome) < 0)
        {
            errors.Add(string.Format(CultureInfo.InvariantCulture, "Outcome '{0}' is not one of: {1}", outcome, string.Join(", ", Outcomes)));
        }
        if (double.IsNaN(durationSeconds) || durationSeconds < 0)
        {
            errors.Add(string.Format(CultureInfo.InvariantCulture, "DurationSeconds '{0}' must be zero or more", durationSeconds));
        }
        if (errors.Count > 0) { throw new ArgumentException("Bash test result validation failed:\n" + string.Join("\n", errors)); }

        Package = package;
        Name = name;
        Outcome = outcome;
        DurationSeconds = durationSeconds;
        Output = output ?? "";
        Category = name.StartsWith(BashConfig.IntegrityPrefix, StringComparison.Ordinal) ? "integrity" : "logic";
    }

    public override string ToString()
    {
        return string.Format(CultureInfo.InvariantCulture, "{0} {1}: {2}", Package, Name, Outcome);
    }
}
